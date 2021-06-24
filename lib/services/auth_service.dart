import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_event_customer/models/User.dart';

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  UserModel _userFromFirebase(User user) {
    return user == null ? null : UserModel(uid: user.uid);
  }

  Stream<UserModel> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  User getCurrentUser() {
    try {
      final user = _firebaseAuth.currentUser;
      User loggedInUser;
      if (user != null) {
        loggedInUser = user;
        return loggedInUser;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserModel> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return _userFromFirebase(authResult.user);
    } catch (e) {
      print("Error on the registration = " + e.toString());
      return null;
    }
  }

  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print("Error on the sign in = " + e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
