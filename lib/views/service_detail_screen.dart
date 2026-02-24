import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../models/service_model.dart';
import '../providers/auth_provider.dart';
import '../providers/service_extras_provider.dart';
import '../providers/service_provider.dart';
import '../api/subscribe_api.dart';
import 'chat_screen.dart';
import 'widgets/app_spacing.dart';
import 'widgets/custom_button.dart';
import 'widgets/pressable_scale.dart';

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key, required this.service});

  final ServiceModel service;

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  late double _rating;
  bool _isSubscribing = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.service.rating;
  }

  Future<void> _updateRating(double value) async {
    setState(() => _rating = value);
    try {
      final provider = Provider.of<ServiceProvider>(context, listen: false);
      await provider.updateRating(widget.service.id, value);
    } catch (_) {}
  }

  Future<void> _subscribe() async {
    final extrasProvider =
        Provider.of<ServiceExtrasProvider>(context, listen: false);
    final providerEmail =
        extrasProvider.getProviderEmail(widget.service.id);
    if (providerEmail == null || providerEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email du prestataire introuvable.')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authController = AuthController(authProvider);
    final clientId = authController.currentUserId ?? '';
    if (clientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utilisateur non connecte.')),
      );
      return;
    }

    setState(() => _isSubscribing = true);
    try {
      await SubscribeApi().subscribe(
        serviceId: widget.service.id,
        providerEmail: providerEmail,
        clientId: clientId,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Souscription reussie.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur souscription: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSubscribing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = widget.service.imageUrl;
    final isAsset =
        imageUrl.startsWith('asset:') || imageUrl.startsWith('lib/images/');
    final resolvedImage = imageUrl.startsWith('asset:')
        ? imageUrl.replaceFirst('asset:', '')
        : imageUrl;
    final hasImage = resolvedImage.isNotEmpty;
    final heroTag = 'service-${widget.service.id}';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Hero(
                tag: heroTag,
                child: hasImage
                    ? isAsset
                          ? Image.asset(resolvedImage, fit: BoxFit.cover)
                          : Image.network(
                              resolvedImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  child: const Center(child: Icon(Icons.image)),
                                );
                              },
                            )
                    : Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Center(child: Icon(Icons.image)),
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.service.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Chip(label: Text(widget.service.category)),
                      const SizedBox(width: 12),
                      Text(
                        '${widget.service.price.toStringAsFixed(0)} FC',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Description', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    widget.service.description.isEmpty
                        ? 'Aucune description fournie.'
                        : widget.service.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5D6F69),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Votre note', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      final starValue = index + 1;
                      return IconButton(
                        onPressed: () => _updateRating(starValue.toDouble()),
                        icon: Icon(
                          _rating >= starValue ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  PressableScale(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            child: Icon(Icons.person),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prestataire verifie',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Reponse rapide et note moyenne 4.8',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF6A7C76),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 48,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              label: 'Souscrire',
              icon: Icons.verified_outlined,
              isLoading: _isSubscribing,
              onPressed: _subscribe,
            ),
            const SizedBox(height: 10),
            CustomButton(
              label: 'Ouvrir le chat',
              icon: Icons.chat_bubble_outline,
              variant: ButtonVariant.outline,
              onPressed: () {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                final authController = AuthController(authProvider);
                final clientId = authController.currentUserId ?? '';
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      serviceId: widget.service.id,
                      clientId: clientId,
                      providerId: widget.service.createdBy,
                      providerName: widget.service.title,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
