import '../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  Future<void> call(String otp) async {
    return repository.verifyOtp(otp);
  }
}
