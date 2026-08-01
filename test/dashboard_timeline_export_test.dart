import 'package:flutter_test/flutter_test.dart';
import 'package:healthmonitor/core/models/blood_sugar_log.dart';
import 'package:healthmonitor/core/models/insulin_log.dart';
import 'package:healthmonitor/core/models/meal_log.dart';
import 'package:healthmonitor/features/dashboard/timeline_export_service.dart';

void main() {
  test('buildPlainTextContent formats a dashboard-style export grouped by date', () {
    final service = TimelineExportService();

    final content = service.buildPlainTextContent(
      meals: [
        MealLog(
          id: 'm1',
          timestamp: DateTime(2024, 1, 1, 8, 0),
          mealType: 'Breakfast',
          foodDescription: 'Toast and fruit',
          timePeriod: 'morning',
        ),
      ],
      insulins: [
        InsulinLog(
          id: 'i1',
          timestamp: DateTime(2024, 1, 1, 7, 30),
          doseUnits: 4,
          timePeriod: 'morning',
        ),
      ],
      bloodSugars: [
        BloodSugarLog(
          id: 'b1',
          timestamp: DateTime(2024, 1, 1, 7, 0),
          value: 110,
          readingType: 'Pre-Meal',
          timePeriod: 'morning',
        ),
      ],
    );

    expect(content, contains('GlucoseSync Timeline Feed'));
    expect(content, contains('Date: 01 Jan 2024'));
    expect(content, contains('Breakfast: Toast and fruit'));
    expect(content, contains('4.0'));
    expect(content, contains('110'));
  });

  test('orders later timeline entries above older ones for the same day and period', () {
    final service = TimelineExportService();

    final content = service.buildPlainTextContent(
      meals: [
        MealLog(
          id: 'm1',
          timestamp: DateTime(2024, 1, 1, 8, 0),
          mealType: 'Breakfast',
          foodDescription: 'Toast and fruit',
          timePeriod: 'morning',
        ),
        MealLog(
          id: 'm2',
          timestamp: DateTime(2024, 1, 1, 9, 0),
          mealType: 'Lunch',
          foodDescription: 'Salad',
          timePeriod: 'morning',
        ),
      ],
      insulins: const [],
      bloodSugars: const [],
    );

    final breakfastIndex = content.indexOf('Breakfast: Toast and fruit');
    final lunchIndex = content.indexOf('Lunch: Salad');

    expect(breakfastIndex, isNot(-1));
    expect(lunchIndex, isNot(-1));
    expect(lunchIndex, lessThan(breakfastIndex));
  });

  test('writes the header once before the date sections', () {
    final service = TimelineExportService();

    final content = service.buildPlainTextContent(
      meals: [
        MealLog(
          id: 'm1',
          timestamp: DateTime(2024, 1, 1, 8, 0),
          mealType: 'Breakfast',
          foodDescription: 'Toast and fruit',
          timePeriod: 'morning',
        ),
        MealLog(
          id: 'm2',
          timestamp: DateTime(2024, 1, 2, 9, 0),
          mealType: 'Lunch',
          foodDescription: 'Salad',
          timePeriod: 'morning',
        ),
      ],
      insulins: const [],
      bloodSugars: const [],
    );

    expect(content.split('Time | Insulin | Pre | Post').length - 1, 1);
    expect(content, contains('Date: 01 Jan 2024'));
    expect(content, contains('Date: 02 Jan 2024'));
  });
}
