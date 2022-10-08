import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_generator/core/utils/color_palette.dart';

class ProjectButtonRaisedPrimary extends StatelessWidget {
  final String text;
  final bool enabled;
  final Function()? onTap;

  const ProjectButtonRaisedPrimary({
    Key? key,
    required this.text,
    required this.onTap,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final st4 = GoogleFonts.urbanist(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    return SizedBox(
      height: 50,
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: ColorPalette.primary,
          elevation: 4,
          onSurface: ColorPalette.primaryDisabled,
        ),
        onPressed: enabled ? () => onTap!() : null,
        child: Text(text, style: st4),
      ),
    );
  }
}
