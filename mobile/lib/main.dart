import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'features/auth/data/repositories/in_memory_auth_repository.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/trips/data/repositories/in_memory_trips_repository.dart';
import 'features/trips/providers/trips_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  final authRepo = await InMemoryAuthRepository.create();

  // ── DEV: reset onboarding on every hot restart so it always shows ──
  await authRepo.resetOnboarding();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(repository: authRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => TripsProvider(repository: InMemoryTripsRepository()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
