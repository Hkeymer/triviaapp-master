import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:triviaapp/screens/home/home_screen.dart';
import 'package:triviaapp/screens/auth/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // El usuario está iniciando sesión, muestra un spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si el usuario ha iniciado sesión, muéstrale la pantalla de inicio
        if (snapshot.hasData) {
          return const HomeScreen(); 
        }

        // Si el usuario no ha iniciado sesión, muéstrale la pantalla de login
        return const LoginScreen();
      },
    );
  }
}
