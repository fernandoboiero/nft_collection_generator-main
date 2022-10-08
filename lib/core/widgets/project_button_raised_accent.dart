import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_generator/core/utils/color_palette.dart';

class ProjectButtonRaisedAccent extends StatelessWidget {
  final String text;
  final Function onTap;

  const ProjectButtonRaisedAccent({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final st4 = GoogleFonts.urbanist(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
    return SizedBox(
      height: 50,
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: ColorPalette.accent),
        onPressed: () => {},
        child: Text(text, style: st4),
      ),
    );
  }
}
