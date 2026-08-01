import 'package:flutter_test/flutter_test.dart';
import 'package:healthmonitor/core/services/timing_logic_service.dart';

void main() {
  test('flags early post-meal readings correctly', () {
    final service = TimingLogicService();
    final recommendation = service.evaluatePostMealReading(
      readingTime: DateTime(2024, 1, 1, 9, 30),
      mealTime: DateTime(2024, 1, 1, 8, 0),
    );

    expect(recommendation.isEarly, isTrue);
    expect(recommendation.tag, 'Early Reading (<2h)');
  });

  test('recommends insulin timing guidance', () {
    final service = TimingLogicService();
    final recommendation = service.recommendInsulinTiming(insulinTime: DateTime(2024, 1, 1, 8, 0));

    expect(recommendation.isEarly, isFalse);
    expect(recommendation.message, contains('15-20 minutes'));
  });
}
