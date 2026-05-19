import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'app/dependency_injection/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ensure ScreenUtil has the screen size before rendering
  await ScreenUtil.ensureScreenSize();
  
  runApp(
    MultiProvider(
      providers: getProviders(),
      child: const MyApp(),
    ),
  );
}
