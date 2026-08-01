class TimingLogicService {
  static const Duration standardPostMealInterval = Duration(hours: 2);
  static const Duration insulinMealLag = Duration(minutes: 15);
  static const Duration insulinMealMaxLag = Duration(minutes: 20);

  TimingRecommendation evaluatePostMealReading({
    required DateTime readingTime,
    required DateTime mealTime,
  }) {
    final difference = readingTime.difference(mealTime);
    final isEarly = difference < standardPostMealInterval;

    if (!isEarly) {
      return TimingRecommendation(
        isEarly: false,
        message: 'Post-meal reading is within the recommended window.',
        suggestedTime: null,
        tag: null,
      );
    }

    final suggestedTime = mealTime.add(standardPostMealInterval);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    return TimingRecommendation(
      isEarly: true,
      message:
          'Your reading at $hours h ${minutes.toString().padLeft(2, '0')} m is earlier than the standard 2-hour window and may reflect peak absorption.',
      suggestedTime: suggestedTime,
      tag: 'Early Reading (<2h)',
    );
  }

  TimingRecommendation recommendInsulinTiming({required DateTime insulinTime}) {
    final mealStart = insulinTime.add(insulinMealLag);
    final nextCheck = mealStart.add(standardPostMealInterval);
    return TimingRecommendation(
      isEarly: false,
      message:
          'Consider starting the meal 15-20 minutes after the insulin dose for better alignment.',
      suggestedTime: nextCheck,
      tag: 'Insulin Timing',
    );
  }
}

class TimingRecommendation {
  TimingRecommendation({
    required this.isEarly,
    required this.message,
    required this.suggestedTime,
    required this.tag,
  });

  final bool isEarly;
  final String message;
  final DateTime? suggestedTime;
  final String? tag;
}
