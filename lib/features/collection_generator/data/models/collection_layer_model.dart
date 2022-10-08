import 'package:nft_generator/features/collection_generator/data/models/collection_image_model.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_image.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_layer.dart';

class CollectionLayerModel extends CollectionLayer {
  CollectionLayerModel({
    required String name,
    bool isRare = false,
    required List<CollectionImage> images,
  }) : super(name: name, images: images);

  factory CollectionLayerModel.fromJson({required Map<String, dynamic> map}) {
    var list = map['images']
        .map<CollectionImage>((a) => CollectionImageModel.fromJson(map: a))
        .toList();
    return CollectionLayerModel(
      name: map['name'],
      isRare: map['isRare'],
      images: list,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isRare': isRare,
      'index': index,
      'images': images.map((e) => e.toJson()).toList(),
    };
  }
}
