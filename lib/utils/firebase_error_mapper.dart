import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorMapper {
  static String auth(FirebaseAuthException e) {
    switch (e.code) {
      // ─────────────────────────────
      // EMAIL & PASSWORD
      // ─────────────────────────────
      case 'invalid-email':
        return 'El correo no tiene un formato válido.';

      case 'email-already-in-use':
        return 'Ya existe un usuario registrado con este correo.';

      case 'weak-password':
        return 'La contraseña es demasiado débil.';

      case 'missing-password':
        return 'Debes ingresar una contraseña.';

      case 'missing-email':
        return 'Debes ingresar un correo.';

      case 'invalid-password':
        return 'La contraseña no es válida o no cumple requisitos.';

      // ─────────────────────────────
      // LOGIN (ERRORES NUEVOS)
      // ─────────────────────────────
      case 'invalid-credential':
        return 'Credenciales inválidas o expiradas. Revisa tu correo y contraseña.';

      case 'invalid-login-credentials':
        return 'Correo o contraseña incorrectos.';

      case 'wrong-password':
        // se mantiene por compatibilidad pero Firebase casi no lo usa ahora
        return 'La contraseña es incorrecta.';

      case 'user-not-found':
        return 'No existe un usuario registrado con este correo.';

      case 'user-disabled':
        return 'Esta cuenta está deshabilitada.';

      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Intenta de nuevo más tarde.';

      case 'network-request-failed':
        return 'Error de conexión. Revisa tu internet.';

      case 'operation-not-allowed':
        return 'Este método de inicio de sesión no está habilitado.';

      // ─────────────────────────────
      // SESIÓN / TOKEN
      // ─────────────────────────────
      case 'requires-recent-login':
        return 'Por seguridad debes iniciar sesión nuevamente para realizar esta acción.';

      case 'token-expired':
        return 'La sesión ha expirado. Inicia sesión nuevamente.';

      case 'user-token-expired':
        return 'El token de usuario ha expirado.';

      // ─────────────────────────────
      // TELÉFONO
      // ─────────────────────────────
      case 'invalid-phone-number':
        return 'Número telefónico inválido.';

      case 'missing-phone-number':
        return 'Debes ingresar un número telefónico.';

      case 'missing-verification-code':
        return 'Debes ingresar el código enviado por SMS.';

      case 'missing-verification-id':
        return 'Error interno: falta el ID de verificación.';

      case 'invalid-verification-code':
        return 'Código de verificación incorrecto.';

      case 'quota-exceeded':
        return 'Se ha excedido el límite de SMS. Intenta más tarde.';

      // ─────────────────────────────
      // PROVEEDORES (GOOGLE, FACEBOOK, ETC.)
      // ─────────────────────────────
      case 'credential-already-in-use':
        return 'Esta credencial ya está asociada a otra cuenta.';

      case 'account-exists-with-different-credential':
        return 'Ya existe una cuenta con este correo pero con otro método de inicio.';

      case 'invalid-idp-response':
        return 'Respuesta inválida del proveedor de autenticación.';

      case 'invalid-oauth-client-id':
        return 'Client ID de OAuth inválido.';

      case 'invalid-oauth-provider':
        return 'Proveedor OAuth inválido.';

      case 'operation-not-supported-in-this-environment':
        return 'Esta operación no está permitida en este dispositivo o navegador.';

      // ─────────────────────────────
      // DEFAULT
      // ─────────────────────────────
      default:
        return 'Ocurrió un error inesperado: ${e.message}';
    }
  }
}
