import 'package:firebase_auth/firebase_auth.dart';

import 'cloud_firestore_services.dart';

class AuthServices {
  static AuthServices authServices = AuthServices._();

  AuthServices._();

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> createAcc(String mail, String pass) async {

    try {
      UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(email: mail, password: pass);

    } catch (e) {
      print("Error creating account: $e");
    }
  }

  Future<void> signIn(String mail, String pass) async {
    try {
      UserCredential userCredential =
      await auth.signInWithEmailAndPassword(email: mail, password: pass);
      print("Signed in: ${userCredential.user!.email}");
    } catch (e) {
      print("Error signing in: $e");
    }
  }

  User? getCurrentUser() {
    User? user = auth.currentUser;
    return user;
  }
}
