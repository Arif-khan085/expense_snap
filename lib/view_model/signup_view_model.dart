// lib/view_model/signup_view_model.dart
import 'package:get/get.dart';

import '../controller/auth_services/auth_services.dart';


class SignupViewModel extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  Future<void> signup(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    try {
      isLoading.value = true;
      await _authService.signUpWithEmail(name, email, password);
      Get.snackbar('Success', 'Account created successfully!');
    } catch (e) {
      Get.snackbar('Signup Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
