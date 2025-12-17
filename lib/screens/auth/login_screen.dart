// Flutter SDK
import 'package:flutter/material.dart';

// State management
import 'package:provider/provider.dart';

// Services
import 'package:triviaapp/services/auth_service.dart';

// Navigation
import 'package:triviaapp/utils/route_transitions.dart';

// Screens
import 'package:triviaapp/screens/auth/register_screen.dart';

// Widgets
import 'package:triviaapp/widgets/auth/auth_layout.dart';
import 'package:triviaapp/widgets/auth/auth_input.dart';
import 'package:triviaapp/widgets/auth/social_button.dart';

// Utils
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
      await _auth.signInWithEmailAndPassword(
        _email.text.trim(),
        _password.text,
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: AuthLayout(
        title: 'Bienvenido de vuelta',
        subtitle: 'Demuestra cuánto sabes',
        form: Form(
          key: _formKey,
          child: Column(
            children: [
              AuthInput(
                controller: _email,
                label: 'Correo electrónico',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: (v) => (v == null || !Validators.emailValid(v))
                    ? 'Correo inválido'
                    : null,
              ),
              const SizedBox(height: 16),
              AuthInput(
                controller: _password,
                label: 'Contraseña',
                obscure: true,
                prefixIcon: Icons.lock_outline,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Ingresa tu contraseña' : null,
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        child: const Text('Iniciar sesión'),
                      ),
              ),
            ],
          ),
        ),
        bottom: Column(
          children: [
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('o'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            SocialButton(
              text: 'Continuar con Google',
              assetPath: 'assets/icons/google.png',
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                FadePageRoute(page: const RegisterScreen()),
              ),
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
