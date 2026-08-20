import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/pricing_service.dart';
import '../../data/repositories/trip_repository_impl.dart';
import '../../domain/repositories/trip_repository.dart';
import 'trip_event.dart';
import 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final PricingService _pricingService;
  final TripRepository _tripRepository;

  TripBloc({PricingService? pricingService, TripRepository? tripRepository})
    : _pricingService = pricingService ?? PricingService(),
      _tripRepository = tripRepository ?? TripRepositoryImpl(),
      super(const TripInitial()) {
    on<CalculateFareEvent>(_onCalculateFare);
    on<StartTripEvent>(_onStartTrip);
    on<EndTripEvent>(_onEndTrip);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<BookTripEvent>(_onBookTrip);
    on<FetchTripsEvent>(_onFetchTrips);
    on<CancelTripEvent>(_onCancelTrip);
    on<RateTripEvent>(_onRateTrip);
  }

  Future<void> _onCalculateFare(
    CalculateFareEvent event,
    Emitter<TripState> emit,
  ) async {
    emit(const TripLoading());
    try {
      final estimatedFare = _pricingService.calculateFare(
        distanceKm: event.distanceKm,
        pickupTime: event.pickupTime,
      );

      emit(
        FareCalculated(
          estimatedFare: estimatedFare,
          distanceKm: event.distanceKm,
        ),
      );
    } catch (e) {
      emit(TripError(message: 'Failed to calculate fare: $e'));
    }
  }

  Future<void> _onStartTrip(
    StartTripEvent event,
    Emitter<TripState> emit,
  ) async {
    emit(const TripLoading());
    try {
      // In a real app, you would call your API/repository here
      emit(
        TripActive(
          tripId: event.tripId,
          startTime: DateTime.now(),
          currentLatitude: 0.0,
          currentLongitude: 0.0,
          distanceTraveled: 0.0,
        ),
      );
    } catch (e) {
      emit(TripError(message: 'Failed to start trip: $e'));
    }
  }

  Future<void> _onEndTrip(EndTripEvent event, Emitter<TripState> emit) async {
    emit(const TripLoading());
    try {
      emit(
        TripEnded(
          tripId: event.tripId,
          endTime: DateTime.now(),
          finalFare: event.finalFare,
          totalDistance: 0.0,
          durationMinutes: 0,
        ),
      );
    } catch (e) {
      emit(TripError(message: 'Failed to end trip: $e'));
    }
  }

  Future<void> _onUpdateLocation(
    UpdateLocationEvent event,
    Emitter<TripState> emit,
  ) async {
    try {
      emit(
        LocationUpdated(
          latitude: event.latitude,
          longitude: event.longitude,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(TripError(message: 'Failed to update location: $e'));
    }
  }

  Future<void> _onBookTrip(BookTripEvent event, Emitter<TripState> emit) async {
    emit(const TripLoading());
    try {
      final trip = await _tripRepository.bookTrip(
        passengerId: event.userId,
        routeId: event.routeId,
        fare: event.fare,
      );
      emit(
        TripBooked(
          tripId: trip.id,
          fare: trip.fareAmount,
          routeId: trip.routeId,
        ),
      );
    } catch (e) {
      emit(TripError(message: 'Failed to book trip: $e'));
    }
  }

  Future<void> _onFetchTrips(
    FetchTripsEvent event,
    Emitter<TripState> emit,
  ) async {
    emit(const TripLoading());
    try {
      final trips = await _tripRepository.fetchPassengerTrips(event.userId);
      emit(TripsLoaded(trips: trips));
    } catch (e) {
      emit(TripError(message: 'Failed to fetch trips: $e'));
    }
  }

  Future<void> _onCancelTrip(
    CancelTripEvent event,
    Emitter<TripState> emit,
  ) async {
    emit(const TripLoading());
    try {
      await _tripRepository.updateStatus(event.tripId, 'cancelled');
      emit(TripCancelled(tripId: event.tripId));
    } catch (e) {
      emit(TripError(message: 'Failed to cancel trip: $e'));
    }
  }

  Future<void> _onRateTrip(RateTripEvent event, Emitter<TripState> emit) async {
    emit(const TripLoading());
    try {
      await _tripRepository.rateTrip(event.tripId, event.rating);
      emit(TripRated(tripId: event.tripId, rating: event.rating));
    } catch (e) {
      emit(TripError(message: 'Failed to rate trip: $e'));
    }
  }
}
