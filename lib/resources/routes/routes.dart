
import 'package:expense_snap/view/add_transection.dart';
import 'package:expense_snap/view/analytics_screen.dart';
import 'package:expense_snap/view/home_screen.dart';
import 'package:expense_snap/view/loans_view.dart';
import 'package:expense_snap/view/signup_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../view/login_screen.dart';
import '../../view/splash_screen.dart';
import 'named_routes.dart';

class AppRoutes{

  static appRoutes() => [
    GetPage(
      name: RoutesName.splashScreen,
      page: () => Splashscreen(),
      transitionDuration: Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade,
      ),
    GetPage(
      name: RoutesName.loginScreen,
      page: () => LoginScreen(),
      transitionDuration: Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),

    GetPage(
      name: RoutesName.signupScreen,
      page: () => SignupScreen(),
      transitionDuration: Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: RoutesName.homeScreen,
      page: () => HomeScreen(),
      transitionDuration: Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: RoutesName.addTransectionScreen,
      page: () => AddTransactionView(),
      transitionDuration: Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: RoutesName.analyticsScreen,
      page: () => AnalyticsScreen(),
      transitionDuration: Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: RoutesName.loanScreen,
      page: () => LoanScreen(),
      transitionDuration: Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
  ];
}