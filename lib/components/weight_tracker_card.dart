import 'package:flutter/material.dart';
import '../models/health_metric_model.dart';

class WeightTrackerCard extends StatelessWidget {
  final WeightLog weightLog;

  const WeightTrackerCard({
    super.key,
    required this.weightLog,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weight Tracker',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            Icon(Icons.more_horiz, color: Color(0xFF64748B)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Current Weight
            Expanded(
              child: _buildSubBlock(
                icon: Icons.scale,
                value: '${weightLog.currentWeight.toStringAsFixed(0)} kg',
                label: 'Weight',
                col: const Color(0xFFEFF6FF),
                iconCol: const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(width: 8),
            // Lost Weight
            Expanded(
              child: _buildSubBlock(
                icon: Icons.percent,
                value: '-${weightLog.lostWeight.toStringAsFixed(0)} kg',
                label: 'Lost Weight',
                col: const Color(0xFFFDF2F8),
                iconCol: const Color(0xFFEC4899),
              ),
            ),
            const SizedBox(width: 8),
            // Total Calories
            Expanded(
              child: _buildSubBlock(
                icon: Icons.local_fire_department,
                value: weightLog.totalCalories,
                label: 'Total Calories',
                col: const Color(0xFFFFF7ED),
                iconCol: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubBlock({
    required IconData icon,
    required String value,
    required String label,
    required Color col,
    required Color iconCol,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconCol, size: 16),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
