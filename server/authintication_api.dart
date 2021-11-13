import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmailAuth _emailAuth=EmailAuth(sessionName: 'Honest seller');

  AuthenticationApi();

  static String? get gitUserUid => FirebaseAuth.instance.currentUser?.uid;

  Stream<User?> get gitUserState => _auth.userChanges();

  Future<UserCredential> createUserWithEmailAndPassword(
          {required String email, required String password}) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> login(
          {required String email, required String password}) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);
  Future<void> signOut() =>_auth.signOut();


  bool? get isEmailVerification=>_auth.currentUser?.emailVerified;


  bool verifyEmailOTP({required String email,required String userOtp}){
    return _emailAuth.validateOtp(recipientMail: email, userOtp: userOtp);
  }
  
  Future<bool> sendEmailOTP(String email){
      return _emailAuth.sendOtp(recipientMail: email,otpLength: 7);
  }

}
