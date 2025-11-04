import 'package:expense_snap/resources/customButton/buttom_nav.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Setting',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectIndex: 3,
        onItemSelect: (int value) {
          // handle navigation tap
        },
      ),
    );
  }
}
