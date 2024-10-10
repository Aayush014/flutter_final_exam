import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Firebase Services/cloud_firestore_services.dart';

class FavouriteScreen extends StatelessWidget {
  // Firestore service instance
  final CloudFireStoreServices _firestoreServices = CloudFireStoreServices.cloudFireStoreServices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Users"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreServices.readAllUsersAsStream(), // Stream for all users
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading while waiting for data
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading users")); // Show error if there is an issue
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No favorite users"));
          }

          // Extract favorite users from Firestore
          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user['email']),
                trailing: IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    // Toggle the favorite status for the user
                    _firestoreServices.toggleFavoriteUser(user['email']);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
