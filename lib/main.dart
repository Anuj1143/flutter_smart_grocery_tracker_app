import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:smart_grocery_tracker/bloc/auth/auth_bloc.dart';
import 'package:smart_grocery_tracker/bloc/auth/auth_state.dart';
import 'package:smart_grocery_tracker/core/Route/app_pages.dart';
import 'package:smart_grocery_tracker/core/Route/app_route.dart';
import 'package:smart_grocery_tracker/core/theme/app_theme.dart';
import 'package:smart_grocery_tracker/firebase_options.dart';
import 'package:smart_grocery_tracker/services/storage_service.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<FontBloc>(create: (context) => FontBloc()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, fontState) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Smart Grocery App',
            themeMode: ThemeMode.system,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            //theme: AppTheme.getLightTheme(fontState),
            // themeMode: ThemeMode.light,
            // darkTheme: ThemeMode.dark,
            initialRoute: AppRoute.splash,
            onGenerateRoute: AppRoute.onGenerateRoute,
            getPages: AppPages.pages,
          );
        },
      ),
    );
  }
}





// return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       themeMode: ThemeMode.system,
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       home: const SpashScreen(),
//     );