import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';

import '../../core/models/blood_sugar_log.dart';
import '../../core/models/insulin_log.dart';
import '../../core/models/meal_log.dart';
import '../../core/services/app_database.dart';
import '../../core/services/drift_storage_service.dart';
import 'timeline_export_service.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  static const _rollingDays = 20;
  late final DriftStorageService _storage;

  @override
  void initState() {
    super.initState();
    _storage = DriftStorageService(AppDatabase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GlucoseSync Dashboard')),
      body: FutureBuilder<_DashboardData>(
        future: _loadDashboardData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          final current = _summaryFor(data.bloodSugars, DateTime.now(), _rollingDays);
          final previous = _summaryFor(data.bloodSugars, DateTime.now().subtract(const Duration(days: 1)), _rollingDays);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _metricCard(current, previous),
              const SizedBox(height: 16),
              _trendSummaryCard(data.bloodSugars),
              const SizedBox(height: 16),
              _timelineCard(data.meals, data.insulins, data.bloodSugars),
            ],
          );
        },
      ),
    );
  }

  Future<_DashboardData> _loadDashboardData() async => _DashboardData(
        meals: await _storage.getMeals(),
        insulins: await _storage.getInsulins(),
        bloodSugars: await _storage.getBloodSugars(),
      );

  _GlucoseSummary _summaryFor(List<BloodSugarLog> readings, DateTime end, int days) {
    final start = DateTime(end.year, end.month, end.day).subtract(Duration(days: days - 1));
    final finish = DateTime(end.year, end.month, end.day + 1);
    final inRange = readings.where((item) => !item.timestamp.isBefore(start) && item.timestamp.isBefore(finish)).toList();
    return _GlucoseSummary(
      pre: _average(inRange.where((item) => item.readingType == 'Pre-Meal').map((item) => item.value).toList()),
      post: _average(inRange.where((item) => item.readingType == 'Post-Meal').map((item) => item.value).toList()),
      preVariability: _standardDeviation(inRange.where((item) => item.readingType == 'Pre-Meal').map((item) => item.value).toList()),
      postVariability: _standardDeviation(inRange.where((item) => item.readingType == 'Post-Meal').map((item) => item.value).toList()),
    );
  }

  double? _average(List<double> values) => values.isEmpty ? null : values.reduce((a, b) => a + b) / values.length;

  double? _standardDeviation(List<double> values) {
    final mean = _average(values);
    if (mean == null) return null;
    final variance = values.map((value) => math.pow(value - mean, 2)).reduce((a, b) => a + b) / values.length;
    return math.sqrt(variance);
  }

  Widget _metricCard(_GlucoseSummary current, _GlucoseSummary previous) {
    return _card(
      title: 'Last 20 days',
      accentColor: Colors.teal.shade700,
      child: Column(children: [
        _metricRow('Pre-meal average', current.pre, previous.pre, target: 70, suffix: 'mg/dL'),
        _metricRow('Post-meal average', current.post, previous.post, target: 130, suffix: 'mg/dL'),
        const Divider(height: 28),
        _metricRow('Pre-meal variability', current.preVariability, previous.preVariability, suffix: 'SD'),
        _metricRow('Post-meal variability', current.postVariability, previous.postVariability, suffix: 'SD'),
        const SizedBox(height: 8),
        const Text('Compared with the 20-day window ending yesterday.', style: TextStyle(color: Colors.black54, fontSize: 12)),
      ]),
    );
  }

  Widget _metricRow(String label, double? value, double? previous, {double? target, required String suffix}) {
    final change = _trend(value, previous, target: target);
    final text = value == null ? '—' : '${value.toStringAsFixed(2)} $suffix';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(width: 10),
        Icon(change.icon, size: 20, color: change.color),
      ]),
    );
  }

  _TrendIndicator _trend(double? value, double? previous, {double? target}) {
    if (value == null || previous == null) return const _TrendIndicator(Icons.remove, Colors.grey);
    final currentMeasure = target == null ? value : (value - target).abs();
    final previousMeasure = target == null ? previous : (previous - target).abs();
    const tolerance = 0.05;
    if ((currentMeasure - previousMeasure).abs() < tolerance) return const _TrendIndicator(Icons.remove, Colors.grey);
    final improved = currentMeasure < previousMeasure;
    return _TrendIndicator(improved ? Icons.arrow_downward : Icons.arrow_upward, improved ? Colors.green.shade700 : Colors.red.shade700);
  }

  Widget _trendSummaryCard(List<BloodSugarLog> readings) {
    final periods = [7, 14, 30];
    return _card(
      title: 'Trend summaries',
      accentColor: Colors.orange.shade700,
      child: Table(
        columnWidths: const {0: FlexColumnWidth(1.4), 1: FlexColumnWidth(), 2: FlexColumnWidth()},
        children: [
          const TableRow(children: [
            Padding(padding: EdgeInsets.all(6), child: Text('Period', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(6), child: Text('Pre-meal avg', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(6), child: Text('Post-meal avg', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
          ]),
          ...periods.map((days) => _summaryTableRow('$days days', _summaryFor(readings, DateTime.now(), days))),
          _summaryTableRow('All', _allSummary(readings)),
        ],
      ),
    );
  }

  _GlucoseSummary _allSummary(List<BloodSugarLog> readings) => _GlucoseSummary(
        pre: _average(readings.where((item) => item.readingType == 'Pre-Meal').map((item) => item.value).toList()),
        post: _average(readings.where((item) => item.readingType == 'Post-Meal').map((item) => item.value).toList()),
        preVariability: null,
        postVariability: null,
      );

  TableRow _summaryTableRow(String label, _GlucoseSummary summary) => TableRow(children: [
        Padding(padding: const EdgeInsets.all(6), child: Text(label)),
        Padding(padding: const EdgeInsets.all(6), child: Text(_number(summary.pre), textAlign: TextAlign.right)),
        Padding(padding: const EdgeInsets.all(6), child: Text(_number(summary.post), textAlign: TextAlign.right)),
      ]);

  Widget _timelineCard(List<MealLog> meals, List<InsulinLog> insulins, List<BloodSugarLog> bloodSugars) {
    final rows = _timelineRows(meals, insulins, bloodSugars);
    final exportContent = TimelineExportService().buildPlainTextContent(meals: meals, insulins: insulins, bloodSugars: bloodSugars);

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          color: Colors.green.shade700,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
          child: Row(children: [
            const Expanded(child: Text('Timeline feed', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold))),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) async {
                if (value == 'pdf') {
                  await _exportTimelinePdf(exportContent);
                } else if (value == 'whatsapp') {
                  await _shareTimelineToWhatsApp(exportContent);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'pdf', child: Text('Export to PDF')),
                PopupMenuItem(value: 'whatsapp', child: Text('Send via WhatsApp')),
              ],
            ),
          ]),
        ),
        Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          _timelineHeader(),
          const Divider(height: 18),
          if (rows.isEmpty) const Padding(padding: EdgeInsets.all(8), child: Text('No entries yet.')) else ...rows,
        ])),
      ]),
    );
  }

  Widget _timelineHeader() => const Row(children: [
        Expanded(flex: 4, child: Text('Time range & meal', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text('Insulin', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text('Pre', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text('Post', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
      ]);

  List<Widget> _timelineRows(List<MealLog> meals, List<InsulinLog> insulins, List<BloodSugarLog> bloodSugars) {
    final groupsByPeriod = <String, _TimelineGroup>{};
    _TimelineGroup groupFor(DateTime timestamp, String? selectedPeriod) {
      final period = selectedPeriod ?? _period(timestamp);
      final key = '${timestamp.year}-${timestamp.month}-${timestamp.day}-$period';
      return groupsByPeriod.putIfAbsent(key, () => _TimelineGroup(timePeriod: period));
    }
    for (final meal in meals) {
      groupFor(meal.timestamp, meal.timePeriod).meals.add(meal);
    }
    for (final reading in bloodSugars) {
      groupFor(reading.timestamp, reading.timePeriod).bloodSugars.add(reading);
    }
    for (final insulin in insulins) {
      groupFor(insulin.timestamp, insulin.timePeriod).insulins.add(insulin);
    }
    final groups = groupsByPeriod.values.toList()..sort((a, b) => b.latestTime.compareTo(a.latestTime));
    for (final group in groups) {
      group.meals.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      group.insulins.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      group.bloodSugars.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    final List<Widget> items = [];
    DateTime? lastDate;

    for (final group in groups) {
      final currentDate = DateTime(group.latestTime.year, group.latestTime.month, group.latestTime.day);
      if (lastDate == null || currentDate != lastDate) {
        if (lastDate != null) items.add(const Divider(height: 24, thickness: 0.5));
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _formatDay(currentDate),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green.shade800),
            ),
          ),
        );
        lastDate = currentDate;
      }

      final insulin = group.insulins.isEmpty ? '—' : group.insulins.first.doseUnits.toStringAsFixed(0);
      final pre = group.bloodSugars.where((item) => item.readingType == 'Pre-Meal').map((item) => item.value.toStringAsFixed(0)).join(', ');
      final post = group.bloodSugars.where((item) => item.readingType == 'Post-Meal').map((item) => item.value.toStringAsFixed(0)).join(', ');
      final detail = group.meals.isEmpty ? 'No meal recorded' : group.meals.map((meal) => '${meal.mealType}: ${meal.foodDescription}').join(' · ');
      
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 4, child: Text('${_formatShortRange(group.earliestTime, group.latestTime)} · ${group.timePeriod}\n$detail')),
            Expanded(child: Text(insulin, textAlign: TextAlign.center)),
            Expanded(child: Text(pre.isEmpty ? '—' : pre, textAlign: TextAlign.center)),
            Expanded(child: Text(post.isEmpty ? '—' : post, textAlign: TextAlign.center)),
          ]),
        ),
      );
    }
    return items;
  }

  Future<void> _exportTimelinePdf(String content) async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Text(content, style: const pw.TextStyle(fontSize: 10)),
          ),
        ),
      );

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/timeline_feed_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF saved to ${file.path}')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to export PDF: $error')));
    }
  }

  Future<void> _shareTimelineToWhatsApp(String content) async {
    final encodedText = Uri.encodeComponent(content);
    final uri = Uri.parse('https://wa.me/?text=$encodedText');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to open WhatsApp.')));
    }
  }

  Widget _card({required String title, required Color accentColor, required Widget child}) => Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(color: accentColor, padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18), child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold))),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ]),
      );

  String _number(double? value) => value == null ? '—' : value.toStringAsFixed(2);
  String _formatDate(DateTime time) => '${time.day.toString().padLeft(2, '0')} ${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][time.month - 1]} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  String _formatDay(DateTime time) => '${time.day.toString().padLeft(2, '0')} ${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][time.month - 1]} ${time.year}';
  String _formatTimeOnly(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  String _formatRange(DateTime start, DateTime end) => start.year == end.year && start.month == end.month && start.day == end.day
      ? '${_formatDate(start)}–${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}'
      : '${_formatDate(start)}–${_formatDate(end)}';
  String _formatShortRange(DateTime start, DateTime end) => start.year == end.year && start.month == end.month && start.day == end.day
      ? '${_formatTimeOnly(start)}–${_formatTimeOnly(end)}'
      : '${_formatDate(start)}–${_formatDate(end)}';
  String _period(DateTime time) => time.hour < 12 ? 'morning' : time.hour < 18 ? 'afternoon' : 'night';
}

class _DashboardData {
  const _DashboardData({required this.meals, required this.insulins, required this.bloodSugars});
  final List<MealLog> meals;
  final List<InsulinLog> insulins;
  final List<BloodSugarLog> bloodSugars;
}

class _GlucoseSummary {
  const _GlucoseSummary({required this.pre, required this.post, required this.preVariability, required this.postVariability});
  final double? pre;
  final double? post;
  final double? preVariability;
  final double? postVariability;
}

class _TrendIndicator {
  const _TrendIndicator(this.icon, this.color);
  final IconData icon;
  final Color color;
}

class _TimelineGroup {
  _TimelineGroup({required this.timePeriod});

  final String timePeriod;
  final List<MealLog> meals = [];
  final List<InsulinLog> insulins = [];
  final List<BloodSugarLog> bloodSugars = [];

  Iterable<DateTime> get _times => [
        ...meals.map((item) => item.timestamp),
        ...insulins.map((item) => item.timestamp),
        ...bloodSugars.map((item) => item.timestamp),
      ];
  DateTime get earliestTime => _times.reduce((a, b) => a.isBefore(b) ? a : b);
  DateTime get latestTime => _times.reduce((a, b) => a.isAfter(b) ? a : b);
}
