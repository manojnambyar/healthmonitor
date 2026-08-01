import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/models/blood_sugar_log.dart';
import '../../core/models/insulin_log.dart';
import '../../core/models/meal_log.dart';
import '../../core/services/app_database.dart';
import '../../core/services/drift_storage_service.dart';
import '../../core/services/timing_logic_service.dart';

class LoggingView extends StatefulWidget {
  const LoggingView({super.key});

  @override
  State<LoggingView> createState() => _LoggingViewState();
}

class _LoggingViewState extends State<LoggingView> {
  late final DriftStorageService _storage;
  final TimingLogicService _timing = TimingLogicService();
  final Uuid _uuid = const Uuid();

  DateTime _selectedTime = DateTime.now();
  String _mealType = 'Breakfast';
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _insulinDoseController = TextEditingController();
  final TextEditingController _insulinNotesController = TextEditingController();
  final TextEditingController _glucoseController = TextEditingController();
  final TextEditingController _glucoseNotesController = TextEditingController();
  Future<List<MealLog>>? _mealsFuture;
  String _insulinType = 'Rapid-acting';
  String? _glucoseType;
  String? _insulinPeriod;
  String? _mealPeriod;
  String? _glucosePeriod;
  String? _selectedMealId;
  bool _isUnitsMmoll = false;
  bool _showTimingMessage = false;
  String _timingMessage = '';

  @override
  void initState() {
    super.initState();
    _storage = DriftStorageService(AppDatabase());
    _mealsFuture = _storage.getMeals();
  }

  @override
  void dispose() {
    _foodController.dispose();
    _carbsController.dispose();
    _insulinDoseController.dispose();
    _insulinNotesController.dispose();
    _glucoseController.dispose();
    _glucoseNotesController.dispose();
    super.dispose();
  }

  Future<void> _saveMeal() async {
    if (_foodController.text.trim().isEmpty) {
      _showSnack('Please describe the meal.');
      return;
    }
    if (_mealPeriod == null) {
      _showSnack('Please choose a time period.');
      return;
    }
    final meal = MealLog(
      id: _uuid.v4(),
      timestamp: _selectedTime,
      mealType: _mealType,
      foodDescription: _foodController.text.trim(),
      estimatedCarbs: double.tryParse(_carbsController.text),
      timePeriod: _mealPeriod,
    );
    await _storage.addMeal(meal);
    _foodController.clear();
    _carbsController.clear();
    await _refreshMeals();
    _showSnack('Meal logged locally.', success: true);
  }

  Future<void> _saveInsulin() async {
    final dose = double.tryParse(_insulinDoseController.text);
    if (dose == null || dose <= 0) {
      _showSnack('Please enter an insulin dose greater than zero.');
      return;
    }
    if (_insulinPeriod == null) {
      _showSnack('Please choose a time period.');
      return;
    }
    final insulin = InsulinLog(
      id: _uuid.v4(),
      timestamp: _selectedTime,
      insulinType: _insulinType,
      doseUnits: dose,
      notes: _insulinNotesController.text.trim().isEmpty
          ? null
          : _insulinNotesController.text.trim(),
      timePeriod: _insulinPeriod,
    );
    await _storage.addInsulin(insulin);
    _insulinDoseController.clear();
    _insulinNotesController.clear();
    final recommendation = _timing.recommendInsulinTiming(insulinTime: insulin.timestamp);
    setState(() {
      _showTimingMessage = true;
      _timingMessage = '${recommendation.message}\nNext check: ${recommendation.suggestedTime!.toLocal().toString()}';
    });
    _showSnack('Insulin logged locally.', success: true);
  }

  Future<void> _saveBloodSugar() async {
    final readingValue = double.tryParse(_glucoseController.text);
    if (readingValue == null) {
      _showSnack('Please enter a valid glucose value.');
      return;
    }
    if (_glucoseType == null) {
      _showSnack('Please choose whether this is a pre-meal or post-meal reading.');
      return;
    }
    if (_glucosePeriod == null) {
      _showSnack('Please choose a time period.');
      return;
    }
    final meals = await _storage.getMeals();
    final meal = _selectedMealId == null
        ? null
        : meals.where((entry) => entry.id == _selectedMealId).isNotEmpty
            ? meals.firstWhere((entry) => entry.id == _selectedMealId)
            : null;
    final recommendation = _glucoseType == 'Post-Meal' && meal != null
        ? _timing.evaluatePostMealReading(
            readingTime: _selectedTime,
            mealTime: meal.timestamp,
          )
        : null;
    final log = BloodSugarLog(
      id: _uuid.v4(),
      timestamp: _selectedTime,
      value: readingValue,
      readingType: _glucoseType!,
      mealId: _selectedMealId,
      notes: recommendation?.isEarly == true
          ? [
              if (_glucoseNotesController.text.trim().isNotEmpty) _glucoseNotesController.text.trim(),
              recommendation!.tag!,
            ].join(' · ')
          : _glucoseNotesController.text.trim(),
      timePeriod: _glucosePeriod,
    );
    await _storage.addBloodSugar(log);
    _glucoseController.clear();
    _glucoseNotesController.clear();
    setState(() {
      _selectedMealId = null;
      _glucoseType = null;
    });
    if (recommendation?.isEarly == true) {
      _showSnack('${recommendation!.message}\nSuggested time: ${recommendation.suggestedTime!.toLocal()}', success: true);
    } else {
      _showSnack('Glucose logged locally.', success: true);
    }
  }

  Future<void> _refreshMeals() async {
    if (!mounted) return;
    setState(() {
      _mealsFuture = _storage.getMeals();
    });
  }

  void _showSnack(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
    ));
  }

  int _selectedLogTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log your data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabRow(),
            const SizedBox(height: 16),
            _buildSelectedLogContent(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTabRow() {
    final tabLabels = ['Insulin Log', 'Meal Log', 'Sugar Log'];
    final tabColors = [Colors.deepPurple, Colors.orange, Colors.green];

    return Row(
      children: List.generate(tabLabels.length, (index) {
        final isSelected = _selectedLogTab == index;
        final icon = index == 0
            ? Icons.medical_services
            : index == 1
                ? Icons.set_meal
                : Icons.bloodtype;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? tabColors[index] : Colors.grey.shade200,
                foregroundColor: isSelected ? Colors.white : Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: isSelected ? 4 : 0,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              ),
              onPressed: () => setState(() => _selectedLogTab = index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(height: 6),
                  Text(tabLabels[index], textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSelectedLogContent() {
    switch (_selectedLogTab) {
      case 0:
        return _insulinLogCard();
      case 1:
        return _mealLogCard();
      case 2:
      default:
        return _sugarLogCard();
    }
  }

  Widget _insulinLogCard() {
    return _sectionCard(
      title: 'Insulin Log',
      accentColor: Colors.deepPurple.shade700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _timestampRow(),
          const SizedBox(height: 16),
          _timePeriodDropdown(value: _insulinPeriod, onChanged: (value) => setState(() => _insulinPeriod = value)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _insulinType,
            items: ['Rapid-acting', 'Short-acting', 'Long-acting']
                .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (value) => setState(() => _insulinType = value ?? _insulinType),
            decoration: const InputDecoration(labelText: 'Insulin type'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _insulinDoseController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Dose units (IU)'),
          ),
          const SizedBox(height: 16),
          TextField(controller: _insulinNotesController, decoration: const InputDecoration(labelText: 'Notes')),
          if (_showTimingMessage) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(14)),
              child: Text(_timingMessage, style: TextStyle(color: Colors.deepPurple.shade900)),
            ),
          ],
          const SizedBox(height: 16),
          _saveButton(
            onPressed: _saveInsulin,
            icon: Icons.medication,
            label: 'Save insulin',
            color: Colors.deepPurple.shade700,
          ),
        ],
      ),
    );
  }

  Widget _mealLogCard() {
    return _sectionCard(
      title: 'Meal Log',
      accentColor: Colors.orange.shade700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _timestampRow(),
          const SizedBox(height: 16),
          _timePeriodDropdown(value: _mealPeriod, onChanged: (value) => setState(() => _mealPeriod = value)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _mealType,
            items: ['Breakfast', 'Lunch', 'Dinner', 'Snack']
                .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (value) => setState(() => _mealType = value ?? _mealType),
            decoration: const InputDecoration(labelText: 'Meal type'),
          ),
          const SizedBox(height: 16),
          TextField(controller: _foodController, decoration: const InputDecoration(labelText: 'Food description')),
          const SizedBox(height: 16),
          TextField(
            controller: _carbsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Estimated carbs (g)'),
          ),
          const SizedBox(height: 16),
          _saveButton(
            onPressed: _saveMeal,
            icon: Icons.restaurant,
            label: 'Save meal',
            color: Colors.orange.shade700,
          ),
        ],
      ),
    );
  }

  Widget _sugarLogCard() {
    return _sectionCard(
      title: 'Sugar Log',
      accentColor: Colors.green.shade700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _timestampRow(),
          const SizedBox(height: 16),
          _timePeriodDropdown(value: _glucosePeriod, onChanged: (value) => setState(() => _glucosePeriod = value)),
          const SizedBox(height: 16),
          _buildReadingTypeToggle(),
          const SizedBox(height: 16),
          TextField(
            controller: _glucoseController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Reading value'),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<MealLog>>(
            future: _mealsFuture,
            builder: (context, snapshot) {
              final meals = snapshot.data ?? const <MealLog>[];
              return DropdownButtonFormField<String>(
                initialValue: _selectedMealId,
                items: meals
                    .map((meal) => DropdownMenuItem(
                          value: meal.id,
                          child: Text('${meal.mealType}: ${meal.foodDescription}'),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedMealId = value),
                decoration: const InputDecoration(labelText: 'Associated meal'),
              );
            },
          ),
          const SizedBox(height: 16),
          TextField(controller: _glucoseNotesController, decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
            value: _isUnitsMmoll,
            title: const Text('Show mmol/L'),
            onChanged: (value) => setState(() => _isUnitsMmoll = value),
          ),
          const SizedBox(height: 16),
          _saveButton(
            onPressed: _saveBloodSugar,
            icon: Icons.monitor_heart,
            label: 'Save glucose',
            color: Colors.green.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildReadingTypeToggle() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: _glucoseType == 'Pre-Meal' ? Colors.blue.shade600 : Colors.grey.shade100,
              foregroundColor: _glucoseType == 'Pre-Meal' ? Colors.white : Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              side: BorderSide(color: Colors.blue.shade300),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => setState(() => _glucoseType = 'Pre-Meal'),
            child: const Text('Pre meal'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: _glucoseType == 'Post-Meal' ? Colors.blue.shade600 : Colors.grey.shade100,
              foregroundColor: _glucoseType == 'Post-Meal' ? Colors.white : Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              side: BorderSide(color: Colors.blue.shade300),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => setState(() => _glucoseType = 'Post-Meal'),
            child: const Text('Post meal'),
          ),
        ),
      ],
    );
  }

  Widget _timePeriodDropdown({required String? value, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: const ['Morning', 'Afternoon', 'Evening', 'Night']
          .map((period) => DropdownMenuItem(value: period, child: Text(period)))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(labelText: 'Time period'),
      hint: const Text('Choose a time period'),
    );
  }

  Widget _timestampRow() {
    return InkWell(
      onTap: () async {
        if (!mounted) return;
        final localContext = context;
        final date = await showDatePicker(
          context: localContext,
          initialDate: _selectedTime,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (!mounted || date == null) return;
        final time = await showTimePicker(
          context: localContext,
          initialTime: TimeOfDay.fromDateTime(_selectedTime),
        );
        if (!mounted || time == null) return;
        setState(() {
          _selectedTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
            _selectedTime.second,
          );
        });
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Timestamp',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          suffixIcon: const Icon(Icons.calendar_month),
        ),
        child: Text(_formattedTimestamp()),
      ),
    );
  }

  String _formattedTimestamp() {
    final month = _monthAbbreviation(_selectedTime.month);
    final day = _selectedTime.day.toString().padLeft(2, '0');
    final year = _selectedTime.year;
    final hour = _selectedTime.hour.toString().padLeft(2, '0');
    final minute = _selectedTime.minute.toString().padLeft(2, '0');
    final second = _selectedTime.second.toString().padLeft(2, '0');
    return '$day-$month $year $hour:$minute:$second';
  }

  Widget _saveButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  String _monthAbbreviation(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _sectionCard({required String title, required Widget child, required Color accentColor}) {
    final titleColor = ThemeData.estimateBrightnessForColor(accentColor) == Brightness.dark ? Colors.white : Colors.black87;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: titleColor)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}
