// lib/widgets/auth/social_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triviaapp/services/auth_service.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String assetPath;

  const SocialButton({
    super.key,
    required this.text,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: Colors.black12),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () async {
        try {
          await auth.signInWithGoogle();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error inicio Google: ${e.toString()}')),
          );
        }
      },
      icon: Image(image: AssetImage(assetPath), height: 20),
      label: Text(text),
    );
  }
}
