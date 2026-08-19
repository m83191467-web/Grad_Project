abstract class AuthRepository {
  Future<void> loginWithPhone(String phoneNumber);
  Future<void> verifyOtp(String otp);
  Future<void> register({
    required String name,
    required String phone,
    String? email,
  });
  Future<bool> isSignedIn();
  Future<void> signOut();
}
