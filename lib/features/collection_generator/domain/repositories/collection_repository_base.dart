import 'package:dartz/dartz.dart';
import 'package:nft_generator/features/collection_generator/data/data_sources/collection_local_data_source.dart';
import 'package:nft_generator/features/collection_generator/data/data_sources/collection_remote_data_source.dart';
import 'package:nft_generator/features/collection_generator/domain/entities/collection.dart';

abstract class CollectionRepositoryBase {
  final CollectionLocalDataSourceBase local;
  final CollectionRemoteDataSourceBase remote;

  CollectionRepositoryBase({required this.local, required this.remote});

  Either<Error, bool> saveCollectionLocal({required Collection collection});

  Future<Either<Error, bool>> saveCollectionRemote(
      {required Collection payload});

  Either<Error, Collection> getCollectionLocal();
}
