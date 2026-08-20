import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/trip_model.dart';
import '../../domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final FirebaseFirestore _firestore;
  final List<TripModel> _localTrips = [];

  TripRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<TripModel> bookTrip({
    required String passengerId,
    required String routeId,
    required double fare,
  }) async {
    final now = DateTime.now();
    final reference = _firestore.collection('trips').doc();
    final trip = TripModel(
      id: reference.id,
      passengerId: passengerId,
      routeId: routeId,
      driverId: '',
      tripDate: now,
      fareAmount: fare,
      status: 'pending',
      createdAt: now,
      paymentMethod: 'cash',
    );
    try {
      await reference.set({
        ...trip.toMap(),
        'tripDate': Timestamp.fromDate(now),
        'createdAt': Timestamp.fromDate(now),
      });
    } catch (_) {
      _localTrips.insert(0, trip);
    }
    return trip;
  }

  @override
  Future<List<TripModel>> fetchPassengerTrips(String passengerId) async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .where('passengerId', isEqualTo: passengerId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => TripModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (_) {
      return _localTrips
          .where((trip) => trip.passengerId == passengerId)
          .toList();
    }
  }

  @override
  Future<void> updateStatus(String tripId, String status) async {
    try {
      await _firestore.collection('trips').doc(tripId).update({
        'status': status,
      });
    } catch (_) {
      final index = _localTrips.indexWhere((trip) => trip.id == tripId);
      if (index >= 0) {
        final current = _localTrips[index];
        _localTrips[index] = TripModel(
          id: current.id,
          passengerId: current.passengerId,
          routeId: current.routeId,
          driverId: current.driverId,
          tripDate: current.tripDate,
          fareAmount: current.fareAmount,
          status: status,
          createdAt: current.createdAt,
          paymentMethod: current.paymentMethod,
          rating: current.rating,
        );
      }
    }
  }

  @override
  Future<void> rateTrip(String tripId, double rating) async {
    try {
      await _firestore.collection('trips').doc(tripId).update({
        'rating': rating,
      });
    } catch (_) {}
  }
}
