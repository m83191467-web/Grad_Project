import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';
import '../../../../models/user_model.dart';
import '../../../../models/route_model.dart';
import '../../../../models/trip_model.dart';
import '../../../../models/driver_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createPassenger({
    required String name,
    required String phone,
    String? email,
  }) async {
    await remoteDataSource.createPassenger(
      name: name,
      phone: phone,
      email: email,
    );
  }

  @override
  Future<void> saveUserData({
    required String uid,
    required String name,
    required String phone,
    required String type,
  }) async {
    await remoteDataSource.saveUserData(
      uid: uid,
      name: name,
      phone: phone,
      type: type,
    );
  }

  Future<UserModel?> getUserProfile(String uid) async {
    return await remoteDataSource.getUserProfile(uid);
  }

  Future<List<RouteModel>> fetchAvailableRoutes() async {
    return await remoteDataSource.fetchAvailableRoutes();
  }

  Future<List<TripModel>> fetchUserTrips(String userId) async {
    return await remoteDataSource.fetchUserTrips(userId);
  }

  Future<DriverModel?> getDriverInfo(String driverId) async {
    return await remoteDataSource.getDriverInfo(driverId);
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await remoteDataSource.updateUserProfile(uid, data);
  }

  Future<void> bookTrip(String userId, String routeId) async {
    await remoteDataSource.bookTrip(userId, routeId);
  }

  Future<void> cancelTrip(String tripId) async {
    await remoteDataSource.cancelTrip(tripId);
  }

  Future<void> rateTrip(String tripId, double rating) async {
    await remoteDataSource.rateTrip(tripId, rating);
  }
}
