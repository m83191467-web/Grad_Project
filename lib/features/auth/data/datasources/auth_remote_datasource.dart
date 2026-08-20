import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<User?> getCurrentUser();
  Future<void> signOut();
  Future<User?> signInWithGoogle();
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  });
  Future<bool> isEmailUnique(String email);
  Future<bool> isPhoneUnique(String phoneNumber);
  Future<bool> isUidUnique(String uid);
  Future<Map<String, dynamic>?> getUserByEmail(String email);
  Future<Map<String, dynamic>?> getUserByPhone(String phoneNumber);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      // Clear the cached Google session so the account chooser is shown.
      await _googleSignIn.signOut();
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName,
          'phone': user.phoneNumber,
          'type': 'passenger',
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user;
    if (user != null) {
      await user.updateDisplayName(name);
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'type': 'passenger',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return user;
  }

  /// Check if email is unique in Firestore
  @override
  Future<bool> isEmailUnique(String email) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return query.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Check if phone number is unique in Firestore
  @override
  Future<bool> isPhoneUnique(String phoneNumber) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();
      return query.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Check if UID exists in Firestore
  @override
  Future<bool> isUidUnique(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return !doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Get user by email
  @override
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get user by phone number
  @override
  Future<Map<String, dynamic>?> getUserByPhone(String phoneNumber) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
