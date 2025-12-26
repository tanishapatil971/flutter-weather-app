import 'package:flutter/material.dart';

IconData getWeatherIcon(String condition) {
  switch (condition) {
    case 'Rain':
    case 'Drizzle':
      return Icons.grain; // rain icon
    case 'Thunderstorm':
      return Icons.flash_on;
    case 'Snow':
      return Icons.ac_unit;
    case 'Clouds':
      return Icons.cloud;
    case 'Clear':
      return Icons.wb_sunny;
    default:
      return Icons.wb_cloudy;
  }
}

Color getWeatherColor(String condition) {
  switch (condition) {
    case 'Rain':
    case 'Drizzle':
      return Colors.blue;
    case 'Thunderstorm':
      return Colors.deepPurple;
    case 'Snow':
      return Colors.lightBlueAccent;
    case 'Clouds':
      return const Color.fromARGB(255, 165, 213, 237);
    case 'Clear':
      return Colors.amber;
    default:
      return Colors.grey;
  }
}
