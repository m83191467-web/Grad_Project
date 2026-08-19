import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // store the latest verificationId and phone while waiting for OTP
  String? _latestVerificationId;
  final Map<String, String> _verificationIdToPhone = {};

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> loginWithPhone(String phoneNumber) async {
    final completer = Completer<void>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final userCred = await _auth.signInWithCredential(credential);
          final user = userCred.user;
          if (user != null) {
            await _firestore.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'phone': phoneNumber,
              'type': 'passenger',
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
          if (!completer.isCompleted) completer.complete();
        } catch (e) {
          if (!completer.isCompleted) completer.completeError(e);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) completer.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) async {
        _latestVerificationId = verificationId;
        _verificationIdToPhone[verificationId] = phoneNumber;
        if (!completer.isCompleted) completer.complete();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _latestVerificationId = verificationId;
      },
      timeout: const Duration(seconds: 60),
    );

    return completer.future;
  }

  @override
  Future<void> verifyOtp(String otp) async {
    final verificationId = _latestVerificationId;
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
      final phone = _verificationIdToPhone[verificationId] ?? '';
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'phone': phone,
        'type': 'passenger',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<void> register({
    required String name,
    required String phone,
    String? email,
  }) async {
    final user = await remoteDataSource.signInAnonymously();
    if (user != null) {
      await remoteDataSource.saveUser(uid: user.uid, phone: phone);
      // Additional fields (name,email) can be updated later
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    await remoteDataSource.signInWithEmail(email, password);
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
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }
}
