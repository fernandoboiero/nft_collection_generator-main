import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_generator/core/utils/color_palette.dart';

class ProjectButtonRaisedLight extends StatelessWidget {
  final String text;
  final Function()? onTap;

  const ProjectButtonRaisedLight({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final st4 = GoogleFonts.urbanist(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: ColorPalette.primary,
    );
    return Container(
      height: 50,
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.white),
        onPressed: onTap,
        child: Text(text, style: st4),
      ),
    );
  }
}
