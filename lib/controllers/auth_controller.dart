import '../providers/auth_provider.dart';
import '../services/auth_service.dart';

// Ne pas modifier (utilisé par les écrans dans views/).

class AuthController {
  final AuthService _authService = AuthService();
  final AuthProvider _authProvider;

  AuthController(this._authProvider);

  /// Inscription
  Future<void> register(String email, String password) async {
    final user = await _authService.signUp(
      email: email,
      password: password,
    );
    if (user != null) {
      await _authProvider.loginSuccess();
    }
  }

  /// Connexion email / mot de passe
  Future<void> login(String email, String password) async {
    final user = await _authService.signIn(
      email: email,
      password: password,
    );
    if (user != null) {
      await _authProvider.loginSuccess();
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    await _authService.signOut();
    await _authProvider.logout();
  }

  /// Mot de passe oublié
  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email: email);
  }

  /// Connexion avec Google
  Future<void> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      await _authProvider.loginSuccess();
    }
  }

  /// Utilisateur Firebase actuel (ex. pour récupérer l'uid dans les écrans)
  String? get currentUserId => _authService.currentUser?.uid;
}
