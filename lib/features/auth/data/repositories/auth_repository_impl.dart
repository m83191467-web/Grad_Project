import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Keep verification sessions by phone so a second request cannot overwrite
  // the OTP session belonging to another active flow.
  final Map<String, String> _verificationIdByPhone = {};

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> loginWithPhone(String phoneNumber) async {
    final completer = Completer<String>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final userCred = await _auth.signInWithCredential(credential);
          final user = userCred.user;
          if (user != null) {
            await _firestore.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'name': user.displayName ?? '',
              'email': user.email ?? '',
              'phone': phoneNumber,
              'type': 'passenger',
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
          if (!completer.isCompleted) completer.complete(phoneNumber);
        } catch (e) {
          if (!completer.isCompleted) completer.completeError(e);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) completer.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) async {
        _verificationIdByPhone[phoneNumber] = verificationId;
        if (!completer.isCompleted) completer.complete(phoneNumber);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationIdByPhone[phoneNumber] = verificationId;
      },
      timeout: const Duration(seconds: 60),
    );

    return completer.future;
  }

  @override
  Future<void> verifyOtp(
    String otp, {
    required String phoneNumber,
  }) async {
    final verificationId = _verificationIdByPhone[phoneNumber];
    if (verificationId == null) {
      throw Exception(
        'No verificationId available. Call loginWithPhone first.',
      );
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'phone': phoneNumber,
        'type': 'passenger',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    _verificationIdByPhone.remove(phoneNumber);
  }

  Future<void> loginWithEmail(String email, String password) async {
    await remoteDataSource.signInWithEmail(email, password);
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    await remoteDataSource.registerWithEmail(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
  }

  Future<void> signInWithGoogle() async {
    await remoteDataSource.signInWithGoogle();
  }

  @override
  Future<bool> isSignedIn() async {
    final user = await remoteDataSource.getCurrentUser();
    return user != null;
  }

  @override
  Future<String> currentUserRole() async {
    final user = await remoteDataSource.getCurrentUser();
    if (user == null) throw StateError('No authenticated user found.');
    try {
      final snapshot = await _firestore.collection('users').doc(user.uid).get();
      if (!snapshot.exists) {
        throw StateError('Your account profile has not been provisioned.');
      }
      final role = snapshot.data()?['type'];
      if (role is String && ['passenger', 'driver', 'admin'].contains(role)) {
        return role;
      }
      throw StateError('Your account has an invalid role.');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }
}
