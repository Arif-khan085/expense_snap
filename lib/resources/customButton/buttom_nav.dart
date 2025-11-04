
import 'package:expense_snap/view/add_transection.dart';
import 'package:expense_snap/view/analytics_screen.dart';
import 'package:expense_snap/view/loans_view.dart';
import 'package:expense_snap/view/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view/home_screen.dart';
import '../colors/app_colors.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectIndex;
  final ValueChanged<int> onItemSelect;

  const CustomNavigationBar({
    super.key,
    required this.selectIndex,
    required this.onItemSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectIndex,

      onTap: (index) {
        if (index == selectIndex) return;
        onItemSelect(index);
        switch (index) {
          case 0:
            Get.off(() => HomeScreen());
          case 1:
            Get.off(() => AddTransactionView());
          case 2:
            Get.off(()=>AnalyticsScreen());
          case 3:
            Get.off(() => SettingScreen());
            break;
        }
      },
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.black,
      showSelectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 30),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline, size: 30),
          label: 'Add Trans',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics, size: 30),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, size: 30),
          label: 'Settings',
        ),
      ],
    );
  }
}
