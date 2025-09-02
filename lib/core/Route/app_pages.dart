import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:smart_grocery_tracker/core/Route/app_route.dart';
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

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppRoute.splash, page: () => SpashScreen()),
    GetPage(name: AppRoute.onboarding, page: () => OnboardingScreen()),
    GetPage(name: AppRoute.signin, page: () => SignInScreen()),
    GetPage(name: AppRoute.login, page: () => LoginScreen()),
    GetPage(name: AppRoute.forgetPassword, page: () => ForgetPasswordScreen()),
    GetPage(name: AppRoute.home, page: () => HomePage()),
    GetPage(name: AppRoute.groceryList, page: () => GroceryListScreen()),
    GetPage(name: AppRoute.addItem, page: () => AddItemsScreen()),
    GetPage(name: AppRoute.profile, page: () => ProfilePageScreen()),
    GetPage(
      name: AppRoute.nagivation,
      page: () => NagivationPage(
        initialIndex: Get.arguments is Map<String, dynamic>
            ? Get.arguments['initialIndex'] as int?
            : null,
      ),
    ),
  ];
}
