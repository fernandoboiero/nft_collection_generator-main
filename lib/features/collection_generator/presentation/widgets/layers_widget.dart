import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_generator/core/utils/extensions.dart';
import 'package:nft_generator/core/strings/strings.dart';
import 'package:nft_generator/core/utils/text_styles.dart';
import 'package:nft_generator/core/widgets/project_button_raised_accent.dart';
import 'package:nft_generator/core/widgets/project_button_raised_light.dart';
import 'package:nft_generator/core/widgets/project_button_raised_primary.dart';
import 'package:nft_generator/core/widgets/project_dialog.dart';
import 'package:nft_generator/features/collection_generator/data/models/collection_layer_model.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_layer.dart';
import 'package:nft_generator/features/collection_generator/presentation/widgets/list_row_widget.dart';

class LayersWidget extends StatefulWidget {
  final Function(CollectionLayer layer) onLayerSelected;
  final Function(CollectionLayer layer) onLayerCreated;
  final Function(CollectionLayer layer) onLayersDeleted;
  final List<CollectionLayer> layers;
  final CollectionLayer selectedLayer;

  const LayersWidget({
    required this.layers,
    required this.onLayerSelected,
    required this.selectedLayer,
    required this.onLayerCreated,
    required this.onLayersDeleted,
    Key? key,
  }) : super(key: key);

  @override
  State<LayersWidget> createState() => _LayersWidgetState();
}

class _LayersWidgetState extends State<LayersWidget> {
  @override
  Widget build(BuildContext context) => layersBuilder();

  Widget layersBuilder() {
    var st5 = GoogleFonts.urbanist(fontSize: 32, fontWeight: FontWeight.bold);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("Capas", style: st5),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("${widget.layers.length}/10", style: st6),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(child: buildLayersColumn()),
        const SizedBox(height: 10),
        widget.layers.length < 10
            ? InkWell(
                customBorder: const CircleBorder(),
                onTap: () => addLayer("Nueva capa"),
                child: Icon(
                  Icons.add_circle_outline_sharp,
                  size: 40,
                  color: "#6CC72B".parseToColor,
                ),
              )
            : Container()
      ],
    );
  }

  Widget buildLayersColumn() {
    List<Widget> widgets = [];
    for (var layer in widget.layers) {
      layer.selected = layer == widget.selectedLayer;
      layer.index = widget.layers.indexOf(layer);
      final row = ListRowWidget(
        key: ValueKey(layer),
        layer: layer,
        onSelectRow: widget.onLayerSelected,
        onDelete: widget.layers.length == 1
            ? null
            : (layer) async {
                final result = await showDialogConfirmDelete();
                if (result) {
                  setState(() => widget.layers.remove(layer));
                  widget.onLayersDeleted(layer);
                }
              },
      );
      widgets.add(row);
    }

    return ReorderableListView(
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      children: widgets,
      onReorder: (oldIndex, newIndex) {
        var layer = widget.layers.elementAt(oldIndex);
        widget.layers.removeAt(oldIndex);
        var index = newIndex > oldIndex ? newIndex - 1 : newIndex;
        widget.layers.insert(index, layer);
        setState(() => {});
      },
    );
  }

  Future<bool> showDialogConfirmDelete() async {
    return await ProjectDialog(
      context: context,
      title: TextDialogDeleteLayer.title,
      caption: TextDialogDeleteLayer.caption,
      btnCancel: TextDialogDeleteLayer.btnCancel,
      btnConfirm: TextDialogDeleteLayer.btnConfirm,
    ).show();
  }

  void addLayer(String name) {
    var layer = CollectionLayerModel(name: name, images: []);
    layer.isRare = false;
    setState(() => widget.layers.add(layer));
    setState(() => widget.onLayerCreated(layer));
  }
}
