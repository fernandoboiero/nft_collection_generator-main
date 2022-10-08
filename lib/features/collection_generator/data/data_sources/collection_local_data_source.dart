import 'package:nft_generator/core/local_storage/local_storage_base.dart';
import 'package:nft_generator/features/collection_generator/data/models/collection_model.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection.dart';

abstract class CollectionLocalDataSourceBase {
  final LocalStorageBase storage;

  CollectionLocalDataSourceBase({required this.storage});

  bool saveCollection({required Collection collection});

  Collection getCollection();
}

class CollectionLocalDataSource extends CollectionLocalDataSourceBase {
  CollectionLocalDataSource({required LocalStorageBase storage})
      : super(storage: storage);

  @override
  Collection getCollection() {
    var storedData = storage.read(key: 'collection');
    return CollectionModel.fromJson(map: storedData);
  }

  @override
  bool saveCollection({required Collection collection}) {
    print(collection);
    print(collection.toJson());
    storage.save(key: 'collection', value: collection.toJson());
    return true;
  }
}
