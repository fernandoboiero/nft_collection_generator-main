import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_generator/core/utils/color_palette.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_layer.dart';

class ListRowWidget extends StatelessWidget {
  final st1 = GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w400);

  ListRowWidget({
    Key? key,
    required this.layer,
    required this.onSelectRow,
    this.onDelete,
  }) : super(key: key);

  final CollectionLayer layer;
  final Function(CollectionLayer layer) onSelectRow;
  final Function(CollectionLayer layer)? onDelete;

  @override
  Widget build(BuildContext context) => buildLayerRow(layer);

  Widget buildLayerRow(CollectionLayer layer) {
    return ReorderableDelayedDragStartListener(
      key: key,
      index: layer.index,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: InkWell(
          hoverColor: Colors.blueGrey[100],
          onTap: () => onSelectRow(layer),
          child: Container(
            decoration: borderRow,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: nameWidget,
                      ),
                    ),
                    rareIcon,
                    deleteButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get rareIcon => Icon(
        layer.isRare ? Icons.star : null,
        color: ColorPalette.icon,
      );

  BoxDecoration get borderRow => BoxDecoration(
        border: Border.all(
          color: layer.selected
              ? ColorPalette.accent
              : ColorPalette.borderDisabled,
          width: layer.selected ? 2 : 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      );

  Text get nameWidget => Text(layer.name, style: st1);

  Widget get deleteButton => Visibility(
        visible: onDelete != null,
        child: Row(
          children: [
            VerticalDivider(color: ColorPalette.icon),
            IconButton(
              icon: Icon(Icons.delete, color: ColorPalette.icon),
              onPressed: () => onDelete != null ? onDelete!(layer) : null,
            ),
          ],
        ),
      );
}
