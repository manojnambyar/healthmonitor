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

    void addGroup(DateTime timestamp, String? selectedPeriod) {
      final period = selectedPeriod ?? _period(timestamp);
      final key = '${timestamp.year}-${timestamp.month}-${timestamp.day}-$period';
      map.putIfAbsent(key, () => _TimelineExportGroup(timePeriod: period, timestamp: timestamp));
    }

    for (final meal in meals) {
      addGroup(meal.timestamp, meal.timePeriod);
      map['${meal.timestamp.year}-${meal.timestamp.month}-${meal.timestamp.day}-${meal.timePeriod ?? _period(meal.timestamp)}']!.meals.add(meal);
    }

    for (final insulin in insulins) {
      addGroup(insulin.timestamp, insulin.timePeriod);
      map['${insulin.timestamp.year}-${insulin.timestamp.month}-${insulin.timestamp.day}-${insulin.timePeriod ?? _period(insulin.timestamp)}']!.insulins.add(insulin);
    }

    for (final reading in bloodSugars) {
      addGroup(reading.timestamp, reading.timePeriod);
      map['${reading.timestamp.year}-${reading.timestamp.month}-${reading.timestamp.day}-${reading.timePeriod ?? _period(reading.timestamp)}']!.bloodSugars.add(reading);
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

    DateTime? lastDate;
    for (final group in groups) {
      final currentDate = DateTime(group.timestamp.year, group.timestamp.month, group.timestamp.day);
      if (lastDate == null || currentDate != lastDate) {
        buffer.writeln('Date: ${_formatDateHeader(group.timestamp)}');
        lastDate = currentDate;
      }
      
      final rows = <String>[];

      for (final meal in group.meals) {
        rows.add('${_formatTime(meal.timestamp)} | ${_formatInsulin(group.insulins)} | ${_formatPre(group.bloodSugars)} | ${_formatPost(group.bloodSugars)} | ${meal.mealType}: ${meal.foodDescription}');
      }

      if (rows.isEmpty) {
        if (group.insulins.isNotEmpty || group.bloodSugars.isNotEmpty) {
          rows.add('${_formatTime(group.insulins.isNotEmpty ? group.insulins.first.timestamp : group.bloodSugars.first.timestamp)} | ${_formatInsulin(group.insulins)} | ${_formatPre(group.bloodSugars)} | ${_formatPost(group.bloodSugars)} | —');
        }
      }

      if (rows.isNotEmpty) {
        for (final row in rows) {
          buffer.writeln(row);
        }
      }
    }

    return buffer.toString();
  }

  String _period(DateTime time) => time.hour < 12 ? 'morning' : time.hour < 18 ? 'afternoon' : 'night';

  String _formatDateHeader(DateTime time) => '${time.day.toString().padLeft(2, '0')} ${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][time.month - 1]} ${time.year}';

  String _formatTime(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _formatInsulin(List<InsulinLog> insulins) => insulins.isEmpty ? '—' : insulins.first.doseUnits.toStringAsFixed(1);

  String _formatPre(List<BloodSugarLog> bloodSugars) => bloodSugars.where((item) => item.readingType == 'Pre-Meal').map((item) => item.value.toStringAsFixed(0)).join(', ');

  String _formatPost(List<BloodSugarLog> bloodSugars) => bloodSugars.where((item) => item.readingType == 'Post-Meal').map((item) => item.value.toStringAsFixed(0)).join(', ');
}

class _TimelineExportGroup {
  _TimelineExportGroup({required this.timePeriod, required this.timestamp});

  final String timePeriod;
  final DateTime timestamp;
  final List<MealLog> meals = [];
  final List<InsulinLog> insulins = [];
  final List<BloodSugarLog> bloodSugars = [];
}
