class InsulinLog {
  InsulinLog({
    required this.id,
    required this.timestamp,
    required this.doseUnits,
    this.notes,
    this.timePeriod,
    this.isSynced = false,
  });

  final String id;
  final DateTime timestamp;
  final double doseUnits;
  final String? notes;
  final String? timePeriod;
  final bool isSynced;
}
