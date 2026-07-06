import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }
}
