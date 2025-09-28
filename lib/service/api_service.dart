import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiKey = "d5f7e636b7354f6b9b6182140252101";

class WeatherApiService {
  final String baseUrl = "https://api.weatherapi.com/v1";
 
  Future<Map<String, dynamic>> getHourlyForecast(String location) async {
    final url = Uri.parse(
      "$baseUrl/forecast.json?key=$apiKey&q=$location&days=7",
    );

    final res = await http.get(url);
    
    if (res.statusCode != 200) {
      throw Exception("Failed to fetch data: ${res.body}");
    }
    
    final data = json.decode(res.body);
    
    if (data.containsKey('error')) {
      throw Exception(data['error']['message'] ?? 'Invalid location');
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> getPastSevenDaysWeather(
    String location,
  ) async {
    if (location.isEmpty) {
      throw Exception("Введите название города");
    }

    final List<Map<String, dynamic>> pastWeather = [];
    final today = DateTime.now();

    for (int i = 1; i <= 7; i++) {
      final date = today.subtract(Duration(days: i));
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final url = Uri.parse(
        "$baseUrl/history.json?key=$apiKey&q=$location&dt=$formattedDate",
      );

      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        if (data.containsKey('error')) {
          throw Exception(data['error']['message'] ?? 'Invalid location');
        }

        if (data['forecast']?['forecastday'] != null) {
          pastWeather.add(data);
        }
      } else {
        debugPrint('Failed to fetch data for $formattedDate: ${res.body}');
      }
    }

    return pastWeather;
  }
}
