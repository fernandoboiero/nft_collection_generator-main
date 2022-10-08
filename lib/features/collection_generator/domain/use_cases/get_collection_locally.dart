import 'package:dartz/dartz.dart';
import 'package:nft_generator/core/use_case/use_case.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection.dart';
import 'package:nft_generator/features/collection_generator/domain/repositories/collection_repository_base.dart';

class GetCollectionLocally extends UseCase<Collection, void> {
  final CollectionRepositoryBase repository;

  GetCollectionLocally({required this.repository});

  @override
  Future<Either<Error, Collection>> call(void data) async {
    return repository.getCollectionLocal();
  }
}
