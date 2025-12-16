// lib/services/auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:triviaapp/models/user_model.dart';
import 'package:triviaapp/utils/firebase_error_mapper.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Usa la nueva API
  GoogleSignIn get _google => GoogleSignIn(scopes: ['email', 'profile']);

  User? get currentUser => _auth.currentUser;

  // ----------------------------------------------------------
  // Email / Password
  // ----------------------------------------------------------

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _ensureUserDocument(_auth.currentUser!);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.auth(e);
    }
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;
      final appUser = UserModel.initial(
        uid: user.uid,
        email: email,
        name: name,
      );

      await _db.collection('users').doc(user.uid).set(appUser.toMap());
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.auth(e);
    }
  }

  // ----------------------------------------------------------
  // Google Sign-In (API 2025 CORRECTA)
  // ----------------------------------------------------------

  Future<void> signInWithGoogle() async {
    try {
      // 1. Abrir selector de Google
      final GoogleSignInAccount? googleUser = await _google.signIn();

      if (googleUser == null) {
        return; // usuario canceló
      }

      // 2. Obtener credenciales de Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Convertir a credencial de Firebase
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken, // ESTA API SÍ LO INCLUYE
      );

      // 4. Iniciar sesión en Firebase
      final userCred = await _auth.signInWithCredential(credential);
      final firebaseUser = userCred.user!;

      // 5. Asegurar Firestore
      await _ensureUserDocument(
        firebaseUser,
        displayName: googleUser.displayName,
        email: googleUser.email,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.auth(e);
    } catch (e) {
      throw "Unexpected Google Sign-In error: $e";
    }
  }

  // ----------------------------------------------------------
  // Reset password
  // ----------------------------------------------------------

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.auth(e);
    }
  }

  // ----------------------------------------------------------
  // Sign out
  // ----------------------------------------------------------

  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await _google.disconnect();
    } catch (_) {}
  }

  // ----------------------------------------------------------
  // Asegurar documento en Firestore
  // ----------------------------------------------------------

  Future<void> _ensureUserDocument(
    User firebaseUser, {
    String? displayName,
    String? email,
  }) async {
    final docRef = _db.collection('users').doc(firebaseUser.uid);
    final snap = await docRef.get();

    if (!snap.exists) {
      final appUser = UserModel.initial(
        uid: firebaseUser.uid,
        name: displayName ?? firebaseUser.displayName ?? 'Player',
        email: email ?? firebaseUser.email ?? '',
      );

      await docRef.set(appUser.toMap());
    }
  }
}
