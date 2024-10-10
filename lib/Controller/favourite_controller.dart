import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Firebase Services/auth_services.dart';

class FavoriteUserController extends GetxController {
  var favoriteUsers = <DocumentSnapshot>[].obs; // Observable list of favorite users
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchFavoriteUsers();
  }

  // Method to toggle favorite status
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
        fetchFavoriteUsers(); // Refresh the favorite users
      } else {
        throw Exception("No user logged in");
      }
    } catch (e) {
      print("Error updating favorites: $e");
    }
  }

  Future<void> fetchFavoriteUsers() async {
    try {
      User? currentUser = AuthServices.authServices.getCurrentUser();
      if (currentUser != null) {
        DocumentSnapshot userDoc = await _fireStore.collection("users").doc(currentUser.email).get();
        List<dynamic> favoriteEmails = userDoc['favorites'] ?? [];

        List<DocumentSnapshot> favoriteUsersList = [];
        for (String email in favoriteEmails) {
          DocumentSnapshot userSnapshot = await _fireStore.collection("users").doc(email).get();
          favoriteUsersList.add(userSnapshot);
        }

        favoriteUsers.value = favoriteUsersList; // Update the observable list
      } else {
        throw Exception("No user logged in");
      }
    } catch (e) {
      print("Error fetching favorite users: $e");
    }
  }
}
