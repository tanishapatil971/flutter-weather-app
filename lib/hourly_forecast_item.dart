import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  
  final String temperature;
  final IconData icon;
  final Color iconColor;
  
  final dynamic time;

  const WeatherCard({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon, 
    required this.iconColor, });
    
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(height: 8),
            Text(time),
            const SizedBox(height: 8),
            Text(temperature, style: const TextStyle(
              fontSize: 14,
        
            ),),
          ],
        ),
      )
    );
  }
}