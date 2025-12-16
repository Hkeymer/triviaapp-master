// lib/utils/validators.dart
class Validators {
  static bool emailValid(String email) {
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return regex.hasMatch(email);
  }

  // Contraseña fuerte: min 8, mayúscula, minúscula, número, símbolo opcional
  static String? passwordStrength(String value) {
    if (value.length < 8) return 'Mínimo 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Incluye al menos una letra mayúscula';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Incluye al menos una letra minúscula';
    if (!RegExp(r'\d').hasMatch(value)) return 'Incluye al menos un número';
    return null;
  }
}
