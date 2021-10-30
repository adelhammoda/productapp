import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationApi();

  String? get gitUserUid => _auth.currentUser?.uid;

  Stream<User?> get gitUserState => _auth.userChanges();

  Future<UserCredential> createUserWithEmailAndPassword(
          {required String email, required String password}) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> login(
          {required String email, required String password}) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);
  Future<void> signOut() {
    return _auth.signOut();
  }
}
