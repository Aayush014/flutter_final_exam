import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_exam/Controller/login_controller.dart';
import 'package:flutter_final_exam/Screens/favourite_screen.dart';
import 'package:flutter_final_exam/Screens/sign_up_screen.dart';
import 'package:get/get.dart';

import '../Controller/favourite_controller.dart';
import '../Firebase Services/cloud_firestore_services.dart';
import '../Model/user_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    final FavoriteUserController favController =
        Get.put(FavoriteUserController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Screen",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(FavouriteScreen());
            },
            icon: const Icon(
              Icons.favorite_border,
              size: 35,
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: StreamBuilder(
        stream: CloudFireStoreServices.cloudFireStoreServices
            .readAllUsersAsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            List<DocumentSnapshot> docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(
                child: Text(
                  'No users found',
                ),
              );
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                UserModel user = UserModel.fromMap(
                  docs[index].data() as Map<String, dynamic>,
                );

                return ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete User"),
                              content: const Text(
                                  "Are you sure you want to delete this user?"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    _deleteUser(context, user.email.toString());
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Delete"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {
                          favController.toggleFavoriteUser(user.email!);
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  minVerticalPadding: 20,
                  leading: CircleAvatar(
                    radius: 30,
                    child: Text(
                      user.email != null && user.email!.isNotEmpty
                          ? user.email!.substring(0, 1).toUpperCase()
                          : 'N',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  title: Text(
                    user.email ?? 'No email',
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No data found'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAll(() => const SignUpScreen());
        },
      ),
    );
  }

  void _deleteUser(BuildContext context, String email) async {
    try {
      await CloudFireStoreServices.cloudFireStoreServices
          .deleteUserFromFireStore(email);
    } catch (e) {
      // Handle deletion error if necessary
    }
  }
}
