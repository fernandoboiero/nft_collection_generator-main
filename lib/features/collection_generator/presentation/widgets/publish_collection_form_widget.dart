import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nft_generator/core/strings/strings.dart';
import 'package:nft_generator/core/utils/text_styles.dart';
import 'package:nft_generator/core/utils/validator.dart';
import 'package:nft_generator/core/widgets/project_button_raised_primary.dart';
import 'package:nft_generator/features/collection_generator/data/models/collection_image_model.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_image.dart';
import 'package:fdottedline/fdottedline.dart';

class PublishCollectionFormWidget extends StatefulWidget {
  final List<List<CollectionImage>>? mixedImages;
  final Collection collection;
  final Function(Collection payload) onPublish;
  final Function()? onCancel;
  final Function()? onDiscard;
  final Function(String message)? onNotifyError;

  const PublishCollectionFormWidget({
    Key? key,
    required this.mixedImages,
    required this.collection,
    required this.onPublish,
    required this.onCancel,
    required this.onDiscard,
    required this.onNotifyError,
  }) : super(key: key);

  @override
  State<PublishCollectionFormWidget> createState() =>
      _PublishCollectionFormWidgetState();
}

class _PublishCollectionFormWidgetState
    extends State<PublishCollectionFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _validators = Validator();
  final colNameController = TextEditingController();
  final colDescController = TextEditingController();
  final authorNameController = TextEditingController();
  final authorEmailController = TextEditingController();

  CollectionImage? bannerImage;

  Widget get title => Text(TextPublishForm.title, style: st1);

  Widget get caption => Text(TextPublishForm.caption, style: st2);

  Widget get inputCollectionName => formInput(
        TextPublishForm.label1,
        TextPublishForm.hint1,
        colNameController,
        _validators.name,
      );

  Widget get inputCollectionDescription => formInput(
        TextPublishForm.label2,
        TextPublishForm.hint2,
        colDescController,
        _validators.description,
        lines: 3,
      );

  Widget get inputAuthorName => formInput(
        TextPublishForm.label3,
        TextPublishForm.hint3,
        authorNameController,
        _validators.name,
      );

  Widget get inputAuthorEmail => formInput(
        TextPublishForm.label4,
        TextPublishForm.hint4,
        authorEmailController,
        _validators.email,
      );

  Widget get btnOk => ProjectButtonRaisedPrimary(
        text: TextPublishForm.btnPublish,
        onTap: validateForm,
        enabled: true,
      );

  @override
  initState() {
    super.initState();
    colNameController.text = "nombre";
    colDescController.text = "descripcion adasdasd";
    authorNameController.text = "nombre autor";
    authorEmailController.text = "nombre@nombre.com";
  }

  Widget label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(text, style: st3),
    );
  }

  Widget formInput(
    String label,
    String hint,
    TextEditingController controller,
    FormFieldValidator<String>? validator, {
    int lines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(label, style: st3),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            validator: validator,
            controller: controller,
            maxLines: lines,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: hint,
              hintStyle: st4,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black45,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            constraints: const BoxConstraints(maxWidth: 1000),
            padding: const EdgeInsets.all(50),
            child: Wrap(
              children: [
                Stack(
                  children: [
                    form,
                    Align(
                      child: InkWell(
                        child: const Icon(Icons.close, color: Colors.black45),
                        onTap: () => widget.onCancel!.call(),
                      ),
                      alignment: Alignment.topRight,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form get form {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          title,
          const SizedBox(height: 20),
          caption,
          const SizedBox(height: 40),
          IntrinsicHeight(
            child: Row(
              children: [
                bannerImageDragAndDrop,
                const SizedBox(width: 40),
                Flexible(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      inputCollectionName,
                      inputCollectionDescription,
                      inputAuthorName,
                      inputAuthorEmail,
                      const SizedBox(height: 20),
                      btnOk,
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Drag and drop section
  var dropTargetColor = Colors.grey[300];

  Widget get titleBanner => Text(TextPublishForm.titleBanner, style: st3);

  Widget get captionBanner => Text(TextPublishForm.captionBanner,
      style: st4.copyWith(color: Colors.grey, fontSize: 15),
      textAlign: TextAlign.center);

  Widget get caption2banner => Text(TextPublishForm.caption2Banner,
      style: st3, textAlign: TextAlign.center);

  get bannerImageDragAndDrop {
    return Flexible(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 8),
          titleBanner,
          const SizedBox(height: 15),
          Expanded(
            child: DropTarget(
              child: dropTargetContent,
              onDragDone: (details) {
                details.files.map((e) async {
                  if (e.mimeType == "image/png") {
                    bannerImage = CollectionImageModel(
                      bytes: await e.readAsBytes(),
                      name: 'name.png',
                      mimeType: 'png',
                      path: e.path,
                      layerIndex: 0,
                    );
                    setState(() => {});
                  }
                }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget get dropTargetContent => bannerImage == null
      ? FDottedLine(
          height: 160.0,
          strokeWidth: 1.5,
          dottedLength: 10.0,
          space: 8,
          color: dropTargetColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: Image.asset(
                      'assets/img_1.png',
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  caption2banner,
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: captionBanner,
                  ),
                ],
              ),
            ],
          ),
        )
      : Image.memory(bannerImage!.bytes, fit: BoxFit.cover);

  validateForm() {
    if (bannerImage == null) {
      dropTargetColor = Colors.redAccent;
      setState(() => {});
      widget.onNotifyError?.call("Ingrese una imagen para el banner.");
      return;
    }
    if (_formKey.currentState!.validate()) {
      widget.collection.authorEmail = authorEmailController.text.trim();
      widget.collection.authorName = authorNameController.text.trim();
      widget.collection.name = colNameController.text.trim();
      widget.collection.detail = colDescController.text.trim();
      widget.collection.bannerImage = bannerImage;
      widget.onPublish.call(widget.collection);
    }
  }
}
