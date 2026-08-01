import '../../core/models/blood_sugar_log.dart';
import '../../core/models/meal_log.dart';

class MealImpactInsight {
  MealImpactInsight({
    required this.mealLabel,
    required this.preAverage,
    required this.postAverage,
    required this.delta,
    required this.readingCount,
  });

  final String mealLabel;
  final double preAverage;
  final double postAverage;
  final double delta;
  final int readingCount;
}

class DashboardInsights {
  static List<MealImpactInsight> buildMealImpactInsights({
    required List<MealLog> meals,
    required List<BloodSugarLog> bloodSugars,
  }) {
    final readingsByMeal = <String, List<BloodSugarLog>>{};
    for (final reading in bloodSugars) {
      if (reading.mealId == null || reading.mealId!.isEmpty) {
        continue;
      }
      readingsByMeal.putIfAbsent(reading.mealId!, () => <BloodSugarLog>[]).add(reading);
    }

    final insights = <MealImpactInsight>[];
    for (final meal in meals) {
      final readings = readingsByMeal[meal.id] ?? const <BloodSugarLog>[];
      final preReadings = readings.where((entry) => entry.readingType == 'Pre-Meal').toList();
      final postReadings = readings.where((entry) => entry.readingType == 'Post-Meal').toList();
      if (preReadings.isEmpty || postReadings.isEmpty) {
        continue;
      }

      final preAverage = _average(preReadings.map((entry) => entry.value).toList());
      final postAverage = _average(postReadings.map((entry) => entry.value).toList());
      insights.add(MealImpactInsight(
        mealLabel: '${meal.mealType}: ${meal.foodDescription}',
        preAverage: preAverage,
        postAverage: postAverage,
        delta: postAverage - preAverage,
        readingCount: preReadings.length + postReadings.length,
      ));
    }

    insights.sort((a, b) => b.delta.compareTo(a.delta));
    return insights;
  }

  static double _average(List<double> values) {
    if (values.isEmpty) {
      return 0;
    }
    return values.reduce((a, b) => a + b) / values.length;
  }
}
