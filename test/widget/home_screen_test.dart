import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather/view/home_screen.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/service/api_service.dart';

void main() {
  testWidgets('HomeScreen loads correctly', (WidgetTester tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => WeatherBloc(WeatherApiService()),
          child: const WeatherAppHomeScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(WeatherAppHomeScreen), findsOneWidget);
  });

  testWidgets('HomeScreen contains Scaffold', (WidgetTester tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => WeatherBloc(WeatherApiService()),
          child: const WeatherAppHomeScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(Scaffold), findsOneWidget);
  });
}