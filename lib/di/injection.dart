import 'package:get_it/get_it.dart';

import '../data/services/api_service.dart';
import '../data/services/location_service.dart';
import '../data/services/pricing_service.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/domain/usecases/login_with_phone.dart';
import '../features/auth/domain/usecases/verify_otp.dart';
import '../features/auth/domain/usecases/register_user.dart';
import '../features/auth/domain/usecases/is_signed_in.dart';
import '../features/auth/domain/usecases/sign_out.dart';
import '../features/trip/presentation/bloc/trip_bloc.dart';
import '../features/user/data/datasources/user_remote_datasource.dart';
import '../features/user/data/repositories/user_repository_impl.dart';
import '../features/user/domain/repositories/user_repository.dart';
import '../features/user/domain/usecases/create_passenger.dart';
import '../features/user/domain/usecases/save_user_data.dart';
import '../features/user/presentation/bloc/user_data_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton(() => LocationService());
  sl.registerLazySingleton(() => PricingService());

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => sl<AuthRepositoryImpl>());

  // Usecases
  sl.registerLazySingleton(() => LoginWithPhone(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => IsSignedIn(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // User feature
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<UserRepositoryImpl>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<UserRepository>(() => sl<UserRepositoryImpl>());
  sl.registerLazySingleton(() => CreatePassenger(sl()));
  sl.registerLazySingleton(() => SaveUserData(sl()));

  // Blocs
  sl.registerFactory(
    () => AuthBloc(
      loginWithPhone: sl(),
      verifyOtp: sl(),
      registerUser: sl(),
      createPassenger: sl(),
      isSignedIn: sl(),
      signOut: sl(),
      authRepository: sl(),
    ),
  );
  sl.registerFactory(() => UserDataBloc(userRepository: sl()));
  sl.registerFactory(() => TripBloc(pricingService: sl()));
}
