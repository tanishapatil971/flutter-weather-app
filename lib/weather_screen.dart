import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/secrets.dart';
import 'hourly_forecast_item.dart';
import 'additional_info_item.dart';
import 'weather_icon.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherMapApiKey',
        ),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw 'An error occurred: ${data['message']}';
      }
      return data;
      //data['list'][0]['main']['temp];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });

              // Add refresh functionality here
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemp K',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Icon(
                                  getWeatherIcon(currentSky),
                                  size: 64,
                                  color: getWeatherColor(currentSky),
                                ),

                                const SizedBox(height: 8),
                                Text(
                                  '$currentSky',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Hourly Forecast',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < 7; i++) ...[
                          WeatherCard(
                            time: data['list'][i + 1]['dt_txt']
                                .toString()
                                .substring(11, 16),
                            temperature:
                                '${data['list'][i + 1]['main']['temp']} K',
                            icon: getWeatherIcon(
                              data['list'][i + 1]['weather'][0]['main'],
                            ),
                            iconColor: getWeatherColor(
                              data['list'][i + 1]['weather'][0]['main'],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  //humidity and wind speed
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //humidity
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AdditionalInfoItem(
                          label: 'Humidity',
                          value: '$currentHumidity %',
                          icon: Icons.water_drop,
                          iconcolor: Colors.lightBlue,
                        ),
                        const SizedBox(height: 16),
                        //Wind Speed Card
                        AdditionalInfoItem(
                          label: 'Wind Speed',
                          value: '$currentWindSpeed m/s',
                          icon: Icons.air,
                          iconcolor: const Color.fromARGB(255, 3, 211, 211),
                        ),
                        const SizedBox(height: 16),
                        //Pressure Card
                        AdditionalInfoItem(
                          label: 'Pressure',
                          value: '$currentPressure hPa',
                          icon: Icons.speed,
                          iconcolor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
