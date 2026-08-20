import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:g_project/models/route_model.dart';

void main() {
  test('normalizes mixed Firestore route values', () {
    final route = RouteModel.fromMap({
      'startPoint': 10,
      'destination': 'Downtown',
      'distance': '12.5',
      'duration': 35.8,
      'fare': 40,
      'availableSeats': '18',
      'driverId': 7,
      'departureTime': Timestamp.fromDate(DateTime(2026, 8, 21, 9)),
      'status': 1,
      'location': {'latitude': 15.5, 'longitude': 32.5},
    }, 'route-1');

    expect(route.startLocation, '10');
    expect(route.endLocation, 'Downtown');
    expect(route.distance, 12.5);
    expect(route.duration, 35);
    expect(route.fare, 40);
    expect(route.availableSeats, 18);
    expect(route.driverId, '7');
    expect(route.status, '1');
    expect(route.location, const GeoPoint(15.5, 32.5));
  });

  test('uses safe defaults for missing route values', () {
    final route = RouteModel.fromMap({}, 'route-empty');

    expect(route.startLocation, isEmpty);
    expect(route.endLocation, isEmpty);
    expect(route.distance, 0);
    expect(route.duration, 0);
    expect(route.fare, 0);
    expect(route.availableSeats, 0);
    expect(route.status, 'active');
    expect(route.location, isNull);
  });
}
