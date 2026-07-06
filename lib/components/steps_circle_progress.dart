import 'package:flutter/material.dart';

class StepsCircleProgress extends StatelessWidget {
  final int currentSteps;
  final double targetPercentage;
  final String improvementText;

  const StepsCircleProgress({
    super.key,
    required this.currentSteps,
    required this.targetPercentage,
    this.improvementText = '+13.3% than last month',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: targetPercentage,
                  strokeWidth: 8,
                  backgroundColor: const Color(0xFFEFF6FF),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                ),
              ),
              const Icon(Icons.directions_run, color: Color(0xFF2563EB), size: 28),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Steps today', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                _formatSteps(currentSteps),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 2),
              Text(
                improvementText,
                style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatSteps(int steps) {
    if (steps < 1000) return steps.toString();
    final parts = steps.toString().split('');
    parts.insert(parts.length - 3, ',');
    return parts.join('');
  }
}
