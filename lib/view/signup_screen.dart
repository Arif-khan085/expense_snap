// lib/views/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../resources/customButton/custom_button.dart';
import '../resources/customButton/custon_field.dart';
import '../view_model/signup_view_model.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupViewModel());

    // Text controllers
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // Name Field
              CustomTextField(
                controller: nameController,
                hintText: 'Enter your name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 15),

              // Email Field
              CustomTextField(
                controller: emailController,
                hintText: 'Enter your email',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 15),

              // Password Field
              CustomTextField(
                controller: passwordController,
                hintText: 'Enter your password',
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 30),

              // Signup Button
              Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : CustomButton(
                text: 'Sign Up',
                onPressed: () {
                  controller.signup(
                    nameController.text.trim(),
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
              )),
              const SizedBox(height: 20),

              // Go to Login
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don’t have an account?'),
                  InkWell(
                      onTap: (){
                        Get.to(LoginScreen());
                      },
                      child: Text('SignIn',style: TextStyle(color: Colors.blueAccent),)),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
