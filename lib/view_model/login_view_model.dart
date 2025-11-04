// lib/view_model/login_view_model.dart
import 'package:get/get.dart';
import '../controller/auth_services/auth_services.dart';

class LoginViewModel extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and password are required');
      return;
    }

    try {
      isLoading.value = true;
      await _authService.loginWithEmail(email, password); // ✅ Correct method name
      Get.snackbar('Success', 'Login successful!');
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
