import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      if (kDebugMode) {
        print("Firebase init error: $e");
      }
      rethrow;
    }
  }
}
