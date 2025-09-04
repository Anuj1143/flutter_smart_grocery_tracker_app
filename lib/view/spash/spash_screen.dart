import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_grocery_tracker/bloc/auth/auth_bloc.dart';
//import 'package:smart_grocery_tracker/core/Route/app_route.dart';
import 'package:smart_grocery_tracker/services/storage_service.dart';

class SpashScreen extends StatefulWidget {
  const SpashScreen({super.key});

  @override
  State<SpashScreen> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted || _hasNavigated) return;
      _handleNavigation(context);
    });
  }

  void _handleNavigation(BuildContext context) {
    if (_hasNavigated) return;
    _hasNavigated = true;
    final authState = context.read<AuthBloc>().state;
    if (StorageService.isFirstTime()) {
      StorageService.setFirstTime(true);
      // Get.offNamed(AppRoute.onboarding);
    } else if (authState.userModels != null) {
      // Get.offNamed(AppRoute.navigation);
    } else {
      // Get.offNamed(AppRoute.login);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Pick Lottie asset based on brightness
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final String lottieAssetPath = isDarkMode
        ? 'assets/lottie/Grocery.json'
        : 'assets/lottie/Grocery.json';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: Lottie.asset(
                      lottieAssetPath,
                      repeat: true,
                      reverse: true,
                      animate: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Grocery Tracker',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Track grocery smartly',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(200),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _fadeAnimation,
                child: CircularProgressIndicator(
                  color: theme.colorScheme.onSurface.withAlpha(200),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
