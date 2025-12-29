import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/brijguid/provider/brajdarshan_provider.dart';
import 'package:hrtc/user/brijguid/screens/search_guid_screen.dart';
import 'package:hrtc/user/brijguid/screens/search_temple_screen.dart';

import 'package:hrtc/user/brijguid/widgets/tour_card.dart';
import '../widgets/temple_card.dart';
import '../widgets/hero_section.dart';
import '../widgets/section_header.dart';

class BrajDarshanScreen extends ConsumerStatefulWidget {
  const BrajDarshanScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BrajDarshanScreen> createState() => _BrajDarshanScreenState();
}

class _BrajDarshanScreenState extends ConsumerState<BrajDarshanScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _contentController;
  late Animation<double> _heroAnimation;
  late Animation<double> _contentAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heroAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutQuart),
    );

    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutQuart),
    );

    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final state = ref.watch(brajDarshanProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body:
          state.isLoading
              ? _buildLoadingScreen()
              : CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  SliverToBoxAdapter(
                    child: SizedBox(height: AppSizes.verticalSpaceMedium),
                  ),

                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _heroAnimation,
                      child: const HeroSection(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _contentAnimation,
                        child: _buildContent(state),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppSizes.iconExtraLarge * 2,
            height: AppSizes.iconExtraLarge * 2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.servicesGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppSizes.radiusCircular,
            ),
            child: Icon(
              Icons.temple_hindu,
              size: AppSizes.iconExtraLarge,
              color: Colors.white,
            ),
          ),
          AppSizes.verticalSpaceMediumBox,
          Text(
            'Loading Braj Darshan...',
            style: AppSizes.bodyLarge.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: AppSizes.screenHeight * 0.12,
      floating: false,
      pinned: true,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.servicesGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: AppSizes.paddingAllMedium,
              child: Row(
                children: [
                  Container(
                    padding: AppSizes.paddingAllSmall,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: AppSizes.radiusSmall,
                    ),
                    child: Icon(
                      Icons.temple_hindu,
                      size: AppSizes.iconMedium,
                      color: Colors.white,
                    ),
                  ),
                  AppSizes.horizontalSpaceMediumBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Braj Darshan',
                          style: AppSizes.headingMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Spiritual Journey Awaits',
                          style: AppSizes.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: AppSizes.paddingAllSmall,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: AppSizes.radiusSmall,
                      ),
                      child: Icon(
                        Icons.search,
                        size: AppSizes.iconMedium,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BrajDarshanState state) {
    return Column(
      children: [
        AppSizes.verticalSpaceMediumBox,
        _buildTempleSection(state),
        AppSizes.verticalSpaceLargeBox,
        _buildTourGuideSection(state),
        AppSizes.verticalSpaceExtraLargeBox,
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildTempleSection(BrajDarshanState state) {
    return Container(
      margin: AppSizes.paddingHorizontalMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Sacred Temples',
            subtitle: 'Discover Divine Heritage',
            icon: Icons.temple_hindu,
            onSeeAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          AppSizes.verticalSpaceSmallBox,
          SizedBox(
            height: AppSizes.screenHeight * 0.42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: AppSizes.paddingSmall),
              itemCount: state.temples.length,
              itemBuilder: (context, index) {
                final temple = state.temples[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: AppSizes.paddingMedium,
                    bottom: 8,
                  ),
                  child: TempleCard(
                    temple: temple,
                    isFavorite: state.favoriteTemples.contains(temple.id),
                    onFavoriteToggle: () {
                      ref
                          .read(brajDarshanProvider.notifier)
                          .toggleFavorite(temple.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTourGuideSection(BrajDarshanState state) {
    return Container(
      margin: AppSizes.paddingHorizontalMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Expert Tour Guides',
            subtitle: 'Your Spiritual Companions',
            icon: Icons.person_pin,
            onSeeAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchGuideScreen(),
                ),
              );
            },
          ),
          AppSizes.verticalSpaceSmallBox,
          SizedBox(
            height: AppSizes.screenHeight * 0.48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: AppSizes.paddingSmall),
              itemCount: state.tourGuides.length,
              itemBuilder: (context, index) {
                final guide = state.tourGuides[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: AppSizes.paddingMedium,
                    bottom: 10,
                  ),
                  child: TourGuideCard(
                    guide: guide,
                    isSelected: state.selectedGuideId == guide.id,
                    onTap: () {
                      ref
                          .read(brajDarshanProvider.notifier)
                          .selectGuide(guide.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
