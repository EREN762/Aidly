import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/service_controller.dart';
import '../models/service_model.dart';
import 'service_detail_screen.dart';
import 'widgets/app_spacing.dart';
import 'widgets/floating_search_bar.dart';
import 'widgets/section_header.dart';
import 'widgets/service_card.dart';
import 'widgets/shimmer_box.dart';
import 'widgets/view_transitions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  late final ServiceController _serviceController;
  String _query = '';
  late final PageController _pageController;
  int _carouselIndex = 0;
  Timer? _carouselTimer;

  final List<_CarouselItem> _carouselItems = const [
    _CarouselItem(
      imagePath: 'lib/images/architecte.jpg',
      title: 'Des talents de proximite',
      subtitle: 'Trouvez un aide de confiance pres de chez vous.',
    ),
    _CarouselItem(
      imagePath: 'lib/images/young-thoughtful.jpg',
      title: 'Une aide sur mesure',
      subtitle: 'Des services adaptes a votre quotidien.',
    ),
    _CarouselItem(
      imagePath: 'lib/images/black-worker.jpg',
      title: 'Gagnez du temps',
      subtitle: 'Passez a l action en quelques clics.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _serviceController = ServiceController();
    _pageController = PageController(viewportFraction: 0.88);
    _carouselTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final nextIndex = (_carouselIndex + 1) % _carouselItems.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    _carouselTimer?.cancel();
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour';
    if (hour < 18) return 'Bon apres-midi';
    return 'Bonsoir';
  }

  List<ServiceModel> _filterServices(List<ServiceModel> services) {
    if (_query.trim().isEmpty) return services;
    final lowered = _query.toLowerCase();
    return services.where((service) {
      final title = service.title.toLowerCase();
      final category = service.category.toLowerCase();
      return title.contains(lowered) || category.contains(lowered);
    }).toList();
  }

  List<ServiceModel> _mockServices() {
    final now = DateTime.now();
    return [
      ServiceModel(
        id: 'mock-1',
        title: 'Bricolage express',
        description: 'Montage, fixations et petites reparations.',
        price: 8000,
        imageUrl: 'asset:lib/images/renovateur, batissuer.jpg',
        imageProfileUrl: '',
        category: 'Bricolage',
        subCategory: 'Menuiserie',
        location: 'Gombe',
        rating: 4.7,
        reviewsCount: 12,
        createdAt: now,
        updatedAt: now,
        createdBy: 'mock',
        updatedBy: 'mock',
      ),
      ServiceModel(
        id: 'mock-2',
        title: 'Cours particuliers',
        description: 'Mathematiques et sciences pour lyceens.',
        price: 12000,
        imageUrl: 'asset:lib/images/informaticien.jpeg',
        imageProfileUrl: '',
        category: 'Cours particuliers',
        subCategory: 'Maths',
        location: 'Lingwala',
        rating: 4.9,
        reviewsCount: 24,
        createdAt: now,
        updatedAt: now,
        createdBy: 'mock',
        updatedBy: 'mock',
      ),
      ServiceModel(
        id: 'mock-3',
        title: 'Jardinage chic',
        description: 'Tonte, entretien et amenagement.',
        price: 15000,
        imageUrl: 'asset:lib/images/gardener-apron.jpg',
        imageProfileUrl: '',
        category: 'Jardinage',
        subCategory: 'Entretien',
        location: 'Ngaliema',
        rating: 4.6,
        reviewsCount: 18,
        createdAt: now,
        updatedAt: now,
        createdBy: 'mock',
        updatedBy: 'mock',
      ),
      ServiceModel(
        id: 'mock-4',
        title: 'Menage premium',
        description: 'Nettoyage complet et rangement.',
        price: 10000,
        imageUrl: 'asset:lib/images/girl-with-buns.jpg',
        imageProfileUrl: '',
        category: 'Menage',
        subCategory: 'Nettoyage',
        location: 'Limete',
        rating: 4.8,
        reviewsCount: 31,
        createdAt: now,
        updatedAt: now,
        createdBy: 'mock',
        updatedBy: 'mock',
      ),
      ServiceModel(
        id: 'mock-5',
        title: 'Courses & livraisons',
        description: 'Livraison rapide et fiable.',
        price: 7000,
        imageUrl: 'asset:lib/images/closeup-shot.jpg',
        imageProfileUrl: '',
        category: 'Demarche et courses',
        subCategory: 'Livraison',
        location: 'Matete',
        rating: 4.5,
        reviewsCount: 9,
        createdAt: now,
        updatedAt: now,
        createdBy: 'mock',
        updatedBy: 'mock',
      ),
      ServiceModel(
        id: 'mock-6',
        title: 'Mecanicien group',
        description: 'Pour reparation de votre vehicule',
        price: 9000,
        imageUrl: 'asset:lib/images/mecanicienne.jpg',
        imageProfileUrl: '',
        category: 'Demarche et courses',
        subCategory: 'Administratif',
        location: 'Kalamu',
        rating: 4.5,
        reviewsCount: 6,
        createdAt: now,
        updatedAt: now,
        createdBy: 'mock',
        updatedBy: 'mock',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: AppSpacing.screen.copyWith(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF6A7C76),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Decouvrez Aidly',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.person_outline, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FloatingSearchBar(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  const SizedBox(height: 20),
                  _Carousel(
                    controller: _pageController,
                    items: _carouselItems,
                    onChanged: (index) => setState(() => _carouselIndex = index),
                  ),
                  const SizedBox(height: 10),
                  _CarouselIndicators(
                    length: _carouselItems.length,
                    activeIndex: _carouselIndex,
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(
                    title: 'Services pour vous',
                    actionLabel: 'Voir tout',
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<ServiceModel>>(
                stream: _serviceController.getServices(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _ShimmerGrid();
                  }
                  final data = snapshot.data ?? const <ServiceModel>[];
                  final source = data.isEmpty ? _mockServices() : data;
                  final services = _filterServices(source);

                  return ScrollConfiguration(
                    behavior: const _SmoothScrollBehavior(),
                    child: GridView.builder(
                      padding: AppSpacing.screen.copyWith(top: 0),
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return ServiceCard(
                          service: service,
                          onTap: () {
                            Navigator.of(context).push(
                              sharedAxisRoute(
                                page: ServiceDetailScreen(service: service),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppSpacing.screen.copyWith(top: 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Column(
          children: const [
            Expanded(child: ShimmerBox(height: double.infinity)),
            SizedBox(height: 10),
            ShimmerBox(height: 16, width: double.infinity),
            SizedBox(height: 6),
            ShimmerBox(height: 12, width: 120),
          ],
        );
      },
    );
  }
}

class _SmoothScrollBehavior extends ScrollBehavior {
  const _SmoothScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}

class _Carousel extends StatelessWidget {
  const _Carousel({
    required this.controller,
    required this.items,
    required this.onChanged,
  });

  final PageController controller;
  final List<_CarouselItem> items;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: controller,
        itemCount: items.length,
        physics: const BouncingScrollPhysics(),
        onPageChanged: onChanged,
        itemBuilder: (context, index) {
          final item = items[index];
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              double value = 1;
              if (controller.position.haveDimensions) {
                value = (1 - ((controller.page ?? index) - index).abs() * 0.08)
                    .clamp(0.92, 1.0);
              }
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.55),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CarouselIndicators extends StatelessWidget {
  const _CarouselIndicators({
    required this.length,
    required this.activeIndex,
  });

  final int length;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 20 : 6,
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFFB9C7C1),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}

class _CarouselItem {
  const _CarouselItem({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  final String imagePath;
  final String title;
  final String subtitle;
}
