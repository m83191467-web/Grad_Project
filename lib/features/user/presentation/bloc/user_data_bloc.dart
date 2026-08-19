import 'package:bloc/bloc.dart';
import 'user_data_event.dart';
import 'user_data_state.dart';
import '../../data/repositories/user_repository_impl.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final UserRepositoryImpl userRepository;

  UserDataBloc({required this.userRepository}) : super(UserDataInitial()) {
    on<FetchUserProfileRequested>(_onFetchUserProfile);
    on<FetchAvailableRoutesRequested>(_onFetchAvailableRoutes);
    on<FetchUserTripsRequested>(_onFetchUserTrips);
    on<FetchDriverInfoRequested>(_onFetchDriverInfo);
    on<BookTripRequested>(_onBookTrip);
    on<CancelTripRequested>(_onCancelTrip);
    on<RateTripRequested>(_onRateTrip);
    on<UpdateUserProfileRequested>(_onUpdateUserProfile);
  }

  Future<void> _onFetchUserProfile(
    FetchUserProfileRequested event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());
    try {
      final userProfile = await userRepository.getUserProfile(event.uid);
      if (userProfile != null) {
        emit(UserProfileLoaded(userProfile));
      } else {
        emit(const UserDataError('User profile not found'));
      }
    } catch (e) {
      emit(UserDataError(e.toString()));
    }
  }

  Future<void> _onFetchAvailableRoutes(
    FetchAvailableRoutesRequested event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());
    try {
      final routes = await userRepository.fetchAvailableRoutes();
      emit(RoutesLoaded(routes));
    } catch (e) {
      emit(UserDataError(e.toString()));
    }
  }

  Future<void> _onFetchUserTrips(
    FetchUserTripsRequested event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());
    try {
      final trips = await userRepository.fetchUserTrips(event.userId);
      emit(UserTripsLoaded(trips));
    } catch (e) {
      emit(UserDataError(e.toString()));
    }
  }

  Future<void> _onFetchDriverInfo(
    FetchDriverInfoRequested event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());
    try {
      final driver = await userRepository.getDriverInfo(event.driverId);
      if (driver != null) {
        emit(DriverInfoLoaded(driver));
      } else {
        emit(const UserDataError('Driver not found'));
      }
    } catch (e) {
      emit(UserDataError(e.toString()));
    }
  }

  Future<void> _onBookTrip(
    BookTripRequested event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());
    try {
      await userRepository.bookTrip(event.userId, event.routeId);
      emit(TripBooked(event.routeId));
    } catch (e) {
      emit(UserDataError(e.toString()));
    }
  }

  Future<void> _onCancelTrip(
    CancelTripRequested event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());
    try {
      await userRepository.cancelTrip(event.tripId);
      emit(TripCancelled(event.tripId));
    } catch (e) {
      emit(UserDataError(e.toString()));
    }
  }

  Future<void> _onRateTrip(
    RateTripRequested event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());
    try {
      await userRepository.rateTrip(event.tripId, event.rating);
      emit(TripRated(event.tripId, event.rating));
    } catch (e) {
      emit(UserDataError(e.toString()));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileRequested event,
    Emitter<UserDataState> emit,
  ) async {
    emit(UserDataLoading());
    try {
      await userRepository.updateUserProfile(event.uid, event.data);
      emit(UserProfileUpdated(event.uid));
    } catch (e) {
      emit(UserDataError(e.toString()));
    }
  }
}
