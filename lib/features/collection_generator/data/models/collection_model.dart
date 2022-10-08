import 'dart:convert';

import 'package:nft_generator/features/collection_generator/data/models/collection_layer_model.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_image.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_layer.dart';

class CollectionModel extends Collection {
  CollectionModel({
    required String name,
    required String authorEmail,
    required String authorName,
    required String detail,
    required List<CollectionLayer> layers,
    CollectionImage? bannerImage,
  }) : super(
          name: name,
          layers: layers,
          authorEmail: authorEmail,
          authorName: authorName,
          detail: detail,
          bannerImage: bannerImage,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'authorEmail': authorEmail,
      'authorName': authorName,
      'detail': detail,
      'banner': bannerImage != null ? base64.encode(bannerImage!.bytes) : "",
      'layers': layers.map((e) => e.toJson()).toList(),
    };
  }

  factory CollectionModel.fromJson({required Map<String, dynamic> map}) {
    var list = map['layers']
        .map<CollectionLayerModel>((a) => CollectionLayerModel.fromJson(map: a))
        .toList();
    return CollectionModel(
      name: map['name'],
      authorEmail: map['authorEmail'],
      authorName: map['authorName'],
      detail: map['detail'],
      layers: list,
      bannerImage: map['banner'],
    );
  }
}
