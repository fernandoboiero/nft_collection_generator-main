import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nft_generator/core/utils/color_palette.dart';
import 'package:nft_generator/core/utils/extensions.dart';
import 'package:nft_generator/core/infrastructure/dependency_injection.dart';
import 'package:nft_generator/core/strings/strings.dart';
import 'package:nft_generator/core/utils/collection_helper.dart';
import 'package:nft_generator/core/widgets/project_button_raised_accent.dart';
import 'package:nft_generator/core/widgets/project_button_raised_primary.dart';
import 'package:nft_generator/core/widgets/project_dialog.dart';
import 'package:nft_generator/features/collection_generator/data/models/collection_model.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_image.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_layer.dart';
import 'package:nft_generator/features/collection_generator/presentation/manager/collection_generator_bloc.dart';
import 'package:nft_generator/features/collection_generator/presentation/widgets/layers_widget.dart';
import 'package:nft_generator/features/collection_generator/presentation/widgets/publish_collection_form_widget.dart';
import 'package:nft_generator/features/collection_generator/presentation/widgets/stored_collection_ok_widget.dart';
import 'package:nft_generator/features/drag_and_drop/presentation/pages/drag_and_drop_page.dart';
import 'package:nft_generator/features/gallery/presentation/widgets/mixed_editable_gallery_widget.dart';

class CollectionGeneratorPage extends StatefulWidget {
  const CollectionGeneratorPage({Key? key}) : super(key: key);

  @override
  State<CollectionGeneratorPage> createState() =>
      _CollectionGeneratorPageState();
}

class _CollectionGeneratorPageState extends State<CollectionGeneratorPage> {
  final _bloc = getIt<CollectionGeneratorBloc>();
  var st5 = GoogleFonts.urbanist(fontSize: 32, fontWeight: FontWeight.bold);
  var st3 = GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w400);
  var st2 = GoogleFonts.urbanist(
      fontSize: 32, fontWeight: FontWeight.bold, color: ColorPalette.primary);
  var st6 = GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w400);
  late Collection collection;
  late CollectionLayer selectedLayer;
  var layerNameController = TextEditingController();
  List<List<CollectionImage>> imagesMixed = [];
  var showSaveChangesLoading = false;

  var _isEnable = false;
  var _showPublishForm = false;

  get canGenerateCollection =>
      collection.layers.length > 1 &&
      collection.layers
          .where((element) => element.images.isEmpty)
          .toList()
          .isEmpty;

  storeChanges() {
    _bloc.add(ActionStoreCollectionLocal(collection: collection));
  }

  @override
  void initState() {
    loadStoredCollectionLocally();
    super.initState();
  }

  onCollectionLoad(Collection collection) {
    this.collection = collection;
    selectedLayer = collection.layers[0];
    layerNameController.text = selectedLayer.name;

  }

  loadStoredCollectionLocally() {
    _bloc.add(ActionGetCollectionLocal());
  }

  updateName() {
    selectedLayer.name = layerNameController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(backgroundColor: ColorPalette.primary),
          backgroundColor: ColorPalette.background,
          body: Stack(
            children: [
              BlocConsumer<CollectionGeneratorBloc, CollectionGeneratorState>(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is CollectionGeneratorOnLoad) {
                    onCollectionLoad(state.collection);
                  }
                  if (state is CollectionGeneratorOnStoring) {
                    showSaveChangesLoading = true;
                  }
                  if (state is CollectionGeneratorOnStored) {
                    showSaveChangesLoading = false;
                  }
                  if (state is CollectionGeneratorOnStoredFail) {
                    showSaveChangesLoading = false;
                  }
                  if (state is CollectionGeneratorOnStoredRemoteOk) {
                    _showPublishForm = false;
                    context.loaderOverlay.hide();
                    setState(() => {});
                  }
                  if (state is CollectionGeneratorOnStoredRemoteFail) {
                    context.loaderOverlay.hide();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Ocurrió un error, por favor reintente"),
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                  if (state is CollectionGeneratorOnStoringRemote) {
                    context.loaderOverlay.show();
                  }
                },
                builder: (context, state) {
                  if (state is CollectionGeneratorOnLoading) {
                    return collectionGeneratorOnLoading();
                  } else if (state is CollectionGeneratorOnStoredRemoteOk) {
                    return StoredCollectionOkWidget(
                      onCreateNew: onDeleteCollection,
                    );
                  } else if (state is CollectionGeneratorOnLoad ||
                      state is CollectionGeneratorOnStoring ||
                      state is CollectionGeneratorOnStoredFail ||
                      state is CollectionGeneratorOnStoredRemoteFail ||
                      state is CollectionGeneratorOnStoredRemoteOk ||
                      state is CollectionGeneratorOnStored ||
                      state is CollectionGeneratorOnStoringRemote) {
                    return collectionGeneratorOnLoad();
                  }
                  return collectionGeneratorOnLoading();
                },
              ),
              showSaveChangesLoading ? loadingStoreChanges() : Container()
            ],
          ),
        ),
        _showPublishForm
            ? Positioned.fill(
                child: PublishCollectionFormWidget(
                  collection: collection,
                  mixedImages: imagesMixed,
                  onPublish: (p) => onPublishCollection(p),
                  onDiscard: () {
                    _showPublishForm = false;
                    onDeleteCollection();
                    setState(() => {});
                  },
                  onCancel: () {
                    _showPublishForm = false;
                    onBackFromMixed();
                    setState(() => {});
                  },
                  onNotifyError: (msg) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(msg),
                      backgroundColor: Colors.redAccent,
                    ));
                  },
                ),
              )
            : Container()
      ],
    );
  }

  Positioned loadingStoreChanges() {
    return Positioned(
      bottom: 50,
      right: 50,
      child: Container(
        width: 100,
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        color: Colors.black38,
        child: Row(
          children: const [
            Text('Saving...', style: TextStyle(color: Colors.white)),
            Spacer(),
            Center(
              child: SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(
                    strokeWidth: 1, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget collectionGeneratorOnLoad() {
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
              Row(
                children: [
                  Text("¿No sabés cómo empezar?", style: st3),
                  const SizedBox(width: 20),
                  ProjectButtonRaisedAccent(
                    text: "Mirar tutorial",
                    onTap: () => {},
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 50),
          imagesMixed.isNotEmpty ? panelMixedLayers() : panelDragAndDrop(),
        ],
      ),
    );
  }

  Center collectionGeneratorOnLoading() => const Center(
        child: CircularProgressIndicator(),
      );

  Widget panelMixedLayers() => Expanded(
        child: MixedEditableGalleryWidget(
          collection.layers,
          onBackFromMixed,
          onDeleteCollection,
          showPublishForm,
          imagesMixed,
        ),
      );

  Expanded panelDragAndDrop() {
    return Expanded(
      child: Row(
        children: [
          Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(30),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 1,
                      child: LayersWidget(
                        layers: collection.layers,
                        onLayerSelected: onLayerSelected,
                        selectedLayer: selectedLayer,
                        onLayerCreated: onLayerCreated,
                        onLayersDeleted: onLayerDeleted,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ProjectButtonRaisedPrimary(
                      enabled: canGenerateCollection,
                      text: "Generar Colección",
                      onTap: generateCollection,
                    ),
                    const SizedBox(height: 10),
                    Center(
                        child: Text(
                            "Cantidad de combinaciones: $getCombinationsCount",
                            style: st6)),
                  ],
                ),
              )),
          const SizedBox(width: 30),
          Flexible(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(30),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    layerHeader(),
                    const SizedBox(height: 10),
                    Expanded(
                      child: DragAndDropPage(
                        files: selectedLayer.images,
                        onAdd: onDragFiles,
                        onRemove: onDeleteFile,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  SizedBox layerHeader() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Wrap(
            children: <Widget>[
              _isEnable
                  ? SizedBox(
                      width: 300,
                      child: TextField(
                        controller: layerNameController,
                        maxLength: 30,
                        decoration: InputDecoration(labelStyle: st5),
                        enabled: _isEnable,
                        style: st5,
                      ),
                    )
                  : Text(selectedLayer.name, style: st5),
              IconButton(
                  icon: _isEnable
                      ? Icon(
                          Icons.done,
                          size: 30,
                          color: "#203359".parseToColor.withOpacity(.35),
                        )
                      : Icon(
                          Icons.edit,
                          size: 24,
                          color: "#203359".parseToColor.withOpacity(.35),
                        ),
                  onPressed: () {
                    _isEnable = !_isEnable;
                    updateName();
                    if (!_isEnable) storeChanges();
                    setState(() => {});
                  })
            ],
          ),
          const Spacer(),
          shouldShowRareButton ? buttonSwitchRare() : Container(),
        ],
      ),
    );
  }

  get shouldShowRareButton {
    for (var element in collection.layers) {
      if (element.isRare && element != selectedLayer) return false;
    }
    return true;
  }

  Widget buttonSwitchRare() {
    return Row(
      children: [
        Text("Asignar rareza", style: st3),
        Switch(
          value: selectedLayer.isRare,
          activeColor: ColorPalette.accent,
          onChanged: (a) => switchRare(),
        ),
      ],
    );
  }

  onDragFiles(List<CollectionImage> files) {
    for (var element in files) {
      if (selectedLayer.images.length >= 20) return;
      selectedLayer.images.add(element);
      setState(() => {});
      storeChanges();
    }
  }

  onDeleteFile(CollectionImage file) {
    selectedLayer.images.remove(file);
    setState(() => {});
    storeChanges();
  }

  onLayerSelected(CollectionLayer layer) {
    selectedLayer = layer;
    layerNameController.text = layer.name;
    setState(() => {});
    storeChanges();
  }

  onLayerCreated(CollectionLayer layer) {
    setState(() => {});
    storeChanges();
  }

  onLayerDeleted(CollectionLayer layer) {
    if (layer == selectedLayer) selectedLayer = collection.layers.first;
    setState(() => {});
    storeChanges();
  }

  generateCollection() async {
    final canCreate = await showDialogConfirmGenerate();
    if (!canCreate) return;
    var helper = CollectionHelper(
      collection.layers.where((e) => !e.isRare).toList(),
    );
    helper.generateVariants;
    imagesMixed = demoMethod(helper.mixedLayers);
    setState(() => {});
  }

  Future<bool> showDialogConfirmGenerate() async {
    return await ProjectDialog(
      context: context,
      title: TextDialogGenerateCollection.title,
      caption: TextDialogGenerateCollection.caption,
      btnCancel: TextDialogGenerateCollection.btnCancel,
      btnConfirm: TextDialogGenerateCollection.btnConfirm,
    ).show();
  }

  int get getCombinationsCount {
    var helper = CollectionHelper(
      collection.layers.where((e) => !e.isRare).toList(),
    );
    helper.generateVariants;
    return demoMethod(helper.mixedLayers).length;
  }

  void switchRare() {
    selectedLayer.isRare = !selectedLayer.isRare;
    setState(() => {});
    storeChanges();
  }

  onBackFromMixed() {
    imagesMixed = [];
    setState(() => {});
    storeChanges();
  }

  List<List<CollectionImage>> demoMethod(rawImagesInLayers) {
    if (rawImagesInLayers == null) [];
    List<List<CollectionImage>> all = [];
    for (var i = 0; i < rawImagesInLayers!.length; i++) {
      List<CollectionImage> images = [];
      for (var e = 0; e < rawImagesInLayers[i].length; e++) {
        images.add(getImageFromLayerByIndex(e, rawImagesInLayers[i][e]));
      }
      all.add(images);
    }
    for (var rareLayer
        in collection.layers.where((element) => element.isRare)) {
      for (var value in rareLayer.images) {
        all.add([value]);
      }
    }
    return mergeImageLayers(all);
  }

  List<List<CollectionImage>> mergeImageLayers(
      List<List<CollectionImage>> data) {
    return data;
  }

  CollectionImage getImageFromLayerByIndex(int layerIndex, int imageIndex) {
    return collection.layers[layerIndex].images[imageIndex];
  }

  onDeleteCollection() {
    imagesMixed = [];
    collection = CollectionModel(
        name: '', layers: [], authorName: '', authorEmail: '', detail: '');
    storeChanges();
    loadStoredCollectionLocally();
    setState(() => {});
  }

  showPublishForm() {
    _showPublishForm = true;
    setState(() => {});
  }

  onPublishCollection(Collection payload) {
    _bloc.add(ActionStoreCollectionRemote(collection: payload));
  }
}
