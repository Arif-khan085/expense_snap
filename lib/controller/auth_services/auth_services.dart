// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../view/home_screen.dart';
import '../../view/login_screen.dart';
// ✅ for logout navigation

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Login with email and password
  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // ✅ Navigate to HomeScreen after success
      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed",
        e.message ?? "Please check your credentials",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ✅ Sign up with name, email, and password
  Future<void> signUpWithEmail(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ Set display name
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();

      // ✅ Navigate to HomeScreen after signup
      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Signup Failed",
        e.message ?? "Unable to create account",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ✅ Logout method
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAll(() => const LoginScreen()); // Navigate back to Login
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Password Reset',
        'A reset link has been sent to $email',
        snackPosition: SnackPosition.TOP,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Failed to send reset email',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ✅ Get current user
  User? get currentUser => _auth.currentUser;
}
