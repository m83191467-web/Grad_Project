import 'package:equatable/equatable.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object?> get props => [];
}

class CalculateFareEvent extends TripEvent {
  final double distanceKm;
  final DateTime pickupTime;

  const CalculateFareEvent({
    required this.distanceKm,
    required this.pickupTime,
  });

  @override
  List<Object?> get props => [distanceKm, pickupTime];
}

class StartTripEvent extends TripEvent {
  final String tripId;
  final String userId;
  final String routeId;

  const StartTripEvent({
    required this.tripId,
    required this.userId,
    required this.routeId,
  });

  @override
  List<Object?> get props => [tripId, userId, routeId];
}

class EndTripEvent extends TripEvent {
  final String tripId;
  final double finalFare;

  const EndTripEvent({required this.tripId, required this.finalFare});

  @override
  List<Object?> get props => [tripId, finalFare];
}

class UpdateLocationEvent extends TripEvent {
  final double latitude;
  final double longitude;

  const UpdateLocationEvent({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}

class BookTripEvent extends TripEvent {
  final String userId;
  final String routeId;
  final double fare;

  const BookTripEvent({
    required this.userId,
    required this.routeId,
    required this.fare,
  });

  @override
  List<Object?> get props => [userId, routeId, fare];
}

class FetchTripsEvent extends TripEvent {
  final String userId;

  const FetchTripsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CancelTripEvent extends TripEvent {
  final String tripId;

  const CancelTripEvent({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}

class RateTripEvent extends TripEvent {
  final String tripId;
  final double rating;
  final String comment;

  const RateTripEvent({
    required this.tripId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [tripId, rating, comment];
}
