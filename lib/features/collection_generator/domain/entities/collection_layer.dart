import 'package:nft_generator/core/infrastructure/entity.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_image.dart';
import 'package:nft_generator/features/drag_and_drop/presentation/pages/drag_and_drop_page.dart';

abstract class CollectionLayer extends Entity {
  String name;
  List<CollectionImage> images;
  late int index;
  bool selected, isRare;

  CollectionLayer({
    required this.name,
    required this.images,
    this.isRare = false,
    this.selected = false,
  });
}
