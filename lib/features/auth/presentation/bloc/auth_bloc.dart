import 'package:bloc/bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_with_phone.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/is_signed_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../../user/domain/usecases/create_passenger.dart';
import '../../data/repositories/auth_repository_impl.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithPhone loginWithPhone;
  final VerifyOtp verifyOtp;
  final RegisterUser registerUser;
  final CreatePassenger createPassenger;
  final IsSignedIn isSignedIn;
  final SignOut signOut;
  final AuthRepositoryImpl authRepository;

  AuthBloc({
    required this.loginWithPhone,
    required this.verifyOtp,
    required this.registerUser,
    required this.createPassenger,
    required this.isSignedIn,
    required this.signOut,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LoginWithEmailRequested>(_onLoginWithEmailRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final signedIn = await isSignedIn.call();
      if (signedIn) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await loginWithPhone.call(event.phoneNumber);
      emit(AuthCodeSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLoginWithEmailRequested(
    LoginWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.loginWithEmail(event.email, event.password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signInWithGoogle();
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await verifyOtp.call(event.otp);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await createPassenger.call(
        name: event.name,
        phone: event.phone,
        email: event.email,
      );
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await signOut.call();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
