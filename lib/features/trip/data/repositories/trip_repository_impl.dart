import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/trip_model.dart';
import '../../domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final FirebaseFirestore _firestore;

  TripRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<TripModel> bookTrip({
    required String passengerId,
    required String routeId,
    required double fare,
  }) async {
    final routeRef = _firestore.collection('routes').doc(routeId);
    late TripModel bookedTrip;

    await _firestore.runTransaction((transaction) async {
      final routeDoc = await transaction.get(routeRef);
      if (!routeDoc.exists) throw StateError('Route not found');

      final route = routeDoc.data() ?? <String, dynamic>{};
      final seats = (route['availableSeats'] as num?)?.toInt() ?? 0;
      if (seats <= 0) throw StateError('No seats are available');

      final reference = _firestore.collection('trips').doc();
      final now = DateTime.now();
      final departure = route['departureTime'] is Timestamp
          ? (route['departureTime'] as Timestamp).toDate()
          : now;
      final routeFare = (route['fare'] as num?)?.toDouble() ?? fare;
      bookedTrip = TripModel(
        id: reference.id,
        passengerId: passengerId,
        routeId: routeId,
        driverId: route['driverId']?.toString() ?? '',
        tripDate: departure,
        fareAmount: routeFare,
        status: 'pending',
        createdAt: now,
        paymentMethod: 'cash',
      );
      transaction.set(reference, {
        ...bookedTrip.toMap(),
        'tripDate': Timestamp.fromDate(departure),
        'createdAt': FieldValue.serverTimestamp(),
      });
      transaction.update(routeRef, {'availableSeats': seats - 1});
    });

    return bookedTrip;
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
    } catch (error) {
      throw StateError('Could not load trip history: $error');
    }
  }

  @override
  Future<void> updateStatus(String tripId, String status) async {
    try {
      await _firestore.collection('trips').doc(tripId).update({
        'status': status,
      });
    } catch (error) {
      throw StateError('Could not update trip status: $error');
    }
  }

  @override
  Future<void> rateTrip(String tripId, double rating) async {
    try {
      await _firestore.collection('trips').doc(tripId).update({
        'rating': rating,
      });
    } catch (error) {
      throw StateError('Could not rate trip: $error');
    }
  }
}
