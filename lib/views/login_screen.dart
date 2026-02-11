import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../providers/auth_provider.dart';

// ═══════════════════════════════════════════════════════════════════════════
// YAN — Écran de connexion. Tu t’occupes uniquement de cet écran (UI/UX).
// Pour la logique : AuthController (ne pas modifier le controller, l’utiliser).
//
// Exemple bouton "Se connecter" :
//   final authProvider = Provider.of<AuthProvider>(context, listen: false);
//   final controller = AuthController(authProvider);
//   await controller.login(emailController.text, passwordController.text);
//   Si succès : Navigator.pushReplacementNamed(context, '/home'); sinon afficher l’erreur.
//
// Google : await controller.signInWithGoogle();
// Lien "Mot de passe oublié" : Navigator.pushNamed(context, '/forgot-password');
// Lien "S’inscrire" : Navigator.pushNamed(context, '/register');
// ═══════════════════════════════════════════════════════════════════════════

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('LoginScreen — Yan : à compléter (UI/UX)'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final controller = AuthController(authProvider);
                // TODO Yan : await controller.login(emailController.text, passwordController.text);
                // Si succès : if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
                debugPrint('AuthController prêt : ${controller.currentUserId ?? "non connecté"}');
              },
              child: const Text('Exemple bouton connexion'),
            ),
          ],
        ),
      ),
    );
  }
}
