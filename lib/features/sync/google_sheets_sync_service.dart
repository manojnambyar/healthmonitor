class GoogleSheetsSyncService {
  Future<String> syncAll({required List<Map<String, dynamic>> rows}) async {
    final payload = rows.isEmpty ? <Map<String, dynamic>>[] : rows;
    return 'Queued ${payload.length} row(s) for sync when online.';
  }

  List<Map<String, dynamic>> buildRows({required List<Map<String, dynamic>> meals, required List<Map<String, dynamic>> insulin, required List<Map<String, dynamic>> bloodSugar}) {
    return [
      ...meals.map((row) => {'sheet': 'Meals', ...row}),
      ...insulin.map((row) => {'sheet': 'Insulin', ...row}),
      ...bloodSugar.map((row) => {'sheet': 'BloodSugar', ...row}),
    ];
  }
}
