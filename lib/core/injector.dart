import 'package:get_it/get_it.dart';
import 'package:weather/service/api_service.dart';
import 'package:weather/bloc/weather_bloc.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton(() => WeatherApiService());

  // BLoC
  sl.registerFactory(() => WeatherBloc(sl()));
}
