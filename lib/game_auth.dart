import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class BaseAuth {
  Future<User> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password);
  Future<void> signOut();
  Future<String?> getEmail();
  // Future<bool> isEmailVerified();
  Future<void> resetPassword(String email);
  Future<void> sendEmailVerification();
}

class GameAuth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = credential.user;
    return user!.uid;
  }

  @override
  Future<String> createUser(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = credential.user;
    return user!.uid;
  }

  @override
  Future<User> currentUser() async {
    User user = _firebaseAuth.currentUser!;
    if (kDebugMode) {
      print("uid ${user.uid}");
    }
    return user;
  }

  @override
  Future<String?> getEmail() async {
    User user = _firebaseAuth.currentUser!;
    return user.email;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  // Future<bool> isEmailVerified() async {
  //  User user = _firebaseAuth.currentUser!;
  //  return user.isEmailVerified;
  // }

  @override
  Future<void> resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> sendEmailVerification() async {
    User user = _firebaseAuth.currentUser!;
    return user.sendEmailVerification();
  }
}
