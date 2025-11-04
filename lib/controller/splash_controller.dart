import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../resources/routes/named_routes.dart';

class SplashService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void isLogin(BuildContext context) {

    try {
      final User? user = _auth.currentUser;

      Timer(const Duration(seconds: 2), () {
        if (user != null) {
          Get.offAllNamed(RoutesName.homeScreen);
        } else {
          Get.offAllNamed(RoutesName.loginScreen);
        }
      });
    } catch (e) {
      Get.snackbar("Error", "Authentication check failed: $e",
          snackPosition: SnackPosition.BOTTOM);
      Timer(const Duration(seconds: 4), () {
        Get.offNamed(RoutesName.loginScreen);
      });
    }
  }
}