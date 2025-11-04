import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../resources/customButton/custom_button.dart';
import '../resources/customButton/custon_field.dart';
import '../view_model/login_view_model.dart';
import 'forget_password.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginViewModel());
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: emailController,
              hintText: 'Enter Email',
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: passwordController,
              hintText: 'Enter Password',
              prefixIcon: Icons.lock_outline,

            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){

                  },
                    child: Text('Forget Password',style: TextStyle(color: Colors.blueAccent),)),
              ],
            ),
            const SizedBox(height: 30),
            Obx(() => CustomButton(
              text: 'Login',
              isLoading: controller.isLoading.value,
              onPressed: () {
                controller.login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              },
            )),

            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don’t have an account?'),
                InkWell(
                    onTap: (){
                      Get.to(SignupScreen());
                    },
                    child: Text('SignUp',style: TextStyle(color: Colors.blueAccent),)),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
