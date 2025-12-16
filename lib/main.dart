import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

// Providers
import 'package:triviaapp/provider/theme_provider.dart';
import 'package:triviaapp/provider/auth_provider.dart';

// Services
import 'package:triviaapp/services/auth_service.dart';

// Screens
import 'package:triviaapp/screens/auth/auth_wrapper.dart';

// Theme
import 'package:triviaapp/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TriviaRoot());
}

class TriviaRoot extends StatelessWidget {
  const TriviaRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const TriviApp(),
    );
  }
}

class TriviApp extends StatelessWidget {
  const TriviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, theme, __) {
        return MaterialApp(
          title: 'TriviApp',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: theme.themeMode,
          home: const AuthWrapper(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
