import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../models/user_model.dart';
import '../../../../models/route_model.dart';
import '../../../../models/trip_model.dart';
import '../../../../models/driver_model.dart';

abstract class UserRemoteDataSource {
  Future<void> createPassenger({
    required String name,
    required String phone,
    String? email,
  });
  Future<void> saveUserData({
    required String uid,
    required String name,
    required String phone,
    required String type,
  });
  Future<UserModel?> getUserProfile(String uid);
  Future<List<RouteModel>> fetchAvailableRoutes();
  Future<List<TripModel>> fetchUserTrips(String userId);
  Future<DriverModel?> getDriverInfo(String driverId);
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data);
  Future<void> bookTrip(String userId, String routeId);
  Future<void> cancelTrip(String tripId);
  Future<void> rateTrip(String tripId, double rating);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<void> createPassenger({
    required String name,
    required String phone,
    String? email,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('You must be signed in to create a passenger profile.');
    }
    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'phone': phone,
      'email': email ?? '',
      'type': 'passenger',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> saveUserData({
    required String uid,
    required String name,
    required String phone,
    required String type,
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'phone': phone,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() ?? {}, doc.id);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RouteModel>> fetchAvailableRoutes() async {
    try {
      // Read all routes and filter in Dart. This also supports older route
      // documents that were created before the `status` field was required.
      final snapshot = await _db
          .collection('routes')
          .get()
          .timeout(const Duration(seconds: 12));
      return snapshot.docs
          .where((doc) {
            final status = doc.data()['status'];
            return status == null || status == 'active';
          })
          .map((doc) => RouteModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TripModel>> fetchUserTrips(String userId) async {
    try {
      final snapshot = await _db
          .collection('trips')
          .where('passengerId', isEqualTo: userId)
          .orderBy('tripDate', descending: true)
          .get()
          .timeout(const Duration(seconds: 15));
      return snapshot.docs
          .map((doc) => TripModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DriverModel?> getDriverInfo(String driverId) async {
    try {
      final doc = await _db.collection('drivers').doc(driverId).get();
      if (doc.exists) {
        return DriverModel.fromMap(doc.data() ?? {}, doc.id);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).update(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> bookTrip(String userId, String routeId) async {
    final routeRef = _db.collection('routes').doc(routeId);

    await _db.runTransaction((transaction) async {
      final routeDoc = await transaction.get(routeRef);
      if (!routeDoc.exists) {
        throw StateError('Route not found');
      }

      final routeData = routeDoc.data() ?? <String, dynamic>{};
      final seats = (routeData['availableSeats'] as num?)?.toInt() ?? 0;
      if (seats <= 0) {
        throw StateError('No seats are available');
      }

      final tripRef = _db.collection('trips').doc();
      transaction.set(tripRef, {
        'passengerId': userId,
        'routeId': routeId,
        'driverId': routeData['driverId'],
        'tripDate': routeData['departureTime'],
        'fareAmount': routeData['fare'],
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      transaction.update(routeRef, {'availableSeats': seats - 1});
    });
  }

  @override
  Future<void> cancelTrip(String tripId) async {
    try {
      await _db.collection('trips').doc(tripId).update({'status': 'cancelled'});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> rateTrip(String tripId, double rating) async {
    try {
      await _db.collection('trips').doc(tripId).update({
        'rating': rating,
        'status': 'completed',
      });
    } catch (e) {
      rethrow;
    }
  }
}
