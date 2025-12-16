// lib/widgets/auth/auth_layout.dart
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget form;
  final Widget bottom;

  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.form,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              form,
              const SizedBox(height: 30),
              bottom
            ],
          ),
        ),
      ),
    );
  }
}
