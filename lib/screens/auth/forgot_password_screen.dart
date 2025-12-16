// lib/screens/auth/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triviaapp/services/auth_service.dart';
import 'package:triviaapp/widgets/auth/auth_layout.dart';
import 'package:triviaapp/widgets/auth/auth_input.dart';
import 'package:triviaapp/utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _loading = false;
  String? _message;

  AuthService get _auth => context.read<AuthService>();

  Future<void> _send() async {
    final email = _email.text.trim();
    if (!Validators.emailValid(email)) {
      setState(() => _message = 'Introduce un correo válido');
      return;
    }
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      await _auth.sendPasswordResetEmail(email);
      setState(() => _message = 'Correo de recuperación enviado. Revisa tu bandeja.');
    } catch (e) {
      setState(() => _message = 'Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Recuperar contraseña',
      subtitle: 'Te enviaremos un enlace para restablecer tu contraseña',
      form: Column(
        children: [
          AuthInput(controller: _email, label: 'Correo electrónico', keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 18),
          if (_message != null) Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 18),
          _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _send, child: const Text('Enviar enlace')),
        ],
      ),
      bottom: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Volver')),
    );
  }
}
