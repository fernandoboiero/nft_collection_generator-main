import 'package:nft_generator/core/infrastructure/http_service.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_image.dart';

abstract class CollectionRemoteDataSourceBase {
  final HttpServiceBase httpService;

  CollectionRemoteDataSourceBase(this.httpService);

  Future<bool> saveCollection(Collection collection);
}

class CollectionRemoteDataSource extends CollectionRemoteDataSourceBase {
  CollectionRemoteDataSource({required HttpServiceBase httpService})
      : super(httpService);

  @override
  Future<bool> saveCollection(Collection collection) async {
    var nullIndex = [];
    var map = {};
    List<CollectionImage> images = [];

    var index = 0;
    for (var i = 0; i < collection.layers.length; i++) {
      for (var e = 0; e < collection.layers[i].images.length; e++) {
        map['$index'] = ["variables.images.$index"];
        index += 1;
        collection.layers[i].images[e].layerIndex = collection.layers[i].index;
        images.add(collection.layers[i].images[e]);
        nullIndex.add(null);
      }
    }


    var query = ''' 
      Mutation(\$input: CreateCollectionInput!) { createCollection(input: \$input) { _id } } 
    ''';
    var response =
        await httpService.mutation(query, {"input": collection.toJson()});
    return true;
  }
}
