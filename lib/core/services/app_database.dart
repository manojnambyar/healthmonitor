import 'package:drift/drift.dart';

import 'app_database_native.dart';

part 'app_database.g.dart';

class MealTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get mealType => text()();
  TextColumn get foodDescription => text()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class InsulinTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get doseUnits => real()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class BloodSugarTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get value => real()();
  TextColumn get readingType => text()();
  TextColumn get mealId => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [MealTable, InsulinTable, BloodSugarTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<MealTableData>> getMeals() => select(mealTable).get();
  Future<List<InsulinTableData>> getInsulins() => select(insulinTable).get();
  Future<List<BloodSugarTableData>> getBloodSugars() => select(bloodSugarTable).get();

  Future<void> insertMeal(MealTableCompanion entry) => into(mealTable).insert(entry);
  Future<void> insertInsulin(InsulinTableCompanion entry) => into(insulinTable).insert(entry);
  Future<void> insertBloodSugar(BloodSugarTableCompanion entry) => into(bloodSugarTable).insert(entry);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    return openConnection();
  });
}
