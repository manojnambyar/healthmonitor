class MealLog {
  MealLog({
    required this.id,
    required this.timestamp,
    required this.mealType,
    required this.foodDescription,
    this.estimatedCarbs,
    this.timePeriod,
    this.isSynced = false,
  });

  final String id;
  final DateTime timestamp;
  final String mealType;
  final String foodDescription;
  final double? estimatedCarbs;
  final String? timePeriod;
  final bool isSynced;
}
