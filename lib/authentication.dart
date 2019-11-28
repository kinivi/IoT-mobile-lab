import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class Auth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> updateInfo(String email, String name);
  Future<void> updateProfileURL(String photoURL);
  Future<void> signOut();
}

class FireAuth implements Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> updateInfo(String email, String name) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    UserUpdateInfo newInfo = new UserUpdateInfo();
    newInfo.displayName = name;

    try {
      await user.updateProfile(newInfo);
      await user.updateEmail(email);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProfileURL(String photoURL) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    UserUpdateInfo newInfo = new UserUpdateInfo();
    newInfo.photoUrl = photoURL;

    try {
      await user.updateProfile(newInfo);
    } catch (e) {
      print(e);
    }
  }
}
