import 'package:equatable/equatable.dart';

abstract class TripState extends Equatable {
  const TripState();

  @override
  List<Object?> get props => [];
}

class TripInitial extends TripState {
  const TripInitial();
}

class TripLoading extends TripState {
  const TripLoading();
}

class FareCalculated extends TripState {
  final double estimatedFare;
  final double distanceKm;

  const FareCalculated({required this.estimatedFare, required this.distanceKm});

  @override
  List<Object?> get props => [estimatedFare, distanceKm];
}

class TripActive extends TripState {
  final String tripId;
  final DateTime startTime;
  final double currentLatitude;
  final double currentLongitude;
  final double distanceTraveled;

  const TripActive({
    required this.tripId,
    required this.startTime,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.distanceTraveled,
  });

  @override
  List<Object?> get props => [
    tripId,
    startTime,
    currentLatitude,
    currentLongitude,
    distanceTraveled,
  ];
}

class LocationUpdated extends TripState {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const LocationUpdated({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [latitude, longitude, timestamp];
}

class TripEnded extends TripState {
  final String tripId;
  final DateTime endTime;
  final double finalFare;
  final double totalDistance;
  final int durationMinutes;

  const TripEnded({
    required this.tripId,
    required this.endTime,
    required this.finalFare,
    required this.totalDistance,
    required this.durationMinutes,
  });

  @override
  List<Object?> get props => [
    tripId,
    endTime,
    finalFare,
    totalDistance,
    durationMinutes,
  ];
}

class TripBooked extends TripState {
  final String tripId;
  final double fare;
  final String routeId;

  const TripBooked({
    required this.tripId,
    required this.fare,
    required this.routeId,
  });

  @override
  List<Object?> get props => [tripId, fare, routeId];
}

class TripsLoaded extends TripState {
  final List<dynamic> trips;

  const TripsLoaded({required this.trips});

  @override
  List<Object?> get props => [trips];
}

class TripCancelled extends TripState {
  final String tripId;

  const TripCancelled({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}

class TripRated extends TripState {
  final String tripId;
  final double rating;

  const TripRated({required this.tripId, required this.rating});

  @override
  List<Object?> get props => [tripId, rating];
}

class TripError extends TripState {
  final String message;

  const TripError({required this.message});

  @override
  List<Object?> get props => [message];
}
