import '../repositories/user_repository.dart';

class CreatePassenger {
  final UserRepository repository;
  CreatePassenger(this.repository);

  Future<void> call({
    required String name,
    required String phone,
    String? email,
  }) async {
    return repository.createPassenger(name: name, phone: phone, email: email);
  }
}
