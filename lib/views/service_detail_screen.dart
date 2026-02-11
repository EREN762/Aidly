import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/service_model.dart';
import '../providers/service_provider.dart';

// ═══════════════════════════════════════════════════════════════════════════
// YAN — Écran de détail d’un service. Tu t’occupes uniquement de cet écran (UI/UX).
// Id du service : ModalRoute.of(context)?.settings.arguments ou argument de route.
// ServiceProvider : updateRating(serviceId, note), deleteService(id), updateService(service).
// ═══════════════════════════════════════════════════════════════════════════

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail du service')),
      body: const Center(
        child: Text('ServiceDetailScreen — Yan : à compléter (UI/UX)'),
      ),
    );
  }
}
