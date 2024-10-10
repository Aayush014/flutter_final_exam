import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Firebase Services/auth_services.dart';
import '../Firebase Services/cloud_firestore_services.dart';
import '../Model/user_model.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  bool isEmailValid() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$'); // General email regex
    return emailRegex.hasMatch(email.value);
  }

  void signIn(String email, String pass) {
    AuthServices.authServices.signIn(email, pass);
  }

  Future<void> register() async {
    UserModel user = UserModel(email: txtEmail.text, pass: txtPass.text);
    if (isEmailValid() && password.value.isNotEmpty) {
      try {
        await AuthServices.authServices.createAcc(
          email.value,
          password.value,
        );
        CloudFireStoreServices.cloudFireStoreServices
            .insertUserInFireStore(user);
      } catch (e) {
        Get.snackbar("Error", e.toString());
      }
    } else {
      Get.snackbar("Error", "Please enter valid email and password");
    }
  }
}
