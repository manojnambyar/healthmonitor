import 'package:flutter_test/flutter_test.dart';
import 'package:healthmonitor/features/sync/google_sheets_sync_service.dart';

void main() {
  test('buildRows omits removed meal and insulin fields from sync payloads', () {
    final service = GoogleSheetsSyncService();

    final rows = service.buildRows(
      meals: [
        {'mealType': 'Breakfast', 'foodDescription': 'Toast'},
      ],
      insulin: [
        {'timestamp': '2024-01-01T08:00:00.000', 'doseUnits': 4.0},
      ],
      bloodSugar: [
        {'value': 110.0, 'readingType': 'Pre-Meal'},
      ],
    );

    expect(rows.where((row) => row['sheet'] == 'Meals').every((row) => !row.containsKey('estimatedCarbs')), isTrue);
    expect(rows.where((row) => row['sheet'] == 'Insulin').every((row) => !row.containsKey('insulinType')), isTrue);
  });
}
