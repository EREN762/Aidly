import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

/// Pont entre UI et Backend (AuthService).
/// Expose les fonctions d'auth et l'état utilisateur pour les écrans.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  StreamSubscription<User?>? _authSubscription;

  User? get currentUser => _user;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _user = _authService.currentUser;
    _authSubscription = _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<User?> signIn({required String email, required String password}) async {
    final user = await _authService.signIn(email: email, password: password);
    _user = user;
    notifyListeners();
    return user;
  }

  Future<User?> signUp({required String email, required String password}) async {
    final user = await _authService.signUp(email: email, password: password);
    _user = user;
    notifyListeners();
    return user;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> resetPassword({required String email}) async {
    await _authService.resetPassword(email: email);
  }

  Future<User?> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    _user = user;
    notifyListeners();
    return user;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
