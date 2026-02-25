import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../controllers/service_controller.dart';
import '../models/service_model.dart';
import '../providers/auth_provider.dart';
import '../providers/service_provider.dart';
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
  bool _isUploadingProfile = false;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _serviceController = ServiceController();
  }

  Future<void> _uploadProfileImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (file == null) return;

    setState(() => _isUploadingProfile = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.currentUser?.uid;
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      final provider = Provider.of<ServiceProvider>(context, listen: false);
      final url = await provider.uploadProfileImage(
        file: File(file.path),
        userId: userId,
      );

      if (!mounted) return;
      setState(() => _profileImageUrl = url);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo de profil mise à jour !')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $error')));
    } finally {
      if (mounted) setState(() => _isUploadingProfile = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final controller = AuthController(authProvider);
    final userId = controller.currentUserId;

    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
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
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              backgroundImage:
                                  _profileImageUrl != null &&
                                      _profileImageUrl!.isNotEmpty
                                  ? NetworkImage(_profileImageUrl!)
                                  : null,
                              child:
                                  _profileImageUrl == null ||
                                      _profileImageUrl!.isEmpty
                                  ? const Icon(Icons.person, size: 28)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _isUploadingProfile
                                    ? null
                                    : _uploadProfileImage,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: _isUploadingProfile
                                      ? SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  theme.colorScheme.onPrimary,
                                                ),
                                          ),
                                        )
                                      : Icon(
                                          Icons.camera_alt,
                                          size: 14,
                                          color: theme.colorScheme.onPrimary,
                                        ),
                                ),
                              ),
                            ),
                          ],
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
                      isLoading: _isUploadingProfile,
                      onPressed: _uploadProfileImage,
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
