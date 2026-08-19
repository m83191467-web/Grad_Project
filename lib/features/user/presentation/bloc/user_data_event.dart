import 'package:equatable/equatable.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfileRequested extends UserDataEvent {
  final String uid;
  const FetchUserProfileRequested(this.uid);

  @override
  List<Object?> get props => [uid];
}

class FetchAvailableRoutesRequested extends UserDataEvent {
  const FetchAvailableRoutesRequested();
}

class FetchUserTripsRequested extends UserDataEvent {
  final String userId;
  const FetchUserTripsRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FetchDriverInfoRequested extends UserDataEvent {
  final String driverId;
  const FetchDriverInfoRequested(this.driverId);

  @override
  List<Object?> get props => [driverId];
}

class BookTripRequested extends UserDataEvent {
  final String userId;
  final String routeId;
  const BookTripRequested(this.userId, this.routeId);

  @override
  List<Object?> get props => [userId, routeId];
}

class CancelTripRequested extends UserDataEvent {
  final String tripId;
  const CancelTripRequested(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class RateTripRequested extends UserDataEvent {
  final String tripId;
  final double rating;
  const RateTripRequested(this.tripId, this.rating);

  @override
  List<Object?> get props => [tripId, rating];
}

class UpdateUserProfileRequested extends UserDataEvent {
  final String uid;
  final Map<String, dynamic> data;
  const UpdateUserProfileRequested(this.uid, this.data);

  @override
  List<Object?> get props => [uid, data];
}
