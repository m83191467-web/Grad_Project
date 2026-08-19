abstract class UserRepository {
  Future<void> createPassenger({
    required String name,
    required String phone,
    String? email,
  });
  Future<void> saveUserData({
    required String uid,
    required String name,
    required String phone,
    required String type,
  });
}
