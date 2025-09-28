import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/bloc/weather_event.dart';
import 'package:weather/bloc/weather_state.dart';

import 'package:weather/model/weekly_forecast.dart';


class WeatherAppHomeScreen extends StatefulWidget {
  const WeatherAppHomeScreen({Key? key}) : super(key: key);

  @override
  State<WeatherAppHomeScreen> createState() => _WeatherAppHomeScreenState(currentValue: {}, city: '', pastWeek: [], next7days: []);
}

class _WeatherAppHomeScreenState extends State<WeatherAppHomeScreen> {
final Map<String, dynamic> currentValue;
String city;
final List<dynamic> pastWeek;
final List<dynamic> next7days;

  _WeatherAppHomeScreenState({required this.currentValue, required this.city, required this.pastWeek, required this.next7days});


  @override
  void initState() {
    super.initState();
    context.read<WeatherBloc>().add(FetchWeather('Bishkek'));
  }

  String formatDateTime(String timeString) {
    DateTime time = DateTime.parse(timeString);
    return DateFormat.j().format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          const SizedBox(width: 25),
          SizedBox(
            width: 320,
            height: 50,
            child: TextField(
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18,
              ),
              onSubmitted: (value) {
                if (value.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a valid city name.")));
                  return;
                }
                city = value.trim();
                context.read<WeatherBloc>().add(FetchWeather(city));
              },
              decoration: InputDecoration(
                labelText: 'Search city',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.surface),
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
                ),
              ),
            ),
          ),
          const Spacer(),
          // Здесь можно добавить переключение темы (если используешь Riverpod или Bloc)
          const SizedBox(width: 20),
        ],
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error.isNotEmpty) {
            return Center(
              child: Text(
                state.error,
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            );
          }

          final currentValue = state.current;
          final hourly = state.hourly;
          final next7days = state.next7days;
          final pastWeek = state.pastWeek;

          final iconPath = currentValue['condition']?['icon'] ?? '';
          final imageUrl = iconPath.isNotEmpty ? "https:$iconPath" : "";

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentValue.isNotEmpty) ...[
                  Center(
                    child: Column(
                      children: [
                        Text(
                          city,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${currentValue['temp_c']} °C",
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${currentValue['condition']['text']}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        if (imageUrl.isNotEmpty)
                          Image.network(imageUrl, width: 400, height: 400),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          'Today Forecast',
                          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.secondary),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const WeeklyForecast(),
                            ));
                          },
                          child: Text(
                            'Weekly Forecast',
                            style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hourly.length,
                      itemBuilder: (context, index) {
                        final hour = hourly[index];
                        final now = DateTime.now();
                        final hourTime = DateTime.parse(hour['time']);
                        final isCurrentHour = now.hour == hourTime.hour && now.day == hourTime.day;

                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text(
                                isCurrentHour ? "Now" : formatDateTime(hour['time']),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Image.network("https:${hour['condition']?['icon']}",
                                  width: 40, height: 40, fit: BoxFit.cover),
                              const SizedBox(height: 10),
                              Text("${hour["temp_c"]}°C",
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
