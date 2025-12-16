// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triviaapp/services/auth_service.dart';
import 'package:triviaapp/utils/route_transitions.dart';
import 'package:triviaapp/screens/auth/register_screen.dart';
import 'package:triviaapp/widgets/auth/auth_layout.dart';
import 'package:triviaapp/widgets/auth/auth_input.dart';
import 'package:triviaapp/widgets/auth/social_button.dart';
import 'package:triviaapp/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  String? _error;

  AuthService get _auth => context.read<AuthService>();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _auth.signInWithEmailAndPassword(_email.text.trim(), _password.text);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Bienvenido de vuelta',
      subtitle: 'Inicia sesión para continuar',
      form: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthInput(
              controller: _email,
              label: 'Correo electrónico',
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || !Validators.emailValid(v)) ? 'Correo inválido' : null,
            ),
            const SizedBox(height: 16),
            AuthInput(
              controller: _password,
              label: 'Contraseña',
              obscure: true,
              validator: (v) => (v == null || v.isEmpty) ? 'Ingresa tu contraseña' : null,
            ),
            const SizedBox(height: 18),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 18),
            _loading ? const CircularProgressIndicator() : ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
      bottom: Column(
        children: [
          const SizedBox(height: 8),
          const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('o')), Expanded(child: Divider())]),
          const SizedBox(height: 12),
          SocialButton(text: 'Continuar con Google', assetPath: 'assets/images/p-logo.png'),
          const SizedBox(height: 18),
          TextButton(onPressed: () => Navigator.push(context, FadePageRoute(page: const RegisterScreen())), child: const Text('¿No tienes cuenta? Regístrate')),
        ],
      ),
    );
  }
}
