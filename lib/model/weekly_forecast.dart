import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/bloc/weather_state.dart';
import 'package:intl/intl.dart';

class WeeklyForecast extends StatelessWidget {
  const WeeklyForecast({Key? key}) : super(key: key);

  String formatApiDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
     

        return DateFormat('d MMM, EEEE').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final city = state.current['location']?['name'] ?? '';
            final currentValue = state.current;
            final pastWeek = state.pastWeek;
            final next7days = state.next7days;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          city,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${currentValue['temp_c'] ?? ''} °C",
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${currentValue['condition']?['text'] ?? ''}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        if (currentValue['condition']?['icon'] != null)
                          Image.network(
                            "https:${currentValue['condition']['icon']}",
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Next 7 Days Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...next7days.map((day) {
                    final date = day['date'] ?? "";
                    final condition = day['day']?['condition']?['text'] ?? '';
                    final icon = day['day']?['condition']?['icon'] ?? '';
                    final maxTemp = day['day']?['maxtemp_c']?.toString() ?? '';
                    final minTemp = day['day']?['mintemp_c']?.toString() ?? '';

                    return ListTile(
                      leading: Image.network('https:$icon', width: 40),
                      title: Text(
                        formatApiDate(date),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      subtitle: Text(
                        "$condition $minTemp°C - $maxTemp°C",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  Text(
                    'Previous 7 Days Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...pastWeek.map((day) {
                    final forecastDays = day['forecast']?['forecastday'];
                    if (forecastDays == null || forecastDays.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final forecast = forecastDays[0];
                    final date = forecast['date'] ?? "";
                    final condition = forecast['day']?['condition']?['text'] ?? '';
                    final icon = forecast['day']?['condition']?['icon'] ?? '';
                    final maxTemp = forecast['day']?['maxtemp_c']?.toString() ?? '';
                    final minTemp = forecast['day']?['mintemp_c']?.toString() ?? '';

                    return ListTile(
                      leading: Image.network('https:$icon', width: 40),
                      title: Text(
                        formatApiDate(date),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      subtitle: Text(
                        "$condition $minTemp°C - $maxTemp°C",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
