import 'package:dartz/dartz.dart';
import 'package:nft_generator/core/use_case/use_case.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection.dart';
import 'package:nft_generator/features/collection_generator/domain/repositories/collection_repository_base.dart';

class StoreCollectionRemote extends UseCase<bool, Collection> {
  final CollectionRepositoryBase repository;

  StoreCollectionRemote({required this.repository});

  @override
  Future<Either<Error, bool>> call(Collection data) async {
    return repository.saveCollectionRemote(payload: data);
  }
}
