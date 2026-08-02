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
    groups.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    for (final group in groups) {
      group.meals.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      group.insulins.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      group.bloodSugars.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    final buffer = StringBuffer();
    buffer.writeln('GlucoseSync Timeline Feed');
    buffer.writeln('Generated from dashboard timeline');
    buffer.writeln('');

    if (groups.isEmpty) {
      buffer.writeln('No entries available.');
      return buffer.toString();
    }

    buffer.writeln('Time | Insulin | Pre | Post');
    buffer.writeln('-----|---------|-----|-----');

    for (final group in groups) {
      buffer.writeln('Date: ${_formatDateHeader(group.timestamp)}');
      final rows = <String>[];

      final insulinRows = group.insulins.map((insulin) => '${_formatTime(insulin.timestamp)} | ${_formatInsulinValue(insulin)} | — | —').toList();
      final prePostRows = group.bloodSugars.map((reading) => '${_formatTime(reading.timestamp)} | — | ${reading.readingType == 'Pre-Meal' ? reading.value.toStringAsFixed(0) : '—'} | ${reading.readingType == 'Post-Meal' ? reading.value.toStringAsFixed(0) : '—'}').toList();
      final mealRows = group.meals.map((meal) => '${_formatTime(meal.timestamp)} | — | — | — | ${meal.mealType}: ${meal.foodDescription}').toList();

      rows.addAll(insulinRows);
      rows.addAll(prePostRows);
      rows.addAll(mealRows);

      if (rows.isEmpty) {
        rows.add('— | — | — | —');
      }

      if (rows.isNotEmpty) {
        for (final row in rows) {
          buffer.writeln(row);
        }
      }

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
