import 'dart:io';
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_generator/core/utils/extensions.dart';
import 'package:nft_generator/core/widgets/project_button_raised_light.dart';
import 'package:nft_generator/features/collection_generator/data/models/collection_image_model.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_image.dart';
import 'package:nft_generator/features/gallery/presentation/widgets/editable_gallery_widget.dart';

class DragAndDropPage extends StatefulWidget {
  final Function(List<CollectionImage> files) onAdd;
  final Function(CollectionImage file) onRemove;

  final List<CollectionImage> files;

  const DragAndDropPage({
    required this.onAdd,
    required this.onRemove,
    required this.files,
    Key? key,
  }) : super(key: key);

  @override
  State<DragAndDropPage> createState() => _DragAndDropPageState();
}

class _DragAndDropPageState extends State<DragAndDropPage> {
  var color = Colors.transparent;
  var st3 = GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w400);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DropTarget(
          child: Container(color: color),
          onDragEntered: (event) {},
          onDragExited: (event) {},
          onDragDone: (details) async {
            var files = await buildCustomImageList(details);
            addMoreFiles(files);
          },
          onDragUpdated: (a) => {},
        ),
        Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  widget.files.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Image.asset("assets/img.png"),
                              width: 400,
                              height: 400,
                            ),
                            const SizedBox(height: 50),
                            Center(child: pickerButton)
                          ],
                        )
                      : EditableGalleryWidget(
                          widget.files,
                          onDelete: onDeleteFile,
                        ),
                ],
              ),
            ),
            Visibility(
              visible: widget.files.isNotEmpty,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Row(
                  children: [
                    Text(
                        "Cantidad de archivos en la capa: ${widget.files.length}/20",
                        style: st3),
                    Spacer(),
                    pickerButton
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget get pickerButton => Container(
        height: 50,
        width: 250,
        margin: const EdgeInsets.only(left: 30),
        child: ProjectButtonRaisedLight(
          text: "Subir archivos",
          onTap: () => pickFiles(),
        ),
      );

  Future<List<CollectionImage>> buildCustomImageList(
    DropDoneDetails details,
  ) async {
    List<CollectionImage> files = [];
    await Future.wait(
      details.files.map((e) async {
        if (e.mimeType == "image/png") {
          CollectionImage file = CollectionImageModel(
            bytes: await e.readAsBytes(),
            name: 'name.png',
            mimeType: 'png',
            path: e.path,
            layerIndex: 0
          );
          files.add(file);
        }
        return e;
      }).toList(),
    );

    return Future.value(files);
  }

  onDeleteFile(int index, CollectionImage file) {
    setState(() => widget.onRemove(file));
  }

  pickFiles() async {
    List<CollectionImage> files = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowedExtensions: ["png"],
      type: FileType.custom,
    );

    if (result != null) {
      for (var element in result.files) {
        var file = CollectionImageModel(
          bytes: element.bytes!,
          name: 'name.png',
          mimeType: 'png',
          path: '',
          layerIndex: 0// TODO cambiar por el path
        );
        files.add(file);
      }
    } else {
      // User canceled the picker
    }
    addMoreFiles(files);
  }

  addMoreFiles(List<CollectionImage> images) {
    widget.onAdd.call(images);
  }
}
