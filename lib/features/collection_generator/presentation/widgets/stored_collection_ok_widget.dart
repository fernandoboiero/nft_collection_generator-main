import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_generator/core/utils/color_palette.dart';
import 'package:nft_generator/core/widgets/project_button_raised_light.dart';

class StoredCollectionOkWidget extends StatelessWidget {
  final Function()? onCreateNew;

  const StoredCollectionOkWidget({Key? key, required this.onCreateNew})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var st1 = GoogleFonts.urbanist(
        fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black);
    var st2 = GoogleFonts.urbanist(
        fontSize: 32, fontWeight: FontWeight.bold, color: ColorPalette.primary);
    var st3 = GoogleFonts.urbanist(
        fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black);
    return Container(
      margin: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Text("Generador de Colecciones", style: st2),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 50),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(30),
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child:
                            Image.asset("assets/img-success.png", height: 300)),
                    const SizedBox(height: 60),
                    Text("¡Fabuloso, creaste tu colección!", style: st1),
                    const SizedBox(height: 10),
                    Text(
                      "Tu colección está en revisión para luego ser aprobada y publicada en nuestra página web.\nTe enviaremos un email cuando se haya aprobado tu colección. ",
                      style: st3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ProjectButtonRaisedLight(
                      onTap: onCreateNew,
                      text: "Crear otra colección",
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
