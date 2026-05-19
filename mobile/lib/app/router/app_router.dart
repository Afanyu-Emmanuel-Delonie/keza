import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/navigation/presentation/navigation_page.dart';
import '../../features/trips/presentation/checkout_page.dart';
import '../../features/trips/presentation/trip_planner/trip_planner_page.dart';

class AppRouter {
  static const String splash   = '/splash';
  static const String home     = '/';
  static const String plan     = '/plan';
  static const String checkout = '/checkout';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const NavigationPage(),
      ),
      GoRoute(
        path: plan,
        pageBuilder: (context, state) => _expandPage(
          key: state.pageKey,
          child: const CheckoutPage(),
        ),
      ),
      GoRoute(
        path: checkout,
        pageBuilder: (context, state) => _expandPage(
          key: state.pageKey,
          child: const CheckoutPage(),
        ),
      ),
    ],
  );

  // ===== Pill-expand transition — slides up from bottom, outgoing page scales down =====
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
