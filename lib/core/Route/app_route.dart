import 'package:flutter/material.dart';
import 'package:smart_grocery_tracker/view/Auth/forget_password_screen.dart';
import 'package:smart_grocery_tracker/view/Auth/login_screen.dart';
import 'package:smart_grocery_tracker/view/Auth/sign_in_screen.dart';
import 'package:smart_grocery_tracker/view/Navigatation/nagivation_page.dart';
import 'package:smart_grocery_tracker/view/Onboarding/onboarding_screen.dart';
import 'package:smart_grocery_tracker/view/addItems/add_items_screen.dart';
import 'package:smart_grocery_tracker/view/goceryList/grocery_list_screen.dart';
import 'package:smart_grocery_tracker/view/home/home_page.dart';
import 'package:smart_grocery_tracker/view/profile/profile_page_screen.dart';
import 'package:smart_grocery_tracker/view/spash/spash_screen.dart';

class AppRoute {
  //Auth page
  static const String splash = '/spash';
  static const String onboarding = '/onboarding';
  static const String signin = '/signin';
  static const String login = '/login';
  static const String forgetPassword = '/forget';

  //home screen
  static const String home = '/home';

  //navigation page
  static const String nagivation = '/navigation';

  //add item page
  static const String addItem = '/add';

  // Grocery list page
  static const String groceryList = '/grocery';

  //Profile page
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SpashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case signin:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
      case nagivation:
        return MaterialPageRoute(
          builder: (_) => NagivationPage(
            initialIndex: setting.arguments is Map
                ? (setting.arguments as Map<String, dynamic>)['initialIndex']
                      as int?
                : null,
          ),
        );
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case groceryList:
        return MaterialPageRoute(builder: (_) => GroceryListScreen());
      case addItem:
        return MaterialPageRoute(builder: (_) => AddItemsScreen());

      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePageScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Route Not Found'))),
        );
    }
  }
}
