import 'dart:convert';
import 'dart:typed_data';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_image.dart';

class CollectionImageModel extends CollectionImage {
  CollectionImageModel({
    required Uint8List bytes,
    required String name,
    required String mimeType,
    required String path,
    required int layerIndex,
  }) : super(
          bytes: bytes,
          name: name,
          mimeType: mimeType,
          path: path,
          layerIndex: layerIndex,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'base64': base64.encode(bytes),
      'name': name,
      'mimeType': mimeType,
      'path': path,
      'layerIndex': layerIndex,
    };
  }

  factory CollectionImageModel.fromJson({required Map map}) {
    return CollectionImageModel(
      bytes: Uint8List.fromList(base64Decode(map['base64'])),
      mimeType: map['mimeType'],
      name: 'image.png',
      path: map['path'],
      layerIndex: 0
    );
  }
}
