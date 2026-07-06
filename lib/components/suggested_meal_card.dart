import 'package:flutter/material.dart';
import '../models/meal_model.dart';

class SuggestedMealCard extends StatelessWidget {
  final MealModel meal;
  final VoidCallback onTap;

  const SuggestedMealCard({
    super.key,
    required this.meal,
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
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.food_bank, color: Color(0xFF10B981), size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${meal.calories} kcal · ${meal.category}',
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
