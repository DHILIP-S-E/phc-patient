import 'package:flutter/material.dart';
import '../models/meal_model.dart';

class MealDetailPage extends StatelessWidget {
  final MealModel meal;

  const MealDetailPage({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Color(0xFF1E293B)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Floating Back arrow, and Meal circular plate mockup
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: const Icon(Icons.restaurant, size: 80, color: Color(0xFF10B981)),
              ),
            ),
            const SizedBox(height: 32),

            // Title and Description
            const Text(
              'Suggested Meal',
              style: TextStyle(fontSize: 12, color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              meal.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),
            Text(
              meal.description,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.5),
            ),
            const SizedBox(height: 24),

            // Nutrition indicators row (Calories, Weight, Protein, Carbs, Fat)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNutritionItem(Icons.local_fire_department, meal.calories, 'Calories', Colors.orange),
                _buildNutritionItem(Icons.scale, '290g', 'Weight', Colors.teal),
                _buildNutritionItem(Icons.egg, '${meal.proteinGrams}g', 'Protein', Colors.blue),
                _buildNutritionItem(Icons.cookie, '${meal.carbsGrams}g', 'Carbs', Colors.amber),
                _buildNutritionItem(Icons.opacity, '${meal.fatGrams}g', 'Fat', Colors.red),
              ],
            ),
            const SizedBox(height: 28),

            // Cooking Expert / Coach Card
            const Text(
              'Recommended By',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDBEAFE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.face, color: Color(0xFF2563EB)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.chefName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Clinical Nutritionist & Cooking Expert',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFD97706), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        meal.chefRating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Make meal call to action
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Add to Daily Diet Log', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem(IconData icon, String val, String label, Color col) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: col.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: col, size: 16),
        ),
        const SizedBox(height: 8),
        Text(
          val,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8)),
        ),
      ],
    );
  }
}
