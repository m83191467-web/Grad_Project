import '../../../../models/trip_model.dart';

abstract class TripRepository {
  Future<TripModel> bookTrip({
    required String passengerId,
    required String routeId,
    required double fare,
  });
  Future<List<TripModel>> fetchPassengerTrips(String passengerId);
  Future<void> updateStatus(String tripId, String status);
  Future<void> rateTrip(String tripId, double rating);
}
