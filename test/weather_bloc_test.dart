import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/bloc/weather_event.dart';
import 'package:weather/bloc/weather_state.dart';
import 'package:weather/service/api_service.dart';

class MockWeatherApiService extends Mock implements WeatherApiService {}

void main() {
  late MockWeatherApiService mockApi;

  setUp(() {
    mockApi = MockWeatherApiService();
  });

  group('WeatherBloc', () {
    blocTest<WeatherBloc, WeatherState>(
      'emits loading true then success state',
      build: () {
        when(() => mockApi.getHourlyForecast(any()))
            .thenAnswer((_) async => {
                  'current': {},
                  'forecast': {
                    'forecastday': [
                      {'hour': []}
                    ]
                  }
                });

        when(() => mockApi.getPastSevenDaysWeather(any()))
            .thenAnswer((_) async => []);

        return WeatherBloc(mockApi);
      },
      act: (bloc) => bloc.add(FetchWeather('Bishkek')),
      expect: () => [
        const WeatherState(loading: true),
        const WeatherState(
          loading: false,
          current: {},
          hourly: [],
          next7days: [],
          pastWeek: [],
          error: '',
        ),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits error state when api throws',
      build: () {
        when(() => mockApi.getHourlyForecast(any()))
            .thenThrow(Exception('Failed'));

        return WeatherBloc(mockApi);
      },
      act: (bloc) => bloc.add(FetchWeather('Bishkek')),
      expect: () => [
        const WeatherState(loading: true),
        isA<WeatherState>()
            .having((s) => s.loading, 'loading', false)
            .having((s) => s.error.isNotEmpty, 'error not empty', true),
      ],
    );
  });
}