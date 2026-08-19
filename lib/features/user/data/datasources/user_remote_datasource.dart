import 'package:cloud_firestore/cloud_firestore.dart';
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
    await _db.collection('users').add({
      'name': name,
      'phone': phone,
      'email': email ?? '',
      'type': 'passenger',
      'createdAt': DateTime.now(),
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
      final snapshot = await _db
          .collection('routes')
          .where('status', isEqualTo: 'active')
          .get();
      return snapshot.docs
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
          .get();
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
    try {
      final routeDoc = await _db.collection('routes').doc(routeId).get();
      if (routeDoc.exists) {
        final routeData = routeDoc.data() ?? {};
        await _db.collection('trips').add({
          'passengerId': userId,
          'routeId': routeId,
          'driverId': routeData['driverId'],
          'tripDate': routeData['departureTime'],
          'fareAmount': routeData['fare'],
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });
        // Decrement available seats
        await _db.collection('routes').doc(routeId).update({
          'availableSeats': FieldValue.increment(-1),
        });
      }
    } catch (e) {
      rethrow;
    }
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
