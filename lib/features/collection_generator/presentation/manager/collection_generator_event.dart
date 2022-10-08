part of 'collection_generator_bloc.dart';

@immutable
abstract class CollectionGeneratorEvent {}

class ActionGetCollectionLocal extends CollectionGeneratorEvent {}

class ActionStoreCollectionLocal extends CollectionGeneratorEvent {
  final Collection collection;

  ActionStoreCollectionLocal({required this.collection});
}

class ActionStoreCollectionRemote extends CollectionGeneratorEvent {
  final Collection collection;

  ActionStoreCollectionRemote({required this.collection});
}
