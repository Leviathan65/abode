import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abodesv1/config/routes/app_router.dart';
import 'package:abodesv1/core/constants/app_theme.dart';
import 'package:abodesv1/config/firebase/firebase_initializer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseInitializer.initialize(); // Clean wrapper for Firebase init

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router, // from config/routes/app_router.dart
          title: 'Abodes App',
          theme: AppTheme.light,
        );
      },
    );
  }
}
