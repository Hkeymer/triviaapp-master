import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  UserModel? user;

  Stream<DocumentSnapshot>? _userStream;

  AuthProvider(this._authService);

  // Llamar después del login
  void startUserListener() {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser == null) return;

    _userStream = FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .snapshots();

    _userStream!.listen((snapshot) {
      if (snapshot.exists) {
        user = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
        notifyListeners();
      }
    });
  }

  // Logout
  void clear() {
    user = null;
    notifyListeners();
  }
}
