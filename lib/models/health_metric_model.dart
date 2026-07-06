import 'package:flutter/material.dart';

class HealthMetric {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const HealthMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class WeightLog {
  final double currentWeight;
  final double lostWeight;
  final String totalCalories;

  const WeightLog({
    required this.currentWeight,
    required this.lostWeight,
    required this.totalCalories,
  });
}
