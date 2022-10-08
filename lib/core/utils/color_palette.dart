import 'package:flutter/material.dart';
import 'package:nft_generator/core/utils/extensions.dart';

class ColorPalette {
  static Color primary = "#49277A".parseToColor;
  static Color accent = "#6CC72B".parseToColor;
  static Color background = "#E5E5E5".parseToColor.withOpacity(.3);
  static Color icon = "#BFB4CD".parseToColor;
  static Color borderDisabled = "#B8CAD5".parseToColor.withOpacity(.4);
  static Color primaryDisabled = "#535353".parseToColor.withOpacity(.4);
}
