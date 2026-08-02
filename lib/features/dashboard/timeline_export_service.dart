import 'package:healthmonitor/core/models/blood_sugar_log.dart';
import 'package:healthmonitor/core/models/insulin_log.dart';
import 'package:healthmonitor/core/models/meal_log.dart';

class TimelineExportService {
  String buildPlainTextContent({
    required List<MealLog> meals,
    required List<InsulinLog> insulins,
    required List<BloodSugarLog> bloodSugars,
  }) {
    final groups = <_TimelineExportGroup>[];
    final map = <String, _TimelineExportGroup>{};

    void addGroup(DateTime timestamp) {
      final key = '${timestamp.year}-${timestamp.month}-${timestamp.day}';
      map.putIfAbsent(key, () => _TimelineExportGroup(timestamp: timestamp));
    }

    for (final meal in meals) {
      addGroup(meal.timestamp);
      map['${meal.timestamp.year}-${meal.timestamp.month}-${meal.timestamp.day}']!.meals.add(meal);
    }

    for (final insulin in insulins) {
      addGroup(insulin.timestamp);
      map['${insulin.timestamp.year}-${insulin.timestamp.month}-${insulin.timestamp.day}']!.insulins.add(insulin);
    }

    for (final reading in bloodSugars) {
      addGroup(reading.timestamp);
      map['${reading.timestamp.year}-${reading.timestamp.month}-${reading.timestamp.day}']!.bloodSugars.add(reading);
    }

    groups.addAll(map.values);
    // Sort groups chronologically (oldest first) for a logical timeline view
    groups.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    for (final group in groups) {
      group.meals.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      group.insulins.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      group.bloodSugars.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }

    final buffer = StringBuffer();
    buffer.writeln('GlucoseSync Timeline Feed');
    buffer.writeln('Generated from dashboard timeline');
    buffer.writeln('');

    if (groups.isEmpty) {
      buffer.writeln('No entries available.');
      return buffer.toString();
    }

    // Updated header to include a fifth column for details like meal descriptions
    buffer.writeln('Time | Insulin | Pre | Post | Details');
    buffer.writeln('-----|---------|-----|-----|-------');

    for (final group in groups) {
      final rows = <String>[];

      // Insulin rows: include placeholder for Details column
      final insulinRows = group.insulins.map((insulin) => 
        '${_formatTime(insulin.timestamp)} | ${_formatInsulinValue(insulin)} | — | — | — '
      ).toList();
      rows.addAll(insulinRows);

      // Blood sugar rows: include placeholder for Details column
      final prePostRows = group.bloodSugars.map((reading) => 
        '${_formatTime(reading.timestamp)} | — | ${reading.readingType == 'Pre-Meal' ? reading.value.toStringAsFixed(0) : '—'} | ${reading.readingType == 'Post-Meal' ? reading.value.toStringAsFixed(0) : '—'} | — '
      ).toList();
      rows.addAll(prePostRows);

      // Meal rows: place description in the Details column
      final mealRows = group.meals.map((meal) => 
        '${_formatTime(meal.timestamp)} | — | — | — | ${meal.mealType}: ${meal.foodDescription}'
      ).toList();
      rows.addAll(mealRows);

      if (rows.isEmpty) {
        rows.add('— | — | — | — | — ');
      }

      for (final row in rows) {
        buffer.writeln(row);
      }

      // Add a blank line between groups for readability
      buffer.writeln('');
    }

    return buffer.toString();
  }

  String _formatDateHeader(DateTime time) => '${time.day.toString().padLeft(2, '0')} ${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][time.month - 1]} ${time.year}';

  String _formatTime(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _formatInsulinValue(InsulinLog insulin) => insulin.doseUnits.toStringAsFixed(1);
}

class _TimelineExportGroup {
  _TimelineExportGroup({required this.timestamp});

  final DateTime timestamp;
  final List<MealLog> meals = [];
  final List<InsulinLog> insulins = [];
  final List<BloodSugarLog> bloodSugars = [];
}