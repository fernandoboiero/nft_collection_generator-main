import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:nft_generator/core/infrastructure/http_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nft_generator/core/local_storage/local_storage_base.dart';
import 'package:nft_generator/features/collection_generator/data/data_sources/collection_local_data_source.dart';
import 'package:nft_generator/features/collection_generator/data/data_sources/collection_remote_data_source.dart';
import 'package:nft_generator/features/collection_generator/data/repositories/collection_repository.dart';
import 'package:nft_generator/features/collection_generator/domain/repositories/collection_repository_base.dart';
import 'package:nft_generator/features/collection_generator/domain/use_cases/get_collection_locally.dart';
import 'package:nft_generator/features/collection_generator/domain/use_cases/store_collection_locally.dart';
import 'package:nft_generator/features/collection_generator/domain/use_cases/store_collection_remote.dart';
import 'package:nft_generator/features/collection_generator/presentation/manager/collection_generator_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  String host = dotenv.env['HOST']!;

  final pref = await SharedPreferences.getInstance();

  getIt.registerFactory<SharedPreferences>(() => pref);

  getIt.registerLazySingleton<Client>(() => Client());

  getIt.registerLazySingleton<HttpServiceBase>(
      () => HttpService(host: host, client: getIt()));

  getIt.registerLazySingleton<CollectionRemoteDataSourceBase>(
    () => CollectionRemoteDataSource(httpService: getIt()),
  );

  getIt.registerLazySingleton<LocalStorageBase>(
        () => LocalStorage(sharedPreferences: getIt()),
  );

  getIt.registerLazySingleton<CollectionLocalDataSourceBase>(
    () => CollectionLocalDataSource(storage: getIt()),
  );

  getIt.registerLazySingleton<CollectionRepositoryBase>(
    () => CollectionRepository(local: getIt(), remote: getIt()),
  );

  getIt.registerLazySingleton<GetCollectionLocally>(
    () => GetCollectionLocally(repository: getIt()),
  );

  getIt.registerLazySingleton<StoreCollectionLocally>(
    () => StoreCollectionLocally(repository: getIt()),
  );
  getIt.registerLazySingleton<StoreCollectionRemote>(
    () => StoreCollectionRemote(repository: getIt()),
  );

  getIt.registerLazySingleton<CollectionGeneratorBloc>(
      () => CollectionGeneratorBloc(
            getCollection: getIt(),
            storeLocal: getIt(),
            storeRemote: getIt(),
          ));
}
