import 'package:flutter/material.dart';

class StrengthScoreCard extends StatelessWidget {
  final int score;
  final int rank;
  final VoidCallback onTap;

  const StrengthScoreCard({
    super.key,
    required this.score,
    required this.rank,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.fitness_center, color: Color(0xFF2563EB), size: 20),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Strength Score',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Based on your core muscle workouts',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$score #$rank',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2563EB)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
