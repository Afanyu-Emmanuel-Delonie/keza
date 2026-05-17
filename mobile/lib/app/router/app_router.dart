import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/navigation/presentation/navigation_page.dart';
import '../../features/home_screen/presentation/HomeScreen.dart';

class AppRouter {
  static const String home = '/';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const NavigationPage(),
      ),
    ],
  );
}
