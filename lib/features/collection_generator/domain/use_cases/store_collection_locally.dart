import 'package:dartz/dartz.dart';
import 'package:nft_generator/core/use_case/use_case.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection.dart';
import 'package:nft_generator/features/collection_generator/domain/repositories/collection_repository_base.dart';

class StoreCollectionLocally extends UseCase<bool, Collection> {
  final CollectionRepositoryBase repository;

  StoreCollectionLocally({required this.repository});

  @override
  Future<Either<Error, bool>> call(Collection data) async {
    return repository.saveCollectionLocal(collection: data);
  }
}
