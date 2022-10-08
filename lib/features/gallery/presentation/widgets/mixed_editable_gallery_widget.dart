import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_generator/core/strings/strings.dart';
import 'package:nft_generator/core/utils/extensions.dart';
import 'package:nft_generator/core/widgets/project_button_raised_light.dart';
import 'package:nft_generator/core/widgets/project_button_raised_primary.dart';
import 'package:nft_generator/core/widgets/project_dialog.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_image.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_layer.dart';
import 'package:number_paginator/number_paginator.dart';

class MixedEditableGalleryWidget extends StatefulWidget {
  final List<CollectionLayer> layers;
  final List<List<CollectionImage>> imagesInLayers;
  final Function(int index, CollectionImage file)? onDelete;
  final Function()? onBack;
  final Function()? onDeleteCollection;
  final Function()? onPublishCollection;

  const MixedEditableGalleryWidget(
    this.layers,
    this.onBack,
    this.onDeleteCollection,
    this.onPublishCollection,
    this.imagesInLayers, {
    Key? key,
    this.onDelete,
  }) : super(key: key);

  @override
  State<MixedEditableGalleryWidget> createState() =>
      _EditableGalleryWidgetState();
}

class _EditableGalleryWidgetState extends State<MixedEditableGalleryWidget> {
  int _numPages = 0;
  int _currentPage = 0;
  int totalItems = 0;
  int limit = 24;
  int currentPageItemsCount = 0;

  var st1 = GoogleFonts.urbanist(fontSize: 32, fontWeight: FontWeight.bold);
  var st2 = GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w500);

  @override
  void initState() {
    totalItems = widget.imagesInLayers.length;
    _numPages = (totalItems / limit).ceil();
    _currentPage = 0;
    super.initState();
  }

  get selectedChunkOfImages {
    var selectRangeTo = (_currentPage * limit + limit);
    var selectRangeFrom = _currentPage * limit;
    if (selectRangeTo > totalItems) {
      selectRangeTo = totalItems;
    }
    return widget.imagesInLayers
        .getRange(selectRangeFrom, selectRangeTo)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rareImages = [];
    for (var value in widget.layers.where((e) => e.isRare).toList()) {
      for (var element in value.images) {
        rareImages.add(imageMultiple(
          [Image(image: MemoryImage(element.bytes))],
          0,
        ));
      }
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text("Tu colección", style: st1),
              const Spacer(),
              Text(
                  "Cantidad de imágenes generadas ${widget.imagesInLayers.length}",
                  style: st2)
            ],
          ),
          const SizedBox(height: 40),
          Expanded(
            child: GridView.count(
              crossAxisCount: 6,
              crossAxisSpacing: 40,
              mainAxisSpacing: 40,
              children: [
                ...List.generate(selectedChunkOfImages.length, (index) {
                  return square(selectedChunkOfImages[index], index);
                }),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: NumberPaginator(
                  buttonSelectedForegroundColor: "#626C72".parseToColor,
                  buttonUnselectedForegroundColor: "#626C72".parseToColor,
                  buttonSelectedBackgroundColor: "#C4ECA8".parseToColor,
                  numberPages: _numPages,
                  onPageChange: (int index) {
                    _currentPage = index;
                    setState(() => {});
                    // handle page change...
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ProjectButtonRaisedLight(
                      text: 'Descartar colección',
                      onTap: () async {
                        final canDelete =
                            await showDialogConfirmDiscardCollection();
                        if (!canDelete) return;
                        widget.onDeleteCollection!();
                      },
                    ),
                    const SizedBox(width: 10),
                    ProjectButtonRaisedLight(
                      text: 'Volver a editar',
                      onTap: widget.onBack,
                    ),
                    const SizedBox(width: 10),
                    ProjectButtonRaisedPrimary(
                      text: 'Publicar colección',
                      onTap: widget.onPublishCollection,
                      enabled: true,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> showDialogConfirmDiscardCollection() async {
    return await ProjectDialog(
      context: context,
      title: TextDialogDiscardCollection.title,
      caption: TextDialogDiscardCollection.caption,
      btnCancel: TextDialogDiscardCollection.btnCancel,
      btnConfirm: TextDialogDiscardCollection.btnConfirm,
    ).show();
  }

  Widget imageMultiple(List<Widget> images, int index) {
    return Container(
      color: Colors.grey,
      child: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                ...images,
              ],
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: widget.onDelete != null
                ? deleteButton(index, null)
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget square(List<CollectionImage> images, int index) {
    List<Widget> widgets = [];
    for (int i = 0; i < images.length; i++) {
      widgets.add(Image(image: MemoryImage(images[i].bytes)));
    }
    return imageMultiple(widgets, index);
  }

  Widget deleteButton(int index, CollectionImage? file) {
    return InkWell(
      onTap: () => widget.onDelete?.call(index, file!),
      child: Container(
        padding: const EdgeInsets.all(3),
        color: Colors.black54,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
    );
  }

  Widget imageWidget(CollectionImage e) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Image(image: MemoryImage(e.bytes), fit: BoxFit.cover),
    );
  }
}
