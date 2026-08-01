// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MealTableTable extends MealTable
    with TableInfo<$MealTableTable, MealTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodDescriptionMeta = const VerificationMeta(
    'foodDescription',
  );
  @override
  late final GeneratedColumn<String> foodDescription = GeneratedColumn<String>(
    'food_description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    mealType,
    foodDescription,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('food_description')) {
      context.handle(
        _foodDescriptionMeta,
        foodDescription.isAcceptableOrUnknown(
          data['food_description']!,
          _foodDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_foodDescriptionMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      foodDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_description'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $MealTableTable createAlias(String alias) {
    return $MealTableTable(attachedDatabase, alias);
  }
}

class MealTableData extends DataClass implements Insertable<MealTableData> {
  final String id;
  final DateTime timestamp;
  final String mealType;
  final String foodDescription;
  final bool isSynced;
  const MealTableData({
    required this.id,
    required this.timestamp,
    required this.mealType,
    required this.foodDescription,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['meal_type'] = Variable<String>(mealType);
    map['food_description'] = Variable<String>(foodDescription);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  MealTableCompanion toCompanion(bool nullToAbsent) {
    return MealTableCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      mealType: Value(mealType),
      foodDescription: Value(foodDescription),
      isSynced: Value(isSynced),
    );
  }

  factory MealTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealTableData(
      id: serializer.fromJson<String>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      mealType: serializer.fromJson<String>(json['mealType']),
      foodDescription: serializer.fromJson<String>(json['foodDescription']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'mealType': serializer.toJson<String>(mealType),
      'foodDescription': serializer.toJson<String>(foodDescription),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  MealTableData copyWith({
    String? id,
    DateTime? timestamp,
    String? mealType,
    String? foodDescription,
    bool? isSynced,
  }) => MealTableData(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    mealType: mealType ?? this.mealType,
    foodDescription: foodDescription ?? this.foodDescription,
    isSynced: isSynced ?? this.isSynced,
  );
  MealTableData copyWithCompanion(MealTableCompanion data) {
    return MealTableData(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      foodDescription: data.foodDescription.present
          ? data.foodDescription.value
          : this.foodDescription,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealTableData(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('mealType: $mealType, ')
          ..write('foodDescription: $foodDescription, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, timestamp, mealType, foodDescription, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealTableData &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.mealType == this.mealType &&
          other.foodDescription == this.foodDescription &&
          other.isSynced == this.isSynced);
}

class MealTableCompanion extends UpdateCompanion<MealTableData> {
  final Value<String> id;
  final Value<DateTime> timestamp;
  final Value<String> mealType;
  final Value<String> foodDescription;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const MealTableCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.mealType = const Value.absent(),
    this.foodDescription = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealTableCompanion.insert({
    required String id,
    required DateTime timestamp,
    required String mealType,
    required String foodDescription,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       timestamp = Value(timestamp),
       mealType = Value(mealType),
       foodDescription = Value(foodDescription);
  static Insertable<MealTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? mealType,
    Expression<String>? foodDescription,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (mealType != null) 'meal_type': mealType,
      if (foodDescription != null) 'food_description': foodDescription,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? timestamp,
    Value<String>? mealType,
    Value<String>? foodDescription,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return MealTableCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      mealType: mealType ?? this.mealType,
      foodDescription: foodDescription ?? this.foodDescription,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (foodDescription.present) {
      map['food_description'] = Variable<String>(foodDescription.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealTableCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('mealType: $mealType, ')
          ..write('foodDescription: $foodDescription, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InsulinTableTable extends InsulinTable
    with TableInfo<$InsulinTableTable, InsulinTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InsulinTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseUnitsMeta = const VerificationMeta(
    'doseUnits',
  );
  @override
  late final GeneratedColumn<double> doseUnits = GeneratedColumn<double>(
    'dose_units',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    doseUnits,
    notes,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'insulin_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<InsulinTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('dose_units')) {
      context.handle(
        _doseUnitsMeta,
        doseUnits.isAcceptableOrUnknown(data['dose_units']!, _doseUnitsMeta),
      );
    } else if (isInserting) {
      context.missing(_doseUnitsMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InsulinTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InsulinTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      doseUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dose_units'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $InsulinTableTable createAlias(String alias) {
    return $InsulinTableTable(attachedDatabase, alias);
  }
}

class InsulinTableData extends DataClass
    implements Insertable<InsulinTableData> {
  final String id;
  final DateTime timestamp;
  final double doseUnits;
  final String? notes;
  final bool isSynced;
  const InsulinTableData({
    required this.id,
    required this.timestamp,
    required this.doseUnits,
    this.notes,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['dose_units'] = Variable<double>(doseUnits);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  InsulinTableCompanion toCompanion(bool nullToAbsent) {
    return InsulinTableCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      doseUnits: Value(doseUnits),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isSynced: Value(isSynced),
    );
  }

  factory InsulinTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InsulinTableData(
      id: serializer.fromJson<String>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      doseUnits: serializer.fromJson<double>(json['doseUnits']),
      notes: serializer.fromJson<String?>(json['notes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'doseUnits': serializer.toJson<double>(doseUnits),
      'notes': serializer.toJson<String?>(notes),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  InsulinTableData copyWith({
    String? id,
    DateTime? timestamp,
    double? doseUnits,
    Value<String?> notes = const Value.absent(),
    bool? isSynced,
  }) => InsulinTableData(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    doseUnits: doseUnits ?? this.doseUnits,
    notes: notes.present ? notes.value : this.notes,
    isSynced: isSynced ?? this.isSynced,
  );
  InsulinTableData copyWithCompanion(InsulinTableCompanion data) {
    return InsulinTableData(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      doseUnits: data.doseUnits.present ? data.doseUnits.value : this.doseUnits,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InsulinTableData(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('doseUnits: $doseUnits, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, doseUnits, notes, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InsulinTableData &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.doseUnits == this.doseUnits &&
          other.notes == this.notes &&
          other.isSynced == this.isSynced);
}

class InsulinTableCompanion extends UpdateCompanion<InsulinTableData> {
  final Value<String> id;
  final Value<DateTime> timestamp;
  final Value<double> doseUnits;
  final Value<String?> notes;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const InsulinTableCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.doseUnits = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InsulinTableCompanion.insert({
    required String id,
    required DateTime timestamp,
    required double doseUnits,
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       timestamp = Value(timestamp),
       doseUnits = Value(doseUnits);
  static Insertable<InsulinTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? timestamp,
    Expression<double>? doseUnits,
    Expression<String>? notes,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (doseUnits != null) 'dose_units': doseUnits,
      if (notes != null) 'notes': notes,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InsulinTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? timestamp,
    Value<double>? doseUnits,
    Value<String?>? notes,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return InsulinTableCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      doseUnits: doseUnits ?? this.doseUnits,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (doseUnits.present) {
      map['dose_units'] = Variable<double>(doseUnits.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InsulinTableCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('doseUnits: $doseUnits, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BloodSugarTableTable extends BloodSugarTable
    with TableInfo<$BloodSugarTableTable, BloodSugarTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BloodSugarTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readingTypeMeta = const VerificationMeta(
    'readingType',
  );
  @override
  late final GeneratedColumn<String> readingType = GeneratedColumn<String>(
    'reading_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<String> mealId = GeneratedColumn<String>(
    'meal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    value,
    readingType,
    mealId,
    notes,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blood_sugar_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BloodSugarTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('reading_type')) {
      context.handle(
        _readingTypeMeta,
        readingType.isAcceptableOrUnknown(
          data['reading_type']!,
          _readingTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_readingTypeMeta);
    }
    if (data.containsKey('meal_id')) {
      context.handle(
        _mealIdMeta,
        mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BloodSugarTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BloodSugarTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      readingType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_type'],
      )!,
      mealId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $BloodSugarTableTable createAlias(String alias) {
    return $BloodSugarTableTable(attachedDatabase, alias);
  }
}

class BloodSugarTableData extends DataClass
    implements Insertable<BloodSugarTableData> {
  final String id;
  final DateTime timestamp;
  final double value;
  final String readingType;
  final String? mealId;
  final String? notes;
  final bool isSynced;
  const BloodSugarTableData({
    required this.id,
    required this.timestamp,
    required this.value,
    required this.readingType,
    this.mealId,
    this.notes,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['value'] = Variable<double>(value);
    map['reading_type'] = Variable<String>(readingType);
    if (!nullToAbsent || mealId != null) {
      map['meal_id'] = Variable<String>(mealId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  BloodSugarTableCompanion toCompanion(bool nullToAbsent) {
    return BloodSugarTableCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      value: Value(value),
      readingType: Value(readingType),
      mealId: mealId == null && nullToAbsent
          ? const Value.absent()
          : Value(mealId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isSynced: Value(isSynced),
    );
  }

  factory BloodSugarTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BloodSugarTableData(
      id: serializer.fromJson<String>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      value: serializer.fromJson<double>(json['value']),
      readingType: serializer.fromJson<String>(json['readingType']),
      mealId: serializer.fromJson<String?>(json['mealId']),
      notes: serializer.fromJson<String?>(json['notes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'value': serializer.toJson<double>(value),
      'readingType': serializer.toJson<String>(readingType),
      'mealId': serializer.toJson<String?>(mealId),
      'notes': serializer.toJson<String?>(notes),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  BloodSugarTableData copyWith({
    String? id,
    DateTime? timestamp,
    double? value,
    String? readingType,
    Value<String?> mealId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isSynced,
  }) => BloodSugarTableData(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    value: value ?? this.value,
    readingType: readingType ?? this.readingType,
    mealId: mealId.present ? mealId.value : this.mealId,
    notes: notes.present ? notes.value : this.notes,
    isSynced: isSynced ?? this.isSynced,
  );
  BloodSugarTableData copyWithCompanion(BloodSugarTableCompanion data) {
    return BloodSugarTableData(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      value: data.value.present ? data.value.value : this.value,
      readingType: data.readingType.present
          ? data.readingType.value
          : this.readingType,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BloodSugarTableData(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('value: $value, ')
          ..write('readingType: $readingType, ')
          ..write('mealId: $mealId, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, timestamp, value, readingType, mealId, notes, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BloodSugarTableData &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.value == this.value &&
          other.readingType == this.readingType &&
          other.mealId == this.mealId &&
          other.notes == this.notes &&
          other.isSynced == this.isSynced);
}

class BloodSugarTableCompanion extends UpdateCompanion<BloodSugarTableData> {
  final Value<String> id;
  final Value<DateTime> timestamp;
  final Value<double> value;
  final Value<String> readingType;
  final Value<String?> mealId;
  final Value<String?> notes;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const BloodSugarTableCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.value = const Value.absent(),
    this.readingType = const Value.absent(),
    this.mealId = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BloodSugarTableCompanion.insert({
    required String id,
    required DateTime timestamp,
    required double value,
    required String readingType,
    this.mealId = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       timestamp = Value(timestamp),
       value = Value(value),
       readingType = Value(readingType);
  static Insertable<BloodSugarTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? timestamp,
    Expression<double>? value,
    Expression<String>? readingType,
    Expression<String>? mealId,
    Expression<String>? notes,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (value != null) 'value': value,
      if (readingType != null) 'reading_type': readingType,
      if (mealId != null) 'meal_id': mealId,
      if (notes != null) 'notes': notes,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BloodSugarTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? timestamp,
    Value<double>? value,
    Value<String>? readingType,
    Value<String?>? mealId,
    Value<String?>? notes,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return BloodSugarTableCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      value: value ?? this.value,
      readingType: readingType ?? this.readingType,
      mealId: mealId ?? this.mealId,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (readingType.present) {
      map['reading_type'] = Variable<String>(readingType.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<String>(mealId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BloodSugarTableCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('value: $value, ')
          ..write('readingType: $readingType, ')
          ..write('mealId: $mealId, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MealTableTable mealTable = $MealTableTable(this);
  late final $InsulinTableTable insulinTable = $InsulinTableTable(this);
  late final $BloodSugarTableTable bloodSugarTable = $BloodSugarTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    mealTable,
    insulinTable,
    bloodSugarTable,
  ];
}

typedef $$MealTableTableCreateCompanionBuilder =
    MealTableCompanion Function({
      required String id,
      required DateTime timestamp,
      required String mealType,
      required String foodDescription,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$MealTableTableUpdateCompanionBuilder =
    MealTableCompanion Function({
      Value<String> id,
      Value<DateTime> timestamp,
      Value<String> mealType,
      Value<String> foodDescription,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$MealTableTableFilterComposer
    extends Composer<_$AppDatabase, $MealTableTable> {
  $$MealTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodDescription => $composableBuilder(
    column: $table.foodDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MealTableTable> {
  $$MealTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodDescription => $composableBuilder(
    column: $table.foodDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealTableTable> {
  $$MealTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get foodDescription => $composableBuilder(
    column: $table.foodDescription,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$MealTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealTableTable,
          MealTableData,
          $$MealTableTableFilterComposer,
          $$MealTableTableOrderingComposer,
          $$MealTableTableAnnotationComposer,
          $$MealTableTableCreateCompanionBuilder,
          $$MealTableTableUpdateCompanionBuilder,
          (
            MealTableData,
            BaseReferences<_$AppDatabase, $MealTableTable, MealTableData>,
          ),
          MealTableData,
          PrefetchHooks Function()
        > {
  $$MealTableTableTableManager(_$AppDatabase db, $MealTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<String> foodDescription = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealTableCompanion(
                id: id,
                timestamp: timestamp,
                mealType: mealType,
                foodDescription: foodDescription,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime timestamp,
                required String mealType,
                required String foodDescription,
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealTableCompanion.insert(
                id: id,
                timestamp: timestamp,
                mealType: mealType,
                foodDescription: foodDescription,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealTableTable,
      MealTableData,
      $$MealTableTableFilterComposer,
      $$MealTableTableOrderingComposer,
      $$MealTableTableAnnotationComposer,
      $$MealTableTableCreateCompanionBuilder,
      $$MealTableTableUpdateCompanionBuilder,
      (
        MealTableData,
        BaseReferences<_$AppDatabase, $MealTableTable, MealTableData>,
      ),
      MealTableData,
      PrefetchHooks Function()
    >;
typedef $$InsulinTableTableCreateCompanionBuilder =
    InsulinTableCompanion Function({
      required String id,
      required DateTime timestamp,
      required double doseUnits,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$InsulinTableTableUpdateCompanionBuilder =
    InsulinTableCompanion Function({
      Value<String> id,
      Value<DateTime> timestamp,
      Value<double> doseUnits,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$InsulinTableTableFilterComposer
    extends Composer<_$AppDatabase, $InsulinTableTable> {
  $$InsulinTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get doseUnits => $composableBuilder(
    column: $table.doseUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InsulinTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InsulinTableTable> {
  $$InsulinTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get doseUnits => $composableBuilder(
    column: $table.doseUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InsulinTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InsulinTableTable> {
  $$InsulinTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get doseUnits =>
      $composableBuilder(column: $table.doseUnits, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$InsulinTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InsulinTableTable,
          InsulinTableData,
          $$InsulinTableTableFilterComposer,
          $$InsulinTableTableOrderingComposer,
          $$InsulinTableTableAnnotationComposer,
          $$InsulinTableTableCreateCompanionBuilder,
          $$InsulinTableTableUpdateCompanionBuilder,
          (
            InsulinTableData,
            BaseReferences<_$AppDatabase, $InsulinTableTable, InsulinTableData>,
          ),
          InsulinTableData,
          PrefetchHooks Function()
        > {
  $$InsulinTableTableTableManager(_$AppDatabase db, $InsulinTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InsulinTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InsulinTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InsulinTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> doseUnits = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InsulinTableCompanion(
                id: id,
                timestamp: timestamp,
                doseUnits: doseUnits,
                notes: notes,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime timestamp,
                required double doseUnits,
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InsulinTableCompanion.insert(
                id: id,
                timestamp: timestamp,
                doseUnits: doseUnits,
                notes: notes,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InsulinTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InsulinTableTable,
      InsulinTableData,
      $$InsulinTableTableFilterComposer,
      $$InsulinTableTableOrderingComposer,
      $$InsulinTableTableAnnotationComposer,
      $$InsulinTableTableCreateCompanionBuilder,
      $$InsulinTableTableUpdateCompanionBuilder,
      (
        InsulinTableData,
        BaseReferences<_$AppDatabase, $InsulinTableTable, InsulinTableData>,
      ),
      InsulinTableData,
      PrefetchHooks Function()
    >;
typedef $$BloodSugarTableTableCreateCompanionBuilder =
    BloodSugarTableCompanion Function({
      required String id,
      required DateTime timestamp,
      required double value,
      required String readingType,
      Value<String?> mealId,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$BloodSugarTableTableUpdateCompanionBuilder =
    BloodSugarTableCompanion Function({
      Value<String> id,
      Value<DateTime> timestamp,
      Value<double> value,
      Value<String> readingType,
      Value<String?> mealId,
      Value<String?> notes,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$BloodSugarTableTableFilterComposer
    extends Composer<_$AppDatabase, $BloodSugarTableTable> {
  $$BloodSugarTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readingType => $composableBuilder(
    column: $table.readingType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealId => $composableBuilder(
    column: $table.mealId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BloodSugarTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BloodSugarTableTable> {
  $$BloodSugarTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readingType => $composableBuilder(
    column: $table.readingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealId => $composableBuilder(
    column: $table.mealId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BloodSugarTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BloodSugarTableTable> {
  $$BloodSugarTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get readingType => $composableBuilder(
    column: $table.readingType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealId =>
      $composableBuilder(column: $table.mealId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$BloodSugarTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BloodSugarTableTable,
          BloodSugarTableData,
          $$BloodSugarTableTableFilterComposer,
          $$BloodSugarTableTableOrderingComposer,
          $$BloodSugarTableTableAnnotationComposer,
          $$BloodSugarTableTableCreateCompanionBuilder,
          $$BloodSugarTableTableUpdateCompanionBuilder,
          (
            BloodSugarTableData,
            BaseReferences<
              _$AppDatabase,
              $BloodSugarTableTable,
              BloodSugarTableData
            >,
          ),
          BloodSugarTableData,
          PrefetchHooks Function()
        > {
  $$BloodSugarTableTableTableManager(
    _$AppDatabase db,
    $BloodSugarTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BloodSugarTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BloodSugarTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BloodSugarTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> readingType = const Value.absent(),
                Value<String?> mealId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BloodSugarTableCompanion(
                id: id,
                timestamp: timestamp,
                value: value,
                readingType: readingType,
                mealId: mealId,
                notes: notes,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime timestamp,
                required double value,
                required String readingType,
                Value<String?> mealId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BloodSugarTableCompanion.insert(
                id: id,
                timestamp: timestamp,
                value: value,
                readingType: readingType,
                mealId: mealId,
                notes: notes,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BloodSugarTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BloodSugarTableTable,
      BloodSugarTableData,
      $$BloodSugarTableTableFilterComposer,
      $$BloodSugarTableTableOrderingComposer,
      $$BloodSugarTableTableAnnotationComposer,
      $$BloodSugarTableTableCreateCompanionBuilder,
      $$BloodSugarTableTableUpdateCompanionBuilder,
      (
        BloodSugarTableData,
        BaseReferences<
          _$AppDatabase,
          $BloodSugarTableTable,
          BloodSugarTableData
        >,
      ),
      BloodSugarTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MealTableTableTableManager get mealTable =>
      $$MealTableTableTableManager(_db, _db.mealTable);
  $$InsulinTableTableTableManager get insulinTable =>
      $$InsulinTableTableTableManager(_db, _db.insulinTable);
  $$BloodSugarTableTableTableManager get bloodSugarTable =>
      $$BloodSugarTableTableTableManager(_db, _db.bloodSugarTable);
}
