import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/home/data/repositories/open_door_repository_impl.dart';
import 'features/home/domain/repositories/open_door_repository.dart';
import 'features/home/presentation/cubit/home_cubit.dart';

final sl = GetIt.instance;

void init() {
  sl
    ..registerLazySingleton(() => http.Client())
    ..registerLazySingleton<OpenDoorRepository>(() => OpenDoorRepositoryImpl())
    ..registerLazySingleton(() => HomeCubit());
}
