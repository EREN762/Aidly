import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../providers/auth_provider.dart';

// ═══════════════════════════════════════════════════════════════════════════
// YAN — Écran d’accueil après connexion. Tu t’occupes uniquement de cet écran (UI/UX).
//
// Liste des services : ServiceController().getServices() dans un StreamBuilder.
// Déconnexion : AuthController(authProvider).logout(); (AuthWrapper redirigera vers Login.)
// Navigation : /add-service, /service-detail, /profile
// ═══════════════════════════════════════════════════════════════════════════

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aidly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final controller = AuthController(authProvider);
              await controller.logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('HomeScreen — Yan : à compléter (UI/UX)'),
            const SizedBox(height: 8),
            const Text('Ex : liste des services avec StreamBuilder + ServiceController().getServices()'),
          ],
        ),
      ),
    );
  }
}
