import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/service_model.dart';
import '../providers/service_provider.dart';

// ═══════════════════════════════════════════════════════════════════════════
// YAN — Écran d’ajout d’un service. Tu t’occupes uniquement de cet écran (UI/UX).
// Créer un ServiceModel (voir lib/models/service_model.dart) puis
// ServiceProvider(context).createService(service). userId = AuthController(authProvider).currentUserId.
// Images : StorageService (lib/services/storage_service.dart).
// ═══════════════════════════════════════════════════════════════════════════

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un service')),
      body: const Center(
        child: Text('AddServiceScreen — Yan : à compléter (UI/UX)'),
      ),
    );
  }
}
