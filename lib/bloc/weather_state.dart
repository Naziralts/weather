import 'package:equatable/equatable.dart';

class WeatherState extends Equatable {
  final bool loading;
  final Map<String, dynamic> current;
  final List<dynamic> hourly;
  final List<dynamic> next7days;
  final List<dynamic> pastWeek;
  final String error;

  const WeatherState({
    this.loading = false,
    this.current = const {},
    this.hourly = const [],
    this.next7days = const [],
    this.pastWeek = const [],
    this.error = '',
  });

  WeatherState copyWith({
    bool? loading,
    Map<String, dynamic>? current,
    List<dynamic>? hourly,
    List<dynamic>? next7days,
    List<dynamic>? pastWeek,
    String? error,
  }) {
    return WeatherState(
      loading: loading ?? this.loading,
      current: current ?? this.current,
      hourly: hourly ?? this.hourly,
      next7days: next7days ?? this.next7days,
      pastWeek: pastWeek ?? this.pastWeek,
      error: error ?? this.error, 
    );
  }

  @override
  List<Object?> get props =>
      [loading, current, hourly, next7days, pastWeek, error];
}