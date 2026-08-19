import '../repositories/user_repository.dart';

class SaveUserData {
  final UserRepository repository;
  SaveUserData(this.repository);

  Future<void> call({
    required String uid,
    required String name,
    required String phone,
    required String type,
  }) async {
    return repository.saveUserData(
      uid: uid,
      name: name,
      phone: phone,
      type: type,
    );
  }
}
