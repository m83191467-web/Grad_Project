import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<void> call({
    required String name,
    required String phone,
    String? email,
  }) async {
    return repository.register(name: name, phone: phone, email: email);
  }
}
