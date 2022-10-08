import 'package:dartz/dartz.dart';
import 'package:nft_generator/features/collection_generator/data/data_sources/collection_local_data_source.dart';
import 'package:nft_generator/features/collection_generator/data/data_sources/collection_remote_data_source.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection.dart';
import 'package:nft_generator/features/collection_generator/domain/repositories/collection_repository_base.dart';

class CollectionRepository extends CollectionRepositoryBase {
  CollectionRepository({
    required CollectionLocalDataSourceBase local,
    required CollectionRemoteDataSourceBase remote,
  }) : super(local: local, remote: remote);

  @override
  Either<Error, Collection> getCollectionLocal() {
    try {
      return Right(local.getCollection());
    } catch (e) {
      return Left(e as Error);
    }
  }

  @override
  Either<Error, bool> saveCollectionLocal({required Collection collection}) {
    try {
      return Right(local.saveCollection(collection: collection));
    } catch (e) {
      return Left(e as Error);
    }
  }

  @override
  Future<Either<Error, bool>> saveCollectionRemote(
      {required Collection payload}) async {
    try {
      return Right(await remote.saveCollection(payload));
    } catch (e) {
      return Left(e as Error);
    }
  }
}
