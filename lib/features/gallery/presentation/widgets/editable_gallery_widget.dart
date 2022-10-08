import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_generator/core/utils/color_palette.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_image.dart';

class EditableGalleryWidget extends StatefulWidget {
  final List<CollectionImage> files;
  final Function(int index, CollectionImage file)? onDelete;

  const EditableGalleryWidget(this.files, {Key? key, this.onDelete})
      : super(key: key);

  @override
  State<EditableGalleryWidget> createState() => _EditableGalleryWidgetState();
}

class _EditableGalleryWidgetState extends State<EditableGalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5,
      children: List.generate(widget.files.length, (index) {
        return square(widget.files[index], index);
      }),
    );
  }

  Widget square(CollectionImage file, int index) {
    return Stack(
      children: [
        Positioned.fill(child: imageWidget(file)),
        Positioned(
          right: 5,
          top: 5,
          child:
              widget.onDelete != null ? deleteButton(index, file) : Container(),
        ),
      ],
    );
  }

  Widget deleteButton(int index, CollectionImage file) {
    return InkWell(
      onTap: () => widget.onDelete?.call(index, file),
      child: Container(
        padding: const EdgeInsets.all(3),
        color: Colors.black54,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
    );
  }

  Widget imageWidget(CollectionImage e) {
    return Container(
      color: ColorPalette.icon.withOpacity(.5),
      margin: const EdgeInsets.all(5),
      child: Image(image: MemoryImage(e.bytes), fit: BoxFit.cover),
      // child: Image.network(e.path, fit: BoxFit.cover),
    );
  }
}
