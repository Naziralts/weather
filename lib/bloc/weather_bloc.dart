import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/service/api_service.dart';

import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApiService api;

  WeatherBloc(this.api) : super(const WeatherState()) {
    on<FetchWeather>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
      FetchWeather event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(loading: true));

    try {
      final forecast = await api.getHourlyForecast(event.city);
      final past = await api.getPastSevenDaysWeather(event.city);

      emit(state.copyWith(
        current: forecast['current'] ?? {},
        hourly: forecast['forecast']?['forecastday']?[0]?['hour'] ?? [],
        next7days: forecast['forecast']?['forecastday'] ?? [],
        pastWeek: past,
        loading: false,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
