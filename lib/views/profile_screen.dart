import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../controllers/service_controller.dart';
import '../providers/auth_provider.dart';

// ═══════════════════════════════════════════════════════════════════════════
// YAN — Écran profil utilisateur. Tu t’occupes uniquement de cet écran (UI/UX).
// Déconnexion : AuthController(authProvider).logout();
// Mes services : ServiceController().getServicesByUser(controller.currentUserId ?? '')
// ═══════════════════════════════════════════════════════════════════════════

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: const Center(
        child: Text('ProfileScreen — Yan : à compléter (UI/UX)'),
      ),
    );
  }
}
