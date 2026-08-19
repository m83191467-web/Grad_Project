import '../repositories/auth_repository.dart';

class LoginWithPhone {
  final AuthRepository repository;

  LoginWithPhone(this.repository);

  Future<void> call(String phoneNumber) async {
    return repository.loginWithPhone(phoneNumber);
  }
}
