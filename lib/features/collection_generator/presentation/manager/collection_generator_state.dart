part of 'collection_generator_bloc.dart';

@immutable
abstract class CollectionGeneratorState {}

class CollectionGeneratorInitial extends CollectionGeneratorState {}

class CollectionGeneratorOnLoading extends CollectionGeneratorState {}

class CollectionGeneratorOnStoring extends CollectionGeneratorState {}

class CollectionGeneratorOnLoad extends CollectionGeneratorState {
  final Collection collection;

  CollectionGeneratorOnLoad({required this.collection});
}

class CollectionGeneratorOnStored extends CollectionGeneratorState {}

class CollectionGeneratorOnStoredFail extends CollectionGeneratorState {
  final Error error;

  CollectionGeneratorOnStoredFail({required this.error});
}

class CollectionGeneratorOnStoringRemote extends CollectionGeneratorState {}

class CollectionGeneratorOnStoredRemoteOk extends CollectionGeneratorState {}

class CollectionGeneratorOnStoredRemoteFail extends CollectionGeneratorState {
  final Error error;

  CollectionGeneratorOnStoredRemoteFail({required this.error});
}
