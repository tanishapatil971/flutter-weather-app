import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  
  final MaterialColor? color;
  
  final Color iconcolor;

  const AdditionalInfoItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon, 
    required this.iconcolor, this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 333,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: iconcolor,),
              const SizedBox(height: 8),
              Text(label),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(
                fontSize: 14,
          
              ),),
            ],
          ),
        )
      ),
    );
  }
}