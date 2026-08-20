import '../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  Future<void> call(String otp, {required String phoneNumber}) async {
    return repository.verifyOtp(otp, phoneNumber: phoneNumber);
  }
}
