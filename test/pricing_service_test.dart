import 'package:flutter_test/flutter_test.dart';

import 'package:g_project/data/services/pricing_service.dart';

void main() {
  final pricing = PricingService();

  test('rounds a normal fare to the nearest five', () {
    final fare = pricing.calculateFare(
      distanceKm: 8,
      pickupTime: DateTime(2026, 8, 20, 13),
    );

    expect(fare, 40);
  });

  test('applies peak-hour pricing', () {
    final normalFare = pricing.calculateFare(
      distanceKm: 8,
      pickupTime: DateTime(2026, 8, 20, 13),
    );
    final peakFare = pricing.calculateFare(
      distanceKm: 8,
      pickupTime: DateTime(2026, 8, 20, 17),
    );

    expect(peakFare, greaterThan(normalFare));
  });

  test('rejects invalid coupons without changing the fare', () {
    expect(pricing.applyCoupon(fare: 100, discountPercent: 120), 100);
  });

  test('does not allow a negative coupon discount', () {
    expect(pricing.applyCoupon(fare: 100, discountPercent: -10), 100);
  });

  test('never returns a negative total fare', () {
    expect(
      pricing.calculateTotalFare(baseFare: 50, discount: 100),
      50,
    );
  });
}
