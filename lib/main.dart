import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:abodes/welcomepage.dart'; // Import the WelcomePage widget
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                home: Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              );
            } else if (snapshot.hasError) {
              return const MaterialApp(
                home: Scaffold(
                  body: Center(child: Text('Error initializing app')),
                ),
              );
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: WelcomePage(),
              );
            }
          },
        );
      },
    );
  }
}

