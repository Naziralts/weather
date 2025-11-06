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
  State<WeatherAppHomeScreen> createState() => _WeatherAppHomeScreenState(
        currentValue: {},
        city: '',
        pastWeek: [],
        next7days: [],
      );
}

class _WeatherAppHomeScreenState extends State<WeatherAppHomeScreen> {
  final Map<String, dynamic> currentValue;
  String city;
  final List<dynamic> pastWeek;
  final List<dynamic> next7days;

  _WeatherAppHomeScreenState({
    required this.currentValue,
    required this.city,
    required this.pastWeek,
    required this.next7days,
  });

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
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

    // Адаптивные размеры
    final double titleFont = screenWidth < 400 ? 26 : 32;
    final double tempFont = screenWidth < 400 ? 22 : 28;
    final double imageSize = screenWidth < 400 ? 250 : 350;
    final double smallFont = screenWidth < 400 ? 14 : 16;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text("Weather App"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      state.error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: smallFont,
                      ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🔍 Поле ввода
                      SizedBox(
                        width: screenWidth > 600 ? 500 : screenWidth * 0.9,
                        height: 50,
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: smallFont + 2,
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter a valid city name."),
                                ),
                              );
                              return;
                            }
                            city = value.trim();
                            context.read<WeatherBloc>().add(FetchWeather(city));
                          },
                          decoration: InputDecoration(
                            labelText: 'Search city',
                            prefixIcon: const Icon(Icons.search, color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                    
                      if (currentValue.isNotEmpty) ...[
                        Text(
                          city.isEmpty ? 'Bishkek' : city,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleFont,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${currentValue['temp_c']} °C",
                          style: TextStyle(
                            fontSize: tempFont,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${currentValue['condition']['text']}",
                          style: TextStyle(
                            fontSize: smallFont + 2,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (imageUrl.isNotEmpty)
                          Image.network(imageUrl,
                              width: imageSize, height: imageSize, fit: BoxFit.contain),
                      ],

                      const SizedBox(height: 20),

                      // 🌤️ Сегодня и неделя
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Text(
                              'Today Forecast',
                              style: TextStyle(
                                fontSize: smallFont + 2,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WeeklyForecast(),
                                  ),
                                );
                              },
                              child: Text(
                                'Weekly Forecast →',
                                style: TextStyle(
                                  fontSize: smallFont + 2,
                                  color: Colors.blue[200],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: hourly.length,
                          itemBuilder: (context, index) {
                            final hour = hourly[index];
                            final now = DateTime.now();
                            final hourTime = DateTime.parse(hour['time']);
                            final isCurrentHour =
                                now.hour == hourTime.hour && now.day == hourTime.day;

                            return Container(
                              width: 90,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white12,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isCurrentHour
                                        ? "Now"
                                        : formatDateTime(hour['time']),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: smallFont,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Image.network(
                                    "https:${hour['condition']?['icon']}",
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "${hour["temp_c"]}°C",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: smallFont,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
