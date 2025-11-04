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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Setting'),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(selectIndex: 3, onItemSelect: (int value){})
    );

  }
}
