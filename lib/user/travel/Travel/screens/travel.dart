import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/travel/Bus/screens/bus_screen.dart';
import 'package:hrtc/user/travel/Travel/provider/travel_Provider.dart';
import 'package:hrtc/user/travel/Travel/widgets/search_card.dart';
import 'package:hrtc/user/travel/flight/screens/flight_screen.dart';

class TravelScreen extends ConsumerStatefulWidget {
  const TravelScreen({super.key});
  @override
  ConsumerState<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends ConsumerState<TravelScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late AnimationController _headerAnimationController;
  late AnimationController _cardAnimationController;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerAnimationController.forward();
    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppSizes.init(context);
    final travelState = ref.watch(travelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimationLimiter(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            ref.read(travelProvider.notifier).reset();
            _cardAnimationController.reset();
            _cardAnimationController.forward();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Enhanced App Bar with gradient
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 0,
                expandedHeight: AppSizes.heightPercent(12),
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.travelGradient,
                    ),
                  ),
                  child: FlexibleSpaceBar(
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppSizes.paddingTiny),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.flight_takeoff,
                            color: Colors.white,
                            size: AppSizes.iconMedium,
                          ),
                        ),
                        SizedBox(width: AppSizes.paddingSmall),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Travel Services',
                              style: AppSizes.headingSmall.copyWith(
                                color: Colors.white,
                                fontSize: AppSizes.bodyLargeSize,
                              ),
                            ),
                            Text(
                              "Cu rrent Location",
                              style: AppSizes.bodySmall.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: AppSizes.bodySmallSize * 0.9,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    titlePadding: EdgeInsets.only(
                      left: AppSizes.paddingMedium,
                      bottom: AppSizes.paddingSmall,
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.only(right: AppSizes.paddingSmall),
                    child: IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(AppSizes.paddingTiny),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.white,
                          size: AppSizes.iconSmall,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: AppSizes.paddingMedium),
                    child: IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(AppSizes.paddingTiny),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                          size: AppSizes.iconSmall,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              // Search Section
              SliverToBoxAdapter(
                child: AnimationConfiguration.staggeredList(
                  position: 0,
                  duration: const Duration(milliseconds: 600),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: Transform.translate(
                        offset: const Offset(0, -20),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: SearchCard(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Quick Actions Section

              // Deals Section
              SliverToBoxAdapter(
                child: AnimationConfiguration.staggeredList(
                  position: 2,
                  duration: const Duration(milliseconds: 800),
                  child: SlideAnimation(
                    horizontalOffset: -50,
                    child: FadeInAnimation(
                      child: _buildDealsSection(travelState),
                    ),
                  ),
                ),
              ),

              // Popular Destinations
              SliverToBoxAdapter(
                child: AnimationConfiguration.staggeredList(
                  position: 3,
                  duration: const Duration(milliseconds: 900),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(child: _buildPopularDestinations()),
                  ),
                ),
              ),

              // Travel Tips
              SliverToBoxAdapter(
                child: AnimationConfiguration.staggeredList(
                  position: 4,
                  duration: const Duration(milliseconds: 1000),
                  child: SlideAnimation(
                    horizontalOffset: 50,
                    child: FadeInAnimation(child: _buildTravelTips()),
                  ),
                ),
              ),

              // Recent Searches
              SliverToBoxAdapter(
                child: AnimationConfiguration.staggeredList(
                  position: 5,
                  duration: const Duration(milliseconds: 1100),
                  child: SlideAnimation(
                    verticalOffset: 30,
                    child: FadeInAnimation(child: _buildRecentSearches()),
                  ),
                ),
              ),

              // Bottom padding
              SliverToBoxAdapter(
                child: SizedBox(height: AppSizes.verticalSpaceLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDealsSection(TravelState travelState) {
    final deals = [
      {
        'title': 'Flight Discounts: Up to 30% Off!',
        'desc': 'Book your flights now and save big',
        'price': 'From ₹2,499',
        'image':
            'https://plus.unsplash.com/premium_photo-1679830513886-e09cd6dc3137?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZmxpZ2h0fGVufDB8fDB8fHww',
        'gradient': AppColors.travelGradient,
      },
      {
        'title': 'Bus Tickets from ₹499',
        'desc': 'Travel affordably by bus',
        'price': 'Starting ₹499',
        'image':
            'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8YnVzfGVufDB8fDB8fHww',
        'gradient': AppColors.hrtcgradient,
      },
      {
        'title': 'Weekend Getaway Packages',
        'desc': 'Perfect for quick escapes',
        'price': 'From ₹1,999',
        'image':
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&auto=format&fit=crop&q=60',
        'gradient': AppColors.hotelsGradient,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSizes.paddingAllMedium,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Hot Deals', style: AppSizes.headingSmall),
              Text(
                'View All',
                style: AppSizes.bodyMedium.copyWith(
                  color: AppColors.travelAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        CarouselSlider.builder(
          options: CarouselOptions(
            height: AppSizes.heightPercent(22),
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
          ),
          itemCount: deals.length,
          itemBuilder: (context, index, realIndex) {
            final deal = deals[index];
            return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingTiny,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: AppSizes.radiusMedium,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: AppSizes.elevationMedium,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: AppSizes.radiusMedium,
                    child: Stack(
                      children: [
                        // Background Image
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(deal['image'] as String),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                        // Content
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: AppSizes.paddingAllMedium,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.paddingSmall,
                                    vertical: AppSizes.paddingTiny,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: deal['gradient'] as List<Color>,
                                    ),
                                    borderRadius: AppSizes.radiusSmall,
                                  ),
                                  child: Text(
                                    deal['price'] as String,
                                    style: AppSizes.bodySmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSizes.verticalSpaceTiny),
                                Text(
                                  deal['title'] as String,
                                  style: AppSizes.bodyLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: AppSizes.verticalSpaceTiny),
                                Text(
                                  deal['desc'] as String,
                                  style: AppSizes.bodyMedium.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                SizedBox(height: AppSizes.verticalSpaceSmall),
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(travelProvider.notifier)
                                        .setTabIndex(index < 2 ? index : 0);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                index == 0 || index == 2
                                                    ? const FlightSearchScreen()
                                                    : const BusSearchScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppSizes.paddingMedium,
                                      vertical: AppSizes.paddingSmall,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: AppSizes.radiusMedium,
                                    ),
                                    child: Text(
                                      'Book Now',
                                      style: AppSizes.bodyMedium.copyWith(
                                        color: AppColors.travelAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .animate(delay: (index * 200).ms)
                .fadeIn(duration: 500.ms)
                .slideX(
                  begin: 0.3,
                  end: 0,
                  duration: 500.ms,
                  curve: Curves.easeOutQuad,
                );
          },
        ),
      ],
    );
  }

  Widget _buildPopularDestinations() {
    final destinations = [
      {
        'name': 'Delhi',
        'image':
            'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=400',
        'price': '₹2,499',
      },
      {
        'name': 'Mumbai',
        'image':
            'https://images.unsplash.com/photo-1595658658481-d53d3f999875?w=400',
        'price': '₹1,899',
      },
      {
        'name': 'Goa',
        'image':
            'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=400',
        'price': '₹3,299',
      },
      {
        'name': 'Bangalore',
        'image':
            'https://images.unsplash.com/photo-1596176530529-78163a4f7af2?w=400',
        'price': '₹2,199',
      },
    ];

    return Container(
      margin: EdgeInsets.only(top: AppSizes.verticalSpaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSizes.paddingHorizontalMedium,
            child: Text('Popular Destinations', style: AppSizes.headingSmall),
          ),
          SizedBox(height: AppSizes.verticalSpaceSmall),
          SizedBox(
            height: AppSizes.heightPercent(15),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: AppSizes.paddingHorizontalMedium,
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                return Container(
                      width: AppSizes.widthPercent(35),
                      margin: EdgeInsets.only(right: AppSizes.paddingMedium),
                      decoration: BoxDecoration(
                        borderRadius: AppSizes.radiusMedium,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: AppSizes.elevationMedium,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: AppSizes.radiusMedium,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(destination['image']!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: AppSizes.paddingSmall,
                              left: AppSizes.paddingSmall,
                              right: AppSizes.paddingSmall,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    destination['name']!,
                                    style: AppSizes.bodyMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'From ${destination['price']}',
                                    style: AppSizes.bodySmall.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate(delay: (index * 100).ms)
                    .fadeIn(duration: 500.ms)
                    .slideX(begin: 0.2, duration: 500.ms);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelTips() {
    final tips = [
      {
        'title': 'Best Time to Book',
        'desc': 'Book flights 6-8 weeks in advance for best deals',
      },
      {
        'title': 'Travel Light',
        'desc': 'Pack only essentials to avoid extra baggage fees',
      },
      {
        'title': 'Check Weather',
        'desc': 'Always check destination weather before traveling',
      },
    ];

    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMedium),
      padding: AppSizes.paddingAllMedium,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppSizes.radiusMedium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppSizes.elevationMedium,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.warning,
                size: AppSizes.iconMedium,
              ),
              SizedBox(width: AppSizes.paddingSmall),
              Text('Travel Tips', style: AppSizes.headingSmall),
            ],
          ),
          SizedBox(height: AppSizes.verticalSpaceSmall),
          ...tips
              .map(
                (tip) => Container(
                  margin: EdgeInsets.only(bottom: AppSizes.verticalSpaceSmall),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppSizes.paddingTiny,
                        height: AppSizes.paddingTiny,
                        margin: EdgeInsets.only(
                          top: AppSizes.paddingTiny,
                          right: AppSizes.paddingSmall,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.travelAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip['title']!,
                              style: AppSizes.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(tip['desc']!, style: AppSizes.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    ).animate().slideY(begin: 0.1, duration: 600.ms).fadeIn();
  }

  Widget _buildRecentSearches() {
    final recentSearches = [
      {'from': 'Delhi', 'to': 'Mumbai', 'date': 'Jun 15'},
      {'from': 'Bangalore', 'to': 'Chennai', 'date': 'Jun 20'},
    ];

    if (recentSearches.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: AppSizes.paddingAllMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Searches', style: AppSizes.headingSmall),
          SizedBox(height: AppSizes.verticalSpaceSmall),
          ...recentSearches
              .map(
                (search) => Container(
                  margin: EdgeInsets.only(bottom: AppSizes.verticalSpaceSmall),
                  padding: AppSizes.paddingAllMedium,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: AppSizes.radiusMedium,
                    border: Border.all(
                      color: AppColors.textLight.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: AppColors.textSecondary,
                        size: AppSizes.iconSmall,
                      ),
                      SizedBox(width: AppSizes.paddingMedium),
                      Expanded(
                        child: Text(
                          '${search['from']} → ${search['to']} • ${search['date']}',
                          style: AppSizes.bodyMedium,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textLight,
                        size: AppSizes.iconTiny,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}
