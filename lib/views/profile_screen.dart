import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../controllers/service_controller.dart';
import '../models/service_model.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'service_detail_screen.dart';
import 'widgets/app_spacing.dart';
import 'widgets/custom_button.dart';
import 'widgets/section_header.dart';
import 'widgets/service_card.dart';
import 'widgets/shimmer_box.dart';
import 'widgets/view_transitions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ServiceController _serviceController;

  @override
  void initState() {
    super.initState();
    _serviceController = ServiceController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final controller = AuthController(authProvider);
    final userId = controller.currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screen,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          child: Icon(Icons.person, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Utilisateur Aidly',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'ID: ${userId ?? 'inconnu'}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF6A7C76),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await controller.logout();
                            if (!mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.logout),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      label: 'Modifier mon profil',
                      variant: ButtonVariant.outline,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Mes services'),
            const SizedBox(height: 12),
            StreamBuilder<List<ServiceModel>>(
              stream: _serviceController.getServicesByUser(userId ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: const [
                      ShimmerBox(height: 160),
                      SizedBox(height: 16),
                      ShimmerBox(height: 160),
                    ],
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(
                    'Vous n avez pas encore publie de services.',
                    style: theme.textTheme.bodyMedium,
                  );
                }
                final services = snapshot.data!;
                return SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: services.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return SizedBox(
                        width: 200,
                        child: ServiceCard(
                          service: service,
                          onTap: () {
                            Navigator.of(context).push(
                              sharedAxisRoute(
                                page: ServiceDetailScreen(service: service),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Astuce: utilisez l onglet Ajouter pour publier un service.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6A7C76),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
