abstract class AuthRepository {
  Future<String> loginWithPhone(String phoneNumber);
  Future<void> verifyOtp(String otp, {required String phoneNumber});
  Future<bool> isSignedIn();
  Future<String> currentUserRole();
  Future<void> signOut();
}
