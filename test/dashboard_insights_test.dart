import 'package:flutter_test/flutter_test.dart';
import 'package:healthmonitor/core/models/blood_sugar_log.dart';
import 'package:healthmonitor/core/models/meal_log.dart';
import 'package:healthmonitor/features/dashboard/dashboard_insights.dart';

void main() {
  test('buildMealImpactInsights groups readings to linked meals', () {
    final meals = [
      MealLog(id: 'm1', timestamp: DateTime(2024, 1, 1, 8), mealType: 'Breakfast', foodDescription: 'Toast'),
    ];

    final bloodSugars = [
      BloodSugarLog(id: 'b1', timestamp: DateTime(2024, 1, 1, 7), value: 110, readingType: 'Pre-Meal', mealId: 'm1'),
      BloodSugarLog(id: 'b2', timestamp: DateTime(2024, 1, 1, 9), value: 150, readingType: 'Post-Meal', mealId: 'm1'),
    ];

    final insights = DashboardInsights.buildMealImpactInsights(meals: meals, bloodSugars: bloodSugars);

    expect(insights, hasLength(1));
    expect(insights.first.mealLabel, contains('Breakfast'));
    expect(insights.first.delta, 40);
    expect(insights.first.readingCount, 2);
  });
}
