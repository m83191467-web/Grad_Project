import 'package:flutter_test/flutter_test.dart';

import 'package:g_project/models/trip_model.dart';

void main() {
  test('accepts numeric Firestore ids and amounts', () {
    final trip = TripModel.fromMap({
      'passengerId': 42,
      'routeId': 7,
      'driverId': 12,
      'fareAmount': 35,
      'rating': 4,
      'status': 1,
      'createdAt': 1,
      'tripDate': 1,
    }, 'trip-1');

    expect(trip.passengerId, '42');
    expect(trip.routeId, '7');
    expect(trip.driverId, '12');
    expect(trip.fareAmount, 35);
    expect(trip.rating, 4);
    expect(trip.status, '1');
  });
}
