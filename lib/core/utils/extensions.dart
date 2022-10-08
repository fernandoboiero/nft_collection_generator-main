import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension StringExtensions on String {
  Color get parseToColor {
    if (this.isEmpty || !this.contains("#")) return Color.fromARGB(0, 0, 0, 0);
    return Color(int.parse(this.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1)}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}