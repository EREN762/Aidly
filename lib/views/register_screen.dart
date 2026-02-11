import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../providers/auth_provider.dart';

// ═══════════════════════════════════════════════════════════════════════════
// YAN — Écran d’inscription. Tu t’occupes uniquement de cet écran (UI/UX).
// Logique : AuthController(authProvider).register(email, password); puis si succès → /home.
// ═══════════════════════════════════════════════════════════════════════════

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('RegisterScreen — Yan : à compléter (UI/UX)'),
          ],
        ),
      ),
    );
  }
}
