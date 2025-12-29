import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/user/hotels/provider/hotel_provider.dart';
import 'package:hrtc/user/hotels/widgets/hotel_card.dart';
import 'package:hrtc/user/hotels/widgets/search_widgets.dart';
import 'package:intl/intl.dart';

class HotelsScreen extends ConsumerStatefulWidget {
  const HotelsScreen({super.key});

  @override
  ConsumerState<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends ConsumerState<HotelsScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late AnimationController _headerController;
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _listController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _listController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: AppColors.textPrimary,
              size: AppSizes.iconMedium,
            ),
            SizedBox(width: AppSizes.paddingSmall),
            Text(
              'Current Location',
              style: AppSizes.headingLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.headingLargeSize * 0.6,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
        SizedBox(height: AppSizes.verticalSpaceTiny),
        Text(
              'Discover amazing hotels at the best prices',
              style: AppSizes.bodyMedium.copyWith(
                color: AppColors.textPrimary.withOpacity(0.8),
                fontSize: AppSizes.bodyMediumSize * 0.9,
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: -0.2, end: 0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppSizes.init(context);
    final screenWidth = AppSizes.screenWidth;
    final screenHeight = AppSizes.screenHeight;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: _buildHeader(),
      ),
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: screenHeight * 0.52,
            floating: false,
            pinned: true,
            scrolledUnderElevation: 0,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedBuilder(
                animation: _headerController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, (1 - _headerController.value) * 20),
                    child: Opacity(
                      opacity: _headerController.value,
                      child: SearchWidget(
                        onSearch: (search) {
                          ref
                              .read(hotelStateProvider.notifier)
                              .setSearch(search);
                          context.push('/hotels/search');
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _listController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, (1 - _listController.value) * 20),
                  child: Opacity(
                    opacity: _listController.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppSizes.verticalSpaceSmall),
                        _buildFeaturedSection(screenWidth, screenHeight),
                        SizedBox(height: AppSizes.verticalSpaceSmall),
                        _buildSectionWithHeader(
                          title: 'Top Rated Hotels',
                          subtitle: 'Handpicked luxury stays',
                          hotels:
                              ref
                                  .watch(hotelStateProvider.notifier)
                                  .getTopRatedHotels(),
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          icon: Icons.star,
                        ),
                        _buildCitySection(
                          'Mumbai',
                          'Financial Capital',
                          screenWidth,
                          screenHeight,
                        ),
                        _buildCitySection(
                          'Goa',
                          'Beach Paradise',
                          screenWidth,
                          screenHeight,
                        ),
                        _buildCitySection(
                          'Delhi',
                          'Heritage Capital',
                          screenWidth,
                          screenHeight,
                        ),
                        _buildCitySection(
                          'Bangalore',
                          'Garden City',
                          screenWidth,
                          screenHeight,
                        ),
                        _buildCitySection(
                          'Jaipur',
                          'Pink City',
                          screenWidth,
                          screenHeight,
                        ),
                        SizedBox(height: AppSizes.verticalSpaceLarge),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection(double screenWidth, double screenHeight) {
    final featuredHotels =
        ref
            .watch(hotelStateProvider.notifier)
            .getTopRatedHotels()
            .take(3)
            .toList();

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSizes.verticalSpaceTiny),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.paddingSmall * 0.6),
                  decoration: BoxDecoration(
                    color: AppColors.hotelsAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.paddingSmall),
                  ),
                  child: Icon(
                    Icons.featured_play_list,
                    color: AppColors.hotelsAccent,
                    size: AppSizes.iconSmall,
                  ),
                ),
                SizedBox(width: AppSizes.paddingSmall),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Hotels',
                      style: AppSizes.headingMedium.copyWith(
                        fontSize: AppSizes.headingMediumSize * 0.85,
                      ),
                    ),
                    Text(
                      'Exclusive premium properties',
                      style: AppSizes.bodySmall.copyWith(
                        color: AppColors.textLight,
                        fontSize: AppSizes.bodySmallSize * 0.85,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
          SizedBox(height: AppSizes.verticalSpaceMedium),
          SizedBox(
            height: screenHeight * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
              itemCount: featuredHotels.length,
              itemBuilder:
                  (context, index) => Container(
                        margin: EdgeInsets.only(right: AppSizes.paddingMedium),
                        child: EnhancedHotelCard(
                          hotel: featuredHotels[index],
                          width: screenWidth * 0.6,
                          onTap: () {
                            ref
                                .read(hotelStateProvider.notifier)
                                .selectHotel(featuredHotels[index]);
                            context.push('/hotels/details');
                          },
                          isFeatured: true,
                        ),
                      )
                      .animate(delay: (100 * index).ms)
                      .fadeIn(duration: 400.ms)
                      .slideX(begin: 0.2, end: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWithHeader({
    required String title,
    required String subtitle,
    required List<Hotel> hotels,
    required double screenWidth,
    required double screenHeight,
    required IconData icon,
  }) {
    if (hotels.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSizes.verticalSpaceLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.paddingSmall * 0.6),
                  decoration: BoxDecoration(
                    color: AppColors.hotelsAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.paddingSmall),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.hotelsAccent,
                    size: AppSizes.iconSmall,
                  ),
                ),
                SizedBox(width: AppSizes.paddingSmall),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppSizes.headingMedium.copyWith(
                        fontSize: AppSizes.headingMediumSize * 0.85,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppSizes.bodySmall.copyWith(
                        color: AppColors.textLight,
                        fontSize: AppSizes.bodySmallSize * 0.85,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),
          SizedBox(height: AppSizes.verticalSpaceLarge),
          SizedBox(
            height: screenHeight * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
              itemCount: hotels.length,
              itemBuilder:
                  (context, index) => Container(
                        margin: EdgeInsets.only(right: AppSizes.paddingMedium),
                        child: EnhancedHotelCard(
                          hotel: hotels[index],
                          width: screenWidth * 0.6,
                          onTap: () {
                            ref
                                .read(hotelStateProvider.notifier)
                                .selectHotel(hotels[index]);
                            context.push('/hotels/details');
                          },
                        ),
                      )
                      .animate(delay: (80 * index).ms)
                      .fadeIn(duration: 400.ms)
                      .slideX(begin: 0.15, end: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitySection(
    String city,
    String description,
    double screenWidth,
    double screenHeight,
  ) {
    final hotels = ref.watch(hotelStateProvider.notifier).getHotelsByCity(city);
    if (hotels.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSizes.verticalSpaceTiny),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.paddingSmall * 0.6),
                  decoration: BoxDecoration(
                    color: AppColors.hotelsAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.paddingSmall),
                  ),
                  child: Icon(
                    Icons.location_city,
                    color: AppColors.hotelsAccent,
                    size: AppSizes.iconSmall,
                  ),
                ),
                SizedBox(width: AppSizes.paddingSmall),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Hotels in $city',
                      style: AppSizes.headingMedium.copyWith(
                        fontSize: AppSizes.headingMediumSize * 0.85,
                      ),
                    ),
                    Text(
                      description,
                      style: AppSizes.bodySmall.copyWith(
                        color: AppColors.textLight,
                        fontSize: AppSizes.bodySmallSize * 0.85,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),
          SizedBox(height: AppSizes.verticalSpaceTiny),
          SizedBox(
            height: screenHeight * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
              itemCount: hotels.length,
              itemBuilder:
                  (context, index) => Container(
                        margin: EdgeInsets.only(right: AppSizes.paddingMedium),
                        child: EnhancedHotelCard(
                          hotel: hotels[index],
                          width: screenWidth * 0.6,
                          onTap: () {
                            ref
                                .read(hotelStateProvider.notifier)
                                .selectHotel(hotels[index]);
                            context.push('/hotels/details');
                          },
                        ),
                      )
                      .animate(delay: (80 * index).ms)
                      .fadeIn(duration: 400.ms)
                      .slideX(begin: 0.15, end: 0),
            ),
          ),
        ],
      ),
    );
  }
}

class EnhancedHotelCard extends StatelessWidget {
  final Hotel hotel;
  final double width;
  final VoidCallback onTap;
  final bool isFeatured;

  const EnhancedHotelCard({
    super.key,
    required this.hotel,
    required this.width,
    required this.onTap,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.paddingMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.paddingMedium),
                    topRight: Radius.circular(AppSizes.paddingMedium),
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.paddingMedium),
                        topRight: Radius.circular(AppSizes.paddingMedium),
                      ),
                      child: Image.network(
                        hotel.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.hotelsAccent,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.hotel,
                                  size: AppSizes.iconLarge,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: AppSizes.verticalSpaceTiny),
                                Text(
                                  'Hotel Image',
                                  style: AppSizes.bodySmall.copyWith(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: AppSizes.paddingSmall,
                      right: AppSizes.paddingSmall,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingSmall * 0.8,
                          vertical: AppSizes.paddingTiny,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(
                            AppSizes.paddingSmall,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: AppSizes.iconTiny,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              hotel.rating.toString(),
                              style: AppSizes.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: AppSizes.bodySmallSize * 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isFeatured)
                      Positioned(
                        top: AppSizes.paddingSmall,
                        left: AppSizes.paddingSmall,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingSmall * 0.8,
                            vertical: AppSizes.paddingTiny,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.hotelsAccent,
                            borderRadius: BorderRadius.circular(
                              AppSizes.paddingSmall,
                            ),
                          ),
                          child: Text(
                            'FEATURED',
                            style: AppSizes.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: AppSizes.bodySmallSize * 0.7,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(AppSizes.paddingSmall * 1.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.name,
                      style: AppSizes.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: AppSizes.bodyLargeSize * 0.85,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSizes.verticalSpaceTiny * 0.5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: AppSizes.iconTiny,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            '${hotel.city} • ${hotel.address}',
                            style: AppSizes.bodySmall.copyWith(
                              color: Colors.grey[600],
                              fontSize: AppSizes.bodySmallSize * 0.75,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotel.pricePerNight,
                              style: AppSizes.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.hotelsAccent,
                                fontSize: AppSizes.bodyLargeSize * 0.85,
                              ),
                            ),
                            Text(
                              'per night',
                              style: AppSizes.bodySmall.copyWith(
                                color: Colors.grey[600],
                                fontSize: AppSizes.bodySmallSize * 0.7,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${hotel.reviews} reviews',
                          style: AppSizes.bodySmall.copyWith(
                            color: Colors.grey[600],
                            fontSize: AppSizes.bodySmallSize * 0.75,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
