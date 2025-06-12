import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> storeUserProfile({
    required String uid,
    required String email,
    required String firstName,
    required String lastName,
    String? middleName,
    required String role, // 'owner' or 'seeker'
  }) async {
    await _dbRef.child('users').child(uid).set({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'middle_name': middleName,
      'role': role,
      'created_at': ServerValue.timestamp,
    });
  }
}
