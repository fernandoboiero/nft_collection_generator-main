import 'package:flutter/material.dart';
import 'package:nft_generator/core/utils/text_styles.dart';
import 'package:nft_generator/core/widgets/project_button_raised_light.dart';
import 'package:nft_generator/core/widgets/project_button_raised_primary.dart';

class ProjectDialog {
  final BuildContext context;
  final String title, caption, btnCancel, btnConfirm;

  ProjectDialog({
    required this.context,
    required this.title,
    required this.caption,
    required this.btnCancel,
    required this.btnConfirm,
  });

  Future<bool> show() async {
    final result = await showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            contentPadding:
                const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
            actionsPadding:
                const EdgeInsets.only(left: 40, right: 40, bottom: 20),
            titlePadding: const EdgeInsets.only(left: 40, right: 40, top: 40),
            actionsAlignment: MainAxisAlignment.spaceAround,
            title: Text(title, style: dialogTitle, textAlign: TextAlign.center),
            content: Text(
              caption,
              style: dialogCaption,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              ProjectButtonRaisedLight(
                onTap: () => Navigator.of(context).pop(false),
                text: btnCancel,
              ),
              const SizedBox(width: 20),
              ProjectButtonRaisedPrimary(
                enabled: true,
                onTap: () => Navigator.of(context).pop(true),
                text: btnConfirm,
              ),
            ],
          );
        });
    return result;
  }
}
