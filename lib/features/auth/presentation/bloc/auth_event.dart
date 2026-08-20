import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String phoneNumber;
  const LoginRequested(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class LoginWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginWithEmailRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

class OtpSubmitted extends AuthEvent {
  final String otp;
  final String phoneNumber;
  const OtpSubmitted(this.otp, {required this.phoneNumber});

  @override
  List<Object?> get props => [otp, phoneNumber];
}

class LogoutRequested extends AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String name;
  final String phone;
  final String? email;
  final String password;

  const RegisterRequested({
    required this.name,
    required this.phone,
    this.email,
    this.password = '',
  });

  @override
  List<Object?> get props => [name, phone, email, password];
}
