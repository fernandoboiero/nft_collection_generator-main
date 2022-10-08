import 'package:nft_generator/core/infrastructure/entity.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_image.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_layer.dart';

abstract class Collection extends Entity {
  String name;
  String detail;
  String authorName;
  String authorEmail;
  CollectionImage? bannerImage;
  List<CollectionLayer> layers;

  Collection({
    required this.name,
    required this.detail,
    required this.authorName,
    required this.authorEmail,
    required this.layers,
    required this.bannerImage,
  });
}
