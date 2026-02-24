import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/service_controller.dart';
import '../models/service_model.dart';
import '../providers/theme_provider.dart';
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
  final _gridController = ScrollController();
  late final ServiceController _serviceController;
  String _query = '';
  String? _selectedCategory;

  final List<_CarouselItem> _carouselItems = const [
    _CarouselItem(
      imagePath: 'lib/images/architecte.jpg',
      title: 'Des talents de proximite',
      subtitle: 'Trouvez un aide de confiance pres de chez vous.',
    ),
    _CarouselItem(
      imagePath: 'lib/images/jardinier.jpg',
      title: 'Une aide sur mesure',
      subtitle: 'Des services adaptes a votre quotidien.',
    ),
    _CarouselItem(
      imagePath: 'lib/images/black-teleworker.jpg',
      title: 'Gagnez du temps',
      subtitle: 'Passez a l action en quelques clics.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _serviceController = ServiceController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _gridController.dispose();
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour';
    if (hour < 18) return 'Bon apres-midi';
    return 'Bonsoir';
  }

  List<ServiceModel> _filterServices(List<ServiceModel> services) {
    final lowered = _query.toLowerCase();
    return services.where((service) {
      final title = service.title.toLowerCase();
      final category = service.category.toLowerCase();
      final matchesQuery = lowered.isEmpty ||
          title.contains(lowered) ||
          category.contains(lowered);
      final matchesCategory = _selectedCategory == null ||
          _selectedCategory!.isEmpty ||
          service.category == _selectedCategory;
      return matchesQuery && matchesCategory;
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
        title: 'Mecanique express',
        description: 'Diagnostic et reparation de votre vehicule.',
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
    final themeProvider = Provider.of<ThemeProvider>(context);

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
                      Row(
                        children: [
                          _ThemeToggleButton(
                            isDark: themeProvider.isDark,
                            onTap: themeProvider.toggle,
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.person_outline, size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FloatingSearchBar(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  const SizedBox(height: 20),
                  _CarouselSection(items: _carouselItems),
                  const SizedBox(height: 24),
                  _QuickActions(
                    selectedCategory: _selectedCategory,
                    onSelected: (value) {
                      setState(() {
                        if (_selectedCategory == value) {
                          _selectedCategory = null;
                        } else {
                          _selectedCategory = value;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 18),
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
                      key: const PageStorageKey('home-services-grid'),
                      controller: _gridController,
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

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton({
    required this.isDark,
    required this.onTap,
  });

  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1D2A27)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? const Color(0xFF2AB38A)
              : Theme.of(context).colorScheme.primary.withOpacity(0.18),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: Icon(
            isDark ? Icons.nights_stay_rounded : Icons.light_mode_rounded,
            key: ValueKey(isDark),
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.selectedCategory,
    required this.onSelected,
  });

  final String? selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _QuickChip(
            icon: Icons.handyman_outlined,
            label: 'Bricolage',
            isSelected: selectedCategory == 'Bricolage',
            onTap: () => onSelected('Bricolage'),
          ),
          _QuickChip(
            icon: Icons.local_florist_outlined,
            label: 'Jardinage',
            isSelected: selectedCategory == 'Jardinage',
            onTap: () => onSelected('Jardinage'),
          ),
          _QuickChip(
            icon: Icons.menu_book_outlined,
            label: 'Cours',
            isSelected: selectedCategory == 'Cours particuliers',
            onTap: () => onSelected('Cours particuliers'),
          ),
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.15)
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
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

class _CarouselSection extends StatefulWidget {
  const _CarouselSection({required this.items});

  final List<_CarouselItem> items;

  @override
  State<_CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<_CarouselSection> {
  late final PageController _controller;
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88);
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted || !_controller.hasClients) return;
      final nextIndex = (_index + 1) % widget.items.length;
      _controller.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Carousel(
          controller: _controller,
          items: widget.items,
          onChanged: (index) => setState(() => _index = index),
        ),
        const SizedBox(height: 10),
        _CarouselIndicators(
          length: widget.items.length,
          activeIndex: _index,
        ),
      ],
    );
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
      height: 200,
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
                        alignment: Alignment.topCenter,
                        filterQuality: FilterQuality.medium,
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.55),
                                Colors.transparent,
                                Colors.black.withOpacity(0.35),
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                        ),
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
