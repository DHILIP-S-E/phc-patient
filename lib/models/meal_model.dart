class MealModel {
  final String title;
  final String calories;
  final String category;
  final String description;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final String chefName;
  final double chefRating;

  const MealModel({
    required this.title,
    required this.calories,
    required this.category,
    required this.description,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.chefName,
    required this.chefRating,
  });
}
