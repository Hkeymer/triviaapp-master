// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triviaapp/services/auth_service.dart';
import 'package:triviaapp/widgets/auth/auth_layout.dart';
import 'package:triviaapp/widgets/auth/auth_input.dart';
import 'package:triviaapp/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _loading = false;
  String? _error;

  AuthService get _auth => context.read<AuthService>();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final pwdError = Validators.passwordStrength(_password.text);
    if (pwdError != null) {
      setState(() => _error = pwdError);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        _email.text.trim(),
        _password.text,
        _name.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Crear cuenta',
      subtitle: 'Únete y comienza a jugar',
      form: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthInput(
              controller: _name,
              prefixIcon: Icons.person,
              label: 'Nombre',
              validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            AuthInput(
              controller: _email,
              prefixIcon: Icons.email_outlined,
              label: 'Correo electrónico',
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || !Validators.emailValid(v))
                  ? 'Correo inválido'
                  : null,
            ),
            const SizedBox(height: 16),
            AuthInput(
              controller: _password,
              prefixIcon: Icons.lock_outline,
              label: 'Contraseña',
              obscure: true,
              validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            AuthInput(
              controller: _confirm,
              prefixIcon: Icons.lock_outline,
              label: 'Confirmar contraseña',
              obscure: true,
              validator: (v) => v != _password.text ? 'No coinciden' : null,
            ),
            const SizedBox(height: 18),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 18),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: const Text('Registrarse'),
                  ),
          ],
        ),
      ),
      bottom: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('¿Ya tienes cuenta? Inicia sesión'),
      ),
    );
  }
}
