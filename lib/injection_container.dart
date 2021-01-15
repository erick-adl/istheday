import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/date/data/datasources/date_local_data_source.dart';
import 'features/date/data/datasources/date_remote_data_source.dart';
import 'features/date/data/repositories/date_repository_impl.dart';
import 'features/date/domain/repositories/date_repository.interface.dart';
import 'features/date/domain/usecases/get_concrete_date.dart';
import 'features/date/domain/usecases/get_random_date.dart';
import 'features/date/presentation/bloc/bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(
    () => DateBloc(
      concrete: sl(),
      inputConverter: sl(),
      random: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetConcreteDate(sl()));
  sl.registerLazySingleton(() => GetRandomDate(sl()));

  // Repository
  sl.registerLazySingleton<IDateRepository>(
    () => DateRepository(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<IDateRemoteDataSource>(
    () => DateRemoteDataSource(client: sl()),
  );

  sl.registerLazySingleton<IDateLocalDataSource>(
    () => DateLocalDataSource(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
