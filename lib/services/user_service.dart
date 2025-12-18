import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static String? getUid() => FirebaseAuth.instance.currentUser?.uid;

  static String? getName() => FirebaseAuth.instance.currentUser?.displayName;

  static String? getEmail() => FirebaseAuth.instance.currentUser?.email;

  Future<void> resetCountdown() async {
    final prefs = await SharedPreferences.getInstance();
    final newTarget = DateTime.now().add(const Duration(hours: 24));

    await prefs.setString('countdown_target_time', newTarget.toIso8601String());
  }
}
