import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/user_model.dart';
import 'auth_services.dart';

class CloudFireStoreServices {
  CloudFireStoreServices._privateConstructor();
  static final CloudFireStoreServices cloudFireStoreServices =
  CloudFireStoreServices._privateConstructor();

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> insertUserInFireStore(UserModel user) async {
    try {
      await _fireStore.collection("users").doc(user.email).set({
        'email': user.email,
        'pass': user.pass,
        'favorites': [], // List of favorite users
      });
    } catch (e) {
      print("Error inserting user: $e");
    }
  }



  Future<void> toggleFavoriteUser(String favoriteEmail) async {
    try {
      User? currentUser = AuthServices.authServices.getCurrentUser();
      if (currentUser != null) {
        DocumentReference userRef = _fireStore.collection("users").doc(currentUser.email);

        DocumentSnapshot userDoc = await userRef.get();
        List<dynamic> favorites = userDoc['favorites'] ?? [];

        if (favorites.contains(favoriteEmail)) {
          favorites.remove(favoriteEmail);
        } else {
          favorites.add(favoriteEmail);
        }

        await userRef.update({'favorites': favorites});
      } else {
        throw Exception("No user logged in");
      }
    } catch (e) {
      print("Error updating favorites: $e");
    }
  }



  Future<DocumentSnapshot<Map<String, dynamic>>> readCurrentUserFromFireStore() async {
    try {
      User? user = AuthServices.authServices.getCurrentUser();
      if (user != null) {
        return await _fireStore.collection("users").doc(user.email).get();
      } else {
        throw Exception("No user logged in");
      }
    } catch (e) {
      print("Error reading current user: $e");
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readAllUsersAsStream() {
    try {
      return _fireStore.collection("users").snapshots();
    } catch (e) {
      print("Error reading all users: $e");
      rethrow;
    }
  }

  Future<void> deleteUserFromFireStore(String email) async {
    try {
      await _fireStore.collection("users").doc(email).delete();
    } catch (e) {
      print("Error deleting user: $e");
    }
  }
}
