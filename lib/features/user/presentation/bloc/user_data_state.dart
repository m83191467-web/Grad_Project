import 'package:equatable/equatable.dart';
import '../../../../models/user_model.dart';
import '../../../../models/route_model.dart';
import '../../../../models/trip_model.dart';
import '../../../../models/driver_model.dart';

abstract class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object?> get props => [];
}

class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserProfileLoaded extends UserDataState {
  final UserModel userProfile;
  const UserProfileLoaded(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class RoutesLoaded extends UserDataState {
  final List<RouteModel> routes;
  const RoutesLoaded(this.routes);

  @override
  List<Object?> get props => [routes];
}

class UserTripsLoaded extends UserDataState {
  final List<TripModel> trips;
  const UserTripsLoaded(this.trips);

  @override
  List<Object?> get props => [trips];
}

class DriverInfoLoaded extends UserDataState {
  final DriverModel driver;
  const DriverInfoLoaded(this.driver);

  @override
  List<Object?> get props => [driver];
}

class TripBooked extends UserDataState {
  final String tripId;
  const TripBooked(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class TripCancelled extends UserDataState {
  final String tripId;
  const TripCancelled(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class TripRated extends UserDataState {
  final String tripId;
  final double rating;
  const TripRated(this.tripId, this.rating);

  @override
  List<Object?> get props => [tripId, rating];
}

class UserProfileUpdated extends UserDataState {
  final String uid;
  const UserProfileUpdated(this.uid);

  @override
  List<Object?> get props => [uid];
}

class UserDataError extends UserDataState {
  final String message;
  const UserDataError(this.message);

  @override
  List<Object?> get props => [message];
}
