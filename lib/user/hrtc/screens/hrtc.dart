import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hrtc/core/utils/colors.dart';


class HRTCScreen extends ConsumerStatefulWidget {
  const HRTCScreen({super.key});

  @override
  ConsumerState<HRTCScreen> createState() => _HRTCScreenState();
}

class _HRTCScreenState extends ConsumerState<HRTCScreen>
    with AutomaticKeepAliveClientMixin {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentBannerIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimationLimiter(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                elevation: 0,
                backgroundColor: AppColors.background,
                title: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: AppColors.hrtcAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.directions_bus_outlined,
                        color: AppColors.hrtcAccent,
                        size: screenWidth * 0.045,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Location',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                          Text(
                            'Mumbai, India',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: AppColors.textPrimary,
                      size: screenWidth * 0.06,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                      size: screenWidth * 0.06,
                    ),
                    onPressed: () {},
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(screenHeight * 0.08),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.01,
                    ),
                    child: Container(
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: screenWidth * 0.025,
                            offset: Offset(0, screenHeight * 0.006),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search bus routes, hotels, restaurants...',
                          hintStyle: TextStyle(
                            color: AppColors.textLight,
                            fontSize: screenWidth * 0.035,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.textLight,
                            size: screenWidth * 0.05,
                          ),
                          suffixIcon: Icon(
                            Icons.mic_none_outlined,
                            color: AppColors.textLight,
                            size: screenWidth * 0.05,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.018,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Main Content
              SliverToBoxAdapter(
                child: AnimationConfiguration.staggeredList(
                  position: 0,
                  duration: const Duration(milliseconds: 600),
                  child: SlideAnimation(
                    verticalOffset: screenHeight * 0.06,
                    child: FadeInAnimation(
                      child: Column(
                        children: [
                          _buildBannerCarousel(screenWidth, screenHeight),
                          _buildCategoryRow(screenWidth, screenHeight),
                          _buildSectionHeader(
                            'Special Bus Offers',
                            'View All',
                            screenWidth,
                            screenHeight,
                          ),
                          _buildSpecialOffers(screenWidth, screenHeight),
                          _buildSectionHeader(
                            'Popular Routes',
                            'View All',
                            screenWidth,
                            screenHeight,
                          ),
                          _buildPopularRoutes(screenWidth, screenHeight),
                          _buildSectionHeader(
                            'Recommended Trips',
                            'View All',
                            screenWidth,
                            screenHeight,
                          ),
                          _buildRecommendedTrips(screenWidth, screenHeight),
                          _buildSectionHeader(
                            'Top Hotels',
                            'View All',
                            screenWidth,
                            screenHeight,
                          ),
                          _buildTopHotels(screenWidth, screenHeight),
                          _buildSectionHeader(
                            'Top Restaurants',
                            'View All',
                            screenWidth,
                            screenHeight,
                          ),
                          _buildTopRestaurants(screenWidth, screenHeight),
                          _buildSectionHeader(
                            'Exclusive Deals',
                            'View All',
                            screenWidth,
                            screenHeight,
                          ),
                          _buildExclusiveDeals(screenWidth, screenHeight),
                          SizedBox(height: screenHeight * 0.1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(double screenWidth, double screenHeight) {
    const List<Color> bannerColors = [
      Color(0xFF2196F3),
      Color(0xFF4CAF50),
      Color(0xFFFF9800),
      Color(0xFFE91E63),
      Color(0xFF9C27B0),
    ];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider.builder(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: screenHeight * 0.2,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.9,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentBannerIndex = index;
                    });
                  },
                ),
                itemCount: bannerColors.length,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                        width: screenWidth * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.05,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              bannerColors[index],
                              bannerColors[index].withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: bannerColors[index].withOpacity(0.3),
                              blurRadius: screenWidth * 0.0375,
                              offset: Offset(0, screenHeight * 0.0125),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.05,
                                ),
                                child: Image.network(
                                  _getBannerImage(index),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _getBannerTitle(index),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    _getBannerSubtitle(index),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: screenWidth * 0.025,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.035,
                                      vertical: screenHeight * 0.01,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        screenWidth * 0.04,
                                      ),
                                    ),
                                    child: Text(
                                      'Book Now',
                                      style: TextStyle(
                                        color: bannerColors[index],
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.02,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideX(begin: 0.2, end: 0, duration: 500.ms);
                },
              ),
              Positioned(
                left: screenWidth * 0.04,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: screenWidth * 0.05,
                  ),
                  onPressed: () {
                    _carouselController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
              Positioned(
                right: screenWidth * 0.04,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: screenWidth * 0.05,
                  ),
                  onPressed: () {
                    _carouselController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(bannerColors.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.0075),
              height: screenHeight * 0.01,
              width:
                  _currentBannerIndex == index
                      ? screenWidth * 0.06
                      : screenWidth * 0.02,
              decoration: BoxDecoration(
                color:
                    _currentBannerIndex == index
                        ? AppColors.hrtcAccent
                        : AppColors.hrtcAccent.withOpacity(0.3),
                borderRadius: BorderRadius.circular(screenWidth * 0.01),
              ),
            );
          }),
        ),
      ],
    );
  }

  String _getBannerImage(int index) {
    switch (index) {
      case 0:
        return 'https://images.unsplash.com/photo-1694153491501-17be957f472f?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8bW9uc29vbiUyMHRyYXZlbHxlbnwwfHwwfHx8MA%3D%3D';
      case 1:
        return 'https://images.unsplash.com/photo-1683615371127-eaaf4fc9c48b?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cyUyMHJvdXRlfGVufDB8fDB8fHww';
      case 2:
        return 'https://images.unsplash.com/photo-1606046604972-77cc76aee944?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8aG90ZWxzfGVufDB8fDB8fHww';
      case 3:
        return 'https://plus.unsplash.com/premium_photo-1723491285855-f1035c4c703c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8UmVzdGF1cmVudHN8ZW58MHx8MHx8fDA%3D';
      case 4:
        return 'https://images.unsplash.com/photo-1454388683759-ee76c15fee26?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8aG90ZWxzfGVufDB8fDB8fHww';
      default:
        return 'https://images.unsplash.com/photo-1454388683759-ee76c15fee26?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8aG90ZWxzfGVufDB8fDB8fHww';
    }
  }

  String _getBannerTitle(int index) {
    switch (index) {
      case 0:
        return "Monsoon Travel Deals";
      case 1:
        return "Express Bus Routes";
      case 2:
        return "Luxury Hotel Stays";
      case 3:
        return "Top Dining Experiences";
      case 4:
        return "Group Booking Discounts";
      default:
        return "Explore More";
    }
  }

  String _getBannerSubtitle(int index) {
    switch (index) {
      case 0:
        return "Up to 30% off on select routes";
      case 1:
        return "Fast and reliable bus services";
      case 2:
        return "Book 5-star hotels at great prices";
      case 3:
        return "Discover top-rated restaurants";
      case 4:
        return "Save more with group tickets";
      default:
        return "Discover amazing deals";
    }
  }

  Widget _buildCategoryRow(double screenWidth, double screenHeight) {
    const List<Map<String, dynamic>> categories = [
      {
        'icon': Icons.directions_bus_outlined,
        'color': AppColors.hrtcAccent,
        'name': 'City Routes',
      },
      {
        'icon': Icons.nightlight_round,
        'color': AppColors.travelAccent,
        'name': 'Night Buses',
      },
      {
        'icon': Icons.group_outlined,
        'color': AppColors.restaurantsAccent,
        'name': 'Group Travel',
      },
      {
        'icon': Icons.card_giftcard_outlined,
        'color': AppColors.hotelsAccent,
        'name': 'Special Offers',
      },
      {
        'icon': Icons.star_border_outlined,
        'color': Colors.amber,
        'name': 'Premium Buses',
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
      height: screenHeight * 0.125,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Column(
              children: [
                Container(
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
                      decoration: BoxDecoration(
                        color: categories[index]['color'].withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        categories[index]['icon'],
                        color: categories[index]['color'],
                        size: screenWidth * 0.075,
                      ),
                    )
                    .animate(delay: (100 * index).ms)
                    .fadeIn(duration: 500.ms)
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.0, 1.0),
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  categories[index]['name'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String actionText,
    double screenWidth,
    double screenHeight,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              actionText,
              style: TextStyle(
                color: AppColors.hrtcAccent,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.035,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialOffers(double screenWidth, double screenHeight) {
    const List<Map<String, dynamic>> offers = [
      {
        'title': '20% OFF',
        'subtitle': 'On intercity routes',
        'color': AppColors.hrtcAccent,
        'icon': Icons.directions_bus_outlined,
      },
      {
        'title': 'Free Upgrade',
        'subtitle': 'To premium buses',
        'color': AppColors.travelAccent,
        'icon': Icons.star_border_outlined,
      },
      {
        'title': 'Group Discount',
        'subtitle': 'For 5+ passengers',
        'color': AppColors.restaurantsAccent,
        'icon': Icons.group_outlined,
      },
    ];

    return SizedBox(
      height: screenHeight * 0.2,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        itemBuilder: (context, index) {
          return Container(
                width: screenWidth * 0.7,
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: offers[index]['color'].withOpacity(0.15),
                      blurRadius: screenWidth * 0.025,
                      offset: Offset(0, screenHeight * 0.006),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: screenWidth * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(screenWidth * 0.04),
                          bottomLeft: Radius.circular(screenWidth * 0.04),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            offers[index]['color'],
                            offers[index]['color'].withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          offers[index]['icon'],
                          size: screenWidth * 0.1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              offers[index]['title'],
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              offers[index]['subtitle'],
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenHeight * 0.0075,
                              ),
                              decoration: BoxDecoration(
                                color: offers[index]['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.05,
                                ),
                              ),
                              child: Text(
                                'Book Now',
                                style: TextStyle(
                                  color: offers[index]['color'],
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * 0.03,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .animate(delay: (200 * index).ms)
              .fadeIn(duration: 500.ms)
              .slideX(begin: 50, end: 0, duration: 500.ms);
        },
      ),
    );
  }

  Widget _buildPopularRoutes(double screenWidth, double screenHeight) {
    const List<Map<String, dynamic>> routes = [
      {
        'name': 'Mumbai to Delhi',
        'rating': '4.8',
        'price': '₹1200',
        'color': AppColors.hrtcAccent,
        'icon': Icons.directions_bus_outlined,
      },
      {
        'name': 'Delhi to Shimla',
        'rating': '4.9',
        'price': '₹1500',
        'color': AppColors.travelAccent,
        'icon': Icons.directions_bus_outlined,
      },
      {
        'name': 'Mumbai to Goa',
        'rating': '4.7',
        'price': '₹1000',
        'color': AppColors.restaurantsAccent,
        'icon': Icons.directions_bus_outlined,
      },
      {
        'name': 'Chandigarh to Manali',
        'rating': '4.6',
        'price': '₹1800',
        'color': AppColors.hotelsAccent,
        'icon': Icons.directions_bus_outlined,
      },
    ];

    return SizedBox(
      height: screenHeight * 0.1875,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        scrollDirection: Axis.horizontal,
        itemCount: routes.length,
        itemBuilder: (context, index) {
          return Container(
                width: screenWidth * 0.4,
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: screenWidth * 0.025,
                      offset: Offset(0, screenHeight * 0.006),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color: routes[index]['color'].withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        routes[index]['icon'],
                        color: routes[index]['color'],
                        size: screenWidth * 0.07,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      routes[index]['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.035,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenHeight * 0.0075),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: screenWidth * 0.04,
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          routes[index]['rating'],
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Container(
                          width: 1,
                          height: screenHeight * 0.0125,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          routes[index]['price'],
                          style: TextStyle(
                            color: AppColors.hrtcAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .animate(delay: (150 * index).ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms);
        },
      ),
    );
  }

  Widget _buildRecommendedTrips(double screenWidth, double screenHeight) {
    const List<Map<String, dynamic>> trips = [
      {
        'name': 'Mumbai to Pune',
        'image':
            'https://plus.unsplash.com/premium_photo-1694475163305-69050e25af54?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8bXVtYmFpJTIwdG8lMjBwdW5lfGVufDB8fDB8fHww',
        'category': 'City Routes',
        'discount': '15% OFF',
        'price': '₹500',
      },
      {
        'name': 'Delhi to Agra',
        'image':
            'https://plus.unsplash.com/premium_photo-1697729441569-f706fdd1f71c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8YWdyYXxlbnwwfHwwfHx8MA%3D%3D',
        'category': 'Tourist Routes',
        'discount': '20% OFF',
        'price': '₹800',
      },
      {
        'name': 'Shimla to Manali',
        'image':
            'https://images.unsplash.com/photo-1712388429936-2abc7144083f?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fG1hbmFsaXxlbnwwfHwwfHx8MA%3D%3D',
        'category': 'Hill Routes',
        'discount': '10% OFF',
        'price': '₹1500',
      },
      {
        'name': 'Goa to Mumbai',
        'image':
            'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Z29hfGVufDB8fDB8fHww',
        'category': 'Coastal Routes',
        'discount': '25% OFF',
        'price': '₹1200',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: screenHeight * 0.015,
        crossAxisSpacing: screenWidth * 0.03,
        children: List.generate(trips.length, (index) {
          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: screenWidth * 0.025,
                        offset: Offset(0, screenHeight * 0.006),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(screenWidth * 0.04),
                              topRight: Radius.circular(screenWidth * 0.04),
                            ),
                            child: Image.network(
                              trips[index]['image'],
                              height: screenHeight * 0.1625,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: screenHeight * 0.1625,
                                  color: AppColors.background,
                                  child: Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: AppColors.textLight,
                                      size: screenWidth * 0.06,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: screenHeight * 0.01,
                            right: screenWidth * 0.02,
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.015),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                color: AppColors.hrtcAccent,
                                size: screenWidth * 0.04,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical: screenHeight * 0.005,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(
                                      trips[index]['category'],
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      screenWidth * 0.01,
                                    ),
                                  ),
                                  child: Text(
                                    trips[index]['category'],
                                    style: TextStyle(
                                      color: _getCategoryColor(
                                        trips[index]['category'],
                                      ),
                                      fontSize: screenWidth * 0.025,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical: screenHeight * 0.005,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.hrtcAccent.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      screenWidth * 0.01,
                                    ),
                                  ),
                                  child: Text(
                                    trips[index]['discount'],
                                    style: TextStyle(
                                      color: AppColors.hrtcAccent,
                                      fontSize: screenWidth * 0.025,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              trips[index]['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.035,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              trips[index]['price'],
                              style: TextStyle(
                                color: AppColors.hrtcAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .animate(delay: (100 * index).ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.2, end: 0, duration: 400.ms),
          );
        }),
      ),
    );
  }

  Widget _buildTopHotels(double screenWidth, double screenHeight) {
    const List<Map<String, dynamic>> hotels = [
      {
        'name': 'Taj Palace',
        'location': 'Mumbai',
        'rating': '4.9',
        'price': '₹8500',
        'image':
            'https://images.unsplash.com/photo-1712472256854-48b7b966a6e9?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHRhaiUyMHBhbGFjZSUyMG11bWJhaXxlbnwwfHwwfHx8MA%3D%3D',
      },
      {
        'name': 'Oberoi Udaivilas',
        'location': 'Udaipur',
        'rating': '4.8',
        'price': '₹12000',
        'image':
            'https://media.istockphoto.com/id/1269538102/photo/city-palace-in-udaipur-india.webp?a=1&b=1&s=612x612&w=0&k=20&c=qjcrm1jrFbP-DaKs1i06gOZ5RZJIsAxd9MBNJpXC_ds=',
      },
      {
        'name': 'Leela Palace',
        'location': 'Delhi',
        'rating': '4.7',
        'price': '₹9500',
        'image':
            'https://plus.unsplash.com/premium_photo-1694475143306-aafbdaefa042?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8TGVlbGElMjBQYWxhY2V8ZW58MHx8MHx8fDA%3D',
      },
    ];

    return SizedBox(
      height: screenHeight * 0.28,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        scrollDirection: Axis.horizontal,
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          return Container(
                width: screenWidth * 0.45,
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: screenWidth * 0.025,
                      offset: Offset(0, screenHeight * 0.006),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(screenWidth * 0.04),
                      ),
                      child: Image.network(
                        hotels[index]['image'],
                        height: screenHeight * 0.15,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: screenHeight * 0.15,
                            color: AppColors.background,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.textLight,
                                size: screenWidth * 0.06,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotels[index]['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.035,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            hotels[index]['location'],
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: screenWidth * 0.03,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: screenWidth * 0.04,
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Text(
                                    hotels[index]['rating'],
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                hotels[index]['price'],
                                style: TextStyle(
                                  color: AppColors.hrtcAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.03,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate(delay: (150 * index).ms)
              .fadeIn(duration: 400.ms)
              .slideX(begin: 0.2, end: 0, duration: 400.ms);
        },
      ),
    );
  }

  Widget _buildTopRestaurants(double screenWidth, double screenHeight) {
    const List<Map<String, dynamic>> restaurants = [
      {
        'name': 'The Bombay Canteen',
        'cuisine': 'Indian Fusion',
        'rating': '4.8',
        'image':
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHN8ZW58MHx8MHx8fDA%3D',
      },
      {
        'name': 'Masala Library',
        'cuisine': 'Modern Indian',
        'rating': '4.7',
        'image':
            'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8cmVzdGF1cmFudHN8ZW58MHx8MHx8fDA%3D',
      },
      {
        'name': 'Olive Bar & Kitchen',
        'cuisine': 'Mediterranean',
        'rating': '4.6',
        'image':
            'https://media.istockphoto.com/id/1198743919/photo/rooftop-restaurant.webp?a=1&b=1&s=612x612&w=0&k=20&c=4YDP7Kbl4rRFcF88sIP6VCxNU_GyDfoKBR39xv0CnBk=',
      },
    ];

    return SizedBox(
      height: screenHeight * 0.28,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        scrollDirection: Axis.horizontal,
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return Container(
                width: screenWidth * 0.45,
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: screenWidth * 0.025,
                      offset: Offset(0, screenHeight * 0.006),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(screenWidth * 0.04),
                      ),
                      child: Image.network(
                        restaurants[index]['image'],
                        height: screenHeight * 0.15,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: screenHeight * 0.15,
                            color: AppColors.background,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.textLight,
                                size: screenWidth * 0.06,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurants[index]['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.035,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            restaurants[index]['cuisine'],
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: screenWidth * 0.03,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: screenWidth * 0.04,
                              ),
                              SizedBox(width: screenWidth * 0.01),
                              Text(
                                restaurants[index]['rating'],
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate(delay: (150 * index).ms)
              .fadeIn(duration: 400.ms)
              .slideX(begin: 0.2, end: 0, duration: 400.ms);
        },
      ),
    );
  }

  Widget _buildExclusiveDeals(double screenWidth, double screenHeight) {
    const List<Map<String, dynamic>> deals = [
      {
        'title': 'Weekend Getaways',
        'subtitle': 'Save up to 25% on short trips',
        'image':
            'https://images.unsplash.com/photo-1716481731194-67a27f868c23?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8V2Vla2VuZCUyMEdldGF3YXlzJ3xlbnwwfHwwfHx8MA%3D%3D',
      },
      {
        'title': 'Festival Specials',
        'subtitle': 'Exclusive routes for celebrations',
        'image':
            'https://images.unsplash.com/photo-1667831617890-458ca443d799?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGRpd2FsaSUyMGthc2hpfGVufDB8fDB8fHww',
      },
      {
        'title': 'Luxury Buses',
        'subtitle': 'Premium comfort at great prices',
        'image':
            'https://images.unsplash.com/photo-1707051296951-fa444398dbe5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8bHV4dXJ5JTIwYnVzZXN8ZW58MHx8MHx8fDA%3D',
      },
    ];

    return SizedBox(
      height: screenHeight * 0.15,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        scrollDirection: Axis.horizontal,
        itemCount: deals.length,
        itemBuilder: (context, index) {
          return Container(
                width: screenWidth * 0.5,
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  color: AppColors.cardBackground,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(screenWidth * 0.03),
                      ),
                      child: Image.network(
                        deals[index]['image'],
                        width: screenWidth * 0.2,
                        height: screenHeight * 0.15,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: screenWidth * 0.2,
                            height: screenHeight * 0.15,
                            color: AppColors.background,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.textLight,
                                size: screenWidth * 0.06,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              deals[index]['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.035,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              deals[index]['subtitle'],
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: screenWidth * 0.03,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .animate(delay: (150 * index).ms)
              .fadeIn(duration: 400.ms)
              .slideX(begin: 0.2, end: 0, duration: 400.ms);
        },
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'City Routes':
        return AppColors.hrtcAccent;
      case 'Tourist Routes':
        return AppColors.travelAccent;
      case 'Hill Routes':
        return AppColors.restaurantsAccent;
      case 'Coastal Routes':
        return AppColors.hotelsAccent;
      default:
        return AppColors.hrtcAccent;
    }
  }
}
