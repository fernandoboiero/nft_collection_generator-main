import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nft_generator/features/collection_generator/data/models/collection_layer_model.dart';
import 'package:nft_generator/features/collection_generator/data/models/collection_model.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection_layer.dart';
import 'package:nft_generator/features/collection_generator/domain/use_cases/get_collection_locally.dart';
import 'package:nft_generator/features/collection_generator/domain/use_cases/store_collection_locally.dart';
import 'package:nft_generator/features/collection_generator/domain/use_cases/store_collection_remote.dart';

part 'collection_generator_event.dart';

part 'collection_generator_state.dart';

class CollectionGeneratorBloc
    extends Bloc<CollectionGeneratorEvent, CollectionGeneratorState> {
  final GetCollectionLocally getCollection;
  final StoreCollectionLocally storeLocal;
  final StoreCollectionRemote storeRemote;

  CollectionGeneratorBloc({
    required this.getCollection,
    required this.storeLocal,
    required this.storeRemote,
  }) : super(CollectionGeneratorInitial()) {
    on<CollectionGeneratorEvent>((event, emit) async {
      if (event is ActionGetCollectionLocal) {
        emit(CollectionGeneratorOnLoading());
        var result = await getCollection.call(null);
        result.fold(
          (failure) {
            final collection = initCollection();
            emit(CollectionGeneratorOnLoad(collection: collection));
          },
          (collection) {
            if (collection.layers.isEmpty) collection = initCollection();
            emit(CollectionGeneratorOnLoad(collection: collection));
          },
        );
      }
      if (event is ActionStoreCollectionLocal) {
        emit(CollectionGeneratorOnStoring());
        var result = await storeLocal.call(event.collection);

        result.fold(
          (l) => emit(CollectionGeneratorOnStoredFail(error: l)),
          (r) => emit(CollectionGeneratorOnStored()),
        );
      }

      if (event is ActionStoreCollectionRemote) {
        emit(CollectionGeneratorOnStoringRemote());
        var result = await storeRemote.call(event.collection);

        result.fold(
          (l) => emit(CollectionGeneratorOnStoredRemoteFail(error: l)),
          (r) => emit(CollectionGeneratorOnStoredRemoteOk()),
        );
      }
    });
  }

  Collection initCollection() {
    return CollectionModel(
      name: 'My Collection',
      authorEmail: '',
      authorName: '',
      detail: '',
      layers: [initFirstLayer()],
    );
  }

  CollectionLayer initFirstLayer() {
    CollectionLayer initLayer = CollectionLayerModel(
      name: "Capa sin título",
      images: [],
    );
    initLayer.isRare = false;
    return initLayer;
  }
}
