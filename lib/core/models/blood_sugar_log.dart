class BloodSugarLog {
  BloodSugarLog({
    required this.id,
    required this.timestamp,
    required this.value,
    required this.readingType,
    this.mealId,
    this.notes,
    this.timePeriod,
    this.isSynced = false,
  });

  final String id;
  final DateTime timestamp;
  final double value;
  final String readingType;
  final String? mealId;
  final String? notes;
  final String? timePeriod;
  final bool isSynced;
}
