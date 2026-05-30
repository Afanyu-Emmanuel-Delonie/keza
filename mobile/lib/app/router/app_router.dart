import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/navigation/presentation/navigation_page.dart';
import '../../features/trips/presentation/checkout_page.dart';
import '../../features/trips/presentation/trip_planner/trip_planner_page.dart';
import '../../features/explore/presentation/ExploreScreen.dart';

class AppRouter {
  static const splash         = '/splash';
  static const onboarding     = '/onboarding';
  static const login          = '/login';
  static const register       = '/register';
  static const forgotPassword = '/forgot-password';
  static const home           = '/';
  static const plan           = '/plan';
  static const checkout       = '/checkout';

  static final _rootKey = GlobalKey<NavigatorState>();

  static GoRouter buildRouter(AuthProvider auth) => GoRouter(
    navigatorKey: _rootKey,
    initialLocation: splash,
    refreshListenable: auth,
    redirect: (context, state) {
      final loc = state.matchedLocation;

      // Always let splash through
      if (loc == splash) return null;

      // After splash: decide where to go
      if (!auth.hasSeenOnboarding) {
        if (loc != onboarding) return onboarding;
        return null;
      }

      if (!auth.isAuthenticated) {
        final authRoutes = [login, register, forgotPassword];
        if (!authRoutes.contains(loc)) return login;
        return null;
      }

      // Authenticated — redirect away from auth screens
      final authRoutes = [login, register, forgotPassword, onboarding];
      if (authRoutes.contains(loc)) return home;
      return null;
    },
    routes: [
      GoRoute(
        path: splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: home,
        builder: (_, __) => const NavigationPage(),
      ),
      GoRoute(
        path: plan,
        pageBuilder: (_, state) => _expandPage(
          key: state.pageKey,
          child: const TripPlannerPage(),
        ),
      ),
      GoRoute(
        path: checkout,
        pageBuilder: (_, state) => _expandPage(
          key: state.pageKey,
          child: const CheckoutPage(),
        ),
      ),
    ],
  );

  static CustomTransitionPage _expandPage({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideIn = Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
        );

        final scaleOut = Tween<double>(begin: 1.0, end: 0.96).animate(
          CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic),
        );

        final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
          ),
        );

        return FadeTransition(
          opacity: fadeOut,
          child: ScaleTransition(
            scale: scaleOut,
            child: FadeTransition(
              opacity: fadeIn,
              child: SlideTransition(position: slideIn, child: child),
            ),
          ),
        );
      },
    );
  }
}
