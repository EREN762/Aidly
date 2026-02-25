import '../providers/auth_provider.dart';

// Ne pas modifier (utilisé par les écrans dans views/).

class AuthController {
  final AuthProvider _authProvider;

  AuthController(this._authProvider);

  /// Inscription
  Future<void> register(String email, String password) async {
    await _authProvider.signUp(email: email, password: password);
  }

  /// Connexion email / mot de passe
  Future<void> login(String email, String password) async {
    await _authProvider.signIn(email: email, password: password);
  }

  /// Déconnexion
  Future<void> logout() async {
    await _authProvider.signOut();
  }

  /// Mot de passe oublié
  Future<void> resetPassword(String email) async {
    await _authProvider.resetPassword(email: email);
  }

  /// Connexion avec Google
  Future<void> signInWithGoogle() async {
    await _authProvider.signInWithGoogle();
  }

  /// Utilisateur Firebase actuel (ex. pour récupérer l'uid dans les écrans)
  String? get currentUserId => _authProvider.currentUser?.uid;
}
