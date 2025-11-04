import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/splash_controller.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

SplashService  splashService = SplashService();

class _SplashscreenState extends State<Splashscreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashService.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Center(
            child: Text(
              'My Project',
               style: TextStyle(
               fontWeight: FontWeight.bold,
                fontSize: 30,
                 color: Theme.of(context).colorScheme.onSurface, // ✅ Auto adapts to light/dark
                 letterSpacing: 0.5, // subtle readability
              ),
             ),
           ),
         ],

      ),
    );
  }
}