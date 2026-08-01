import 'package:drift/drift.dart';

import '../models/blood_sugar_log.dart';
import '../models/insulin_log.dart';
import '../models/meal_log.dart';
import 'app_database.dart';

class DriftStorageService {
  DriftStorageService(this.db);

  static const _periodMarker = '||period=';
  final AppDatabase db;

  Future<void> addMeal(MealLog log) => db.insertMeal(MealTableCompanion(
        id: Value(log.id),
        timestamp: Value(log.timestamp),
        mealType: Value(_withPeriod(log.mealType, log.timePeriod)),
        foodDescription: Value(log.foodDescription),
        estimatedCarbs: Value(log.estimatedCarbs),
        isSynced: Value(log.isSynced),
      ));

  Future<void> addInsulin(InsulinLog log) => db.insertInsulin(InsulinTableCompanion(
        id: Value(log.id),
        timestamp: Value(log.timestamp),
        insulinType: Value(log.insulinType),
        doseUnits: Value(log.doseUnits),
        notes: Value(_withPeriod(log.notes ?? '', log.timePeriod)),
        isSynced: Value(log.isSynced),
      ));

  Future<void> addBloodSugar(BloodSugarLog log) => db.insertBloodSugar(BloodSugarTableCompanion(
        id: Value(log.id),
        timestamp: Value(log.timestamp),
        value: Value(log.value),
        readingType: Value(log.readingType),
        mealId: Value(log.mealId),
        notes: Value(_withPeriod(log.notes ?? '', log.timePeriod)),
        isSynced: Value(log.isSynced),
      ));

  Future<List<MealLog>> getMeals() async {
    final rows = await db.getMeals();
    return rows.map((row) {
      final data = _splitPeriod(row.mealType);
      return MealLog(
        id: row.id,
        timestamp: row.timestamp,
        mealType: data.value,
        foodDescription: row.foodDescription,
        estimatedCarbs: row.estimatedCarbs,
        timePeriod: data.period,
        isSynced: row.isSynced,
      );
    }).toList();
  }

  Future<List<InsulinLog>> getInsulins() async {
    final rows = await db.getInsulins();
    return rows.map((row) {
      final data = _splitPeriod(row.notes ?? '');
      return InsulinLog(
        id: row.id,
        timestamp: row.timestamp,
        insulinType: row.insulinType,
        doseUnits: row.doseUnits,
        notes: data.value.isEmpty ? null : data.value,
        timePeriod: data.period,
        isSynced: row.isSynced,
      );
    }).toList();
  }

  Future<List<BloodSugarLog>> getBloodSugars() async {
    final rows = await db.getBloodSugars();
    return rows.map((row) {
      final data = _splitPeriod(row.notes ?? '');
      return BloodSugarLog(
        id: row.id,
        timestamp: row.timestamp,
        value: row.value,
        readingType: row.readingType,
        mealId: row.mealId,
        notes: data.value.isEmpty ? null : data.value,
        timePeriod: data.period,
        isSynced: row.isSynced,
      );
    }).toList();
  }

  String _withPeriod(String value, String? period) => period == null ? value : '$value$_periodMarker$period';

  _StoredValue _splitPeriod(String value) {
    final markerIndex = value.lastIndexOf(_periodMarker);
    if (markerIndex < 0) return _StoredValue(value, null);
    return _StoredValue(value.substring(0, markerIndex), value.substring(markerIndex + _periodMarker.length));
  }
}

class _StoredValue {
  const _StoredValue(this.value, this.period);
  final String value;
  final String? period;
}
