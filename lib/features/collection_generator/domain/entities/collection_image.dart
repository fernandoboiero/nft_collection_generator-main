import 'dart:typed_data';

import 'package:nft_generator/core/infrastructure/entity.dart';

abstract class CollectionImage extends Entity {
  final Uint8List bytes;
  final String path;
  final String name;
  final String mimeType;
  late int layerIndex;

  CollectionImage({
    required this.bytes,
    required this.name,
    required this.mimeType,
    required this.path,
    required this.layerIndex,
  });
}
