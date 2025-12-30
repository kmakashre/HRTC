// // import 'package:flutter/material.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// // import 'package:hrtc/core/utils/colors.dart';
// //
// // class RestaurantsScreen extends ConsumerStatefulWidget {
// //   const RestaurantsScreen({super.key});
// //
// //   @override
// //   ConsumerState<RestaurantsScreen> createState() => _RestaurantsScreenState();
// // }
// //
// // class _RestaurantsScreenState extends ConsumerState<RestaurantsScreen>
// //     with AutomaticKeepAliveClientMixin {
// //   @override
// //   bool get wantKeepAlive => true;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     super.build(context);
// //     final screenWidth = MediaQuery.of(context).size.width;
// //     final screenHeight = MediaQuery.of(context).size.height;
// //
// //     return Scaffold(
// //       body: AnimationLimiter(
// //         child: RefreshIndicator(
// //           onRefresh: () async {
// //             await Future.delayed(const Duration(seconds: 1));
// //           },
// //           child: CustomScrollView(
// //             physics: const BouncingScrollPhysics(),
// //             slivers: [
// //               // App Bar
// //               SliverAppBar(
// //                 floating: true,
// //                 elevation: 0,
// //                 backgroundColor: AppColors.background,
// //                 title: Row(
// //                   children: [
// //                     Container(
// //                       padding: EdgeInsets.all(screenWidth * 0.02),
// //                       decoration: BoxDecoration(
// //                         color: AppColors.restaurantsAccent.withOpacity(0.1),
// //                         shape: BoxShape.circle,
// //                       ),
// //                       child: Icon(
// //                         Icons.restaurant_outlined,
// //                         color: AppColors.restaurantsAccent,
// //                         size: screenWidth * 0.045,
// //                       ),
// //                     ),
// //                     SizedBox(width: screenWidth * 0.02),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             'Your Location',
// //                             style: TextStyle(
// //                               color: AppColors.textLight,
// //                               fontSize: screenWidth * 0.03,
// //                             ),
// //                           ),
// //                           Text(
// //                             'Mumbai, India',
// //                             style: TextStyle(
// //                               color: AppColors.textPrimary,
// //                               fontSize: screenWidth * 0.035,
// //                               fontWeight: FontWeight.w600,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 actions: [
// //                   IconButton(
// //                     icon: Icon(
// //                       Icons.search,
// //                       color: AppColors.textPrimary,
// //                       size: screenWidth * 0.06,
// //                     ),
// //                     onPressed: () {},
// //                   ),
// //                   IconButton(
// //                     icon: Icon(
// //                       Icons.filter_list_outlined,
// //                       color: AppColors.textPrimary,
// //                       size: screenWidth * 0.06,
// //                     ),
// //                     onPressed: () {},
// //                   ),
// //                 ],
// //                 bottom: PreferredSize(
// //                   preferredSize: Size.fromHeight(screenHeight * 0.06),
// //                   child: Container(
// //                     height: screenHeight * 0.06,
// //                     padding: EdgeInsets.symmetric(
// //                       horizontal: screenWidth * 0.04,
// //                     ),
// //                     child: ListView(
// //                       scrollDirection: Axis.horizontal,
// //                       children: [
// //                         _buildFilterChip('All', screenWidth, screenHeight),
// //                         _buildFilterChip(
// //                           'Fine Dining',
// //                           screenWidth,
// //                           screenHeight,
// //                         ),
// //                         _buildFilterChip('Casual', screenWidth, screenHeight),
// //                         _buildFilterChip('Cafes', screenWidth, screenHeight),
// //                         _buildFilterChip(
// //                           'Street Food',
// //                           screenWidth,
// //                           screenHeight,
// //                         ),
// //                         _buildFilterChip(
// //                           'Vegetarian',
// //                           screenWidth,
// //                           screenHeight,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //
// //               // Promotional Banner
// //               SliverToBoxAdapter(
// //                 child: _buildPromotionalBanner(screenWidth, screenHeight),
// //               ),
// //
// //               // Cuisine Categories
// //               SliverToBoxAdapter(
// //                 child: _buildSectionHeader(
// //                   'Cuisine Categories',
// //                   'View All',
// //                   screenWidth,
// //                   screenHeight,
// //                 ),
// //               ),
// //               SliverToBoxAdapter(
// //                 child: _buildCategoriesGrid(screenWidth, screenHeight),
// //               ),
// //
// //               // Top Rated Restaurants
// //               SliverToBoxAdapter(
// //                 child: _buildSectionHeader(
// //                   'Top Rated Restaurants',
// //                   'View All',
// //                   screenWidth,
// //                   screenHeight,
// //                 ),
// //               ),
// //               SliverToBoxAdapter(
// //                 child: _buildTopRatedRestaurantsCarousel(
// //                   screenWidth,
// //                   screenHeight,
// //                 ),
// //               ),
// //
// //               // Nearby Restaurants
// //               SliverToBoxAdapter(
// //                 child: _buildSectionHeader(
// //                   'Nearby Restaurants',
// //                   'View All',
// //                   screenWidth,
// //                   screenHeight,
// //                 ),
// //               ),
// //               SliverToBoxAdapter(
// //                 child: _buildNearbyRestaurantsCarousel(
// //                   screenWidth,
// //                   screenHeight,
// //                 ),
// //               ),
// //
// //               // Dining Deals
// //               SliverToBoxAdapter(
// //                 child: _buildSectionHeader(
// //                   'Dining Deals',
// //                   'View All',
// //                   screenWidth,
// //                   screenHeight,
// //                 ),
// //               ),
// //               SliverPadding(
// //                 padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
// //                 sliver: SliverGrid(
// //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                     crossAxisCount: 2,
// //                     childAspectRatio: 0.75,
// //                     crossAxisSpacing: screenWidth * 0.04,
// //                     mainAxisSpacing: screenHeight * 0.02,
// //                   ),
// //                   delegate: SliverChildBuilderDelegate(
// //                     (context, index) =>
// //                         _buildRestaurantCard(index, screenWidth, screenHeight),
// //                     childCount: 6,
// //                   ),
// //                 ),
// //               ),
// //
// //               // Footer space
// //               SliverToBoxAdapter(child: SizedBox(height: screenHeight * 0.025)),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFilterChip(
// //     String label,
// //     double screenWidth,
// //     double screenHeight,
// //   ) {
// //     final bool isSelected = label == 'All';
// //
// //     return Container(
// //       margin: EdgeInsets.only(right: screenWidth * 0.025),
// //       child: FilterChip(
// //         selected: isSelected,
// //         showCheckmark: false,
// //         backgroundColor: Colors.white,
// //         selectedColor: AppColors.restaurantsAccent.withOpacity(0.2),
// //         side: BorderSide(
// //           color:
// //               isSelected ? AppColors.restaurantsAccent : Colors.grey.shade300,
// //           width: 1,
// //         ),
// //         label: Text(
// //           label,
// //           style: TextStyle(
// //             color:
// //                 isSelected
// //                     ? AppColors.restaurantsAccent
// //                     : AppColors.textSecondary,
// //             fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
// //             fontSize: screenWidth * 0.035,
// //           ),
// //         ),
// //         onSelected: (bool selected) {
// //           // Handle filter selection
// //         },
// //       ),
// //     ).animate().fadeIn().slideX(
// //       begin: screenWidth * 0.075,
// //       end: 0,
// //       duration: 300.ms,
// //       delay: 100.ms,
// //     );
// //   }
// //
// //   Widget _buildPromotionalBanner(double screenWidth, double screenHeight) {
// //     return Container(
// //           margin: EdgeInsets.all(screenWidth * 0.04),
// //           height: screenHeight * 0.1875,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(screenWidth * 0.04),
// //             gradient: LinearGradient(
// //               colors: [
// //                 AppColors.restaurantsAccent,
// //                 AppColors.restaurantsAccent.withOpacity(0.7),
// //               ],
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //             ),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: AppColors.restaurantsAccent.withOpacity(0.3),
// //                 blurRadius: screenWidth * 0.0375,
// //                 offset: Offset(0, screenHeight * 0.0125),
// //               ),
// //             ],
// //           ),
// //           child: Stack(
// //             children: [
// //               Positioned(
// //                 right: -screenWidth * 0.05,
// //                 bottom: -screenHeight * 0.025,
// //                 child: Icon(
// //                   Icons.restaurant_outlined,
// //                   size: screenWidth * 0.375,
// //                   color: Colors.white.withOpacity(0.2),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: EdgeInsets.all(screenWidth * 0.05),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       'Gourmet Dining',
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: screenWidth * 0.055,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     SizedBox(height: screenHeight * 0.01),
// //                     Text(
// //                       'Reserve a table and save up to 30%',
// //                       style: TextStyle(
// //                         color: Colors.white.withOpacity(0.9),
// //                         fontSize: screenWidth * 0.035,
// //                       ),
// //                     ),
// //                     SizedBox(height: screenHeight * 0.02),
// //                     Container(
// //                       padding: EdgeInsets.symmetric(
// //                         horizontal: screenWidth * 0.05,
// //                         vertical: screenHeight * 0.01,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(screenWidth * 0.05),
// //                       ),
// //                       child: Text(
// //                         'Reserve Now',
// //                         style: TextStyle(
// //                           color: AppColors.restaurantsAccent,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: screenWidth * 0.035,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         )
// //         .animate()
// //         .fadeIn(duration: 600.ms)
// //         .slideY(
// //           begin: 0.2,
// //           end: 0,
// //           duration: 600.ms,
// //           curve: Curves.easeOutQuad,
// //         );
// //   }
// //
// //   Widget _buildSectionHeader(
// //     String title,
// //     String actionText,
// //     double screenWidth,
// //     double screenHeight,
// //   ) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(
// //         horizontal: screenWidth * 0.04,
// //         vertical: screenHeight * 0.02,
// //       ),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(
// //             title,
// //             style: TextStyle(
// //               fontSize: screenWidth * 0.045,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.textPrimary,
// //             ),
// //           ),
// //           Text(
// //             actionText,
// //             style: TextStyle(
// //               color: AppColors.restaurantsAccent,
// //               fontWeight: FontWeight.w600,
// //               fontSize: screenWidth * 0.035,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCategoriesGrid(double screenWidth, double screenHeight) {
// //     final List<Map<String, dynamic>> categories = [
// //       {'name': 'Indian', 'icon': Icons.restaurant_menu_outlined},
// //       {'name': 'Chinese', 'icon': Icons.rice_bowl_outlined},
// //       {'name': 'Italian', 'icon': Icons.local_pizza_outlined},
// //       {'name': 'Mexican', 'icon': Icons.fastfood_outlined},
// //       {'name': 'Desserts', 'icon': Icons.cake_outlined},
// //       {'name': 'Seafood', 'icon': Icons.set_meal_outlined},
// //       {'name': 'Vegan', 'icon': Icons.eco_outlined},
// //       {'name': 'BBQ', 'icon': Icons.outdoor_grill_outlined},
// //     ];
// //
// //     return Container(
// //       height: screenHeight * 0.25,
// //       margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
// //       child: GridView.builder(
// //         physics: const NeverScrollableScrollPhysics(),
// //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //           crossAxisCount: 4,
// //           mainAxisSpacing: screenHeight * 0.01875,
// //           crossAxisSpacing: screenWidth * 0.0375,
// //           childAspectRatio: 0.9,
// //         ),
// //         itemCount: categories.length,
// //         itemBuilder: (context, index) {
// //           return AnimationConfiguration.staggeredGrid(
// //             position: index,
// //             columnCount: 4,
// //             duration: const Duration(milliseconds: 500),
// //             delay: Duration(milliseconds: 100 * index),
// //             child: ScaleAnimation(
// //               scale: 0.5,
// //               child: FadeInAnimation(
// //                 child: Container(
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(screenWidth * 0.03),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black.withOpacity(0.05),
// //                         blurRadius: screenWidth * 0.025,
// //                         offset: Offset(0, screenHeight * 0.00625),
// //                       ),
// //                     ],
// //                   ),
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Container(
// //                         padding: EdgeInsets.all(screenWidth * 0.025),
// //                         decoration: BoxDecoration(
// //                           color: AppColors.restaurantsAccent.withOpacity(0.1),
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: Icon(
// //                           categories[index]['icon'],
// //                           color: AppColors.restaurantsAccent,
// //                           size: screenWidth * 0.06,
// //                         ),
// //                       ),
// //                       SizedBox(height: screenHeight * 0.01),
// //                       Text(
// //                         categories[index]['name'],
// //                         style: TextStyle(
// //                           fontSize: screenWidth * 0.03,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTopRatedRestaurantsCarousel(
// //     double screenWidth,
// //     double screenHeight,
// //   ) {
// //     final List<Map<String, dynamic>> restaurants = [
// //       {'name': 'Trishna', 'price': '₹2000 for two', 'rating': '4.8'},
// //       {'name': 'The Table', 'price': '₹2500 for two', 'rating': '4.7'},
// //       {'name': 'Wasabi by Morimoto', 'price': '₹3000 for two', 'rating': '4.6'},
// //       {'name': 'Bastian', 'price': '₹2200 for two', 'rating': '4.5'},
// //     ];
// //
// //     return SizedBox(
// //       height: screenHeight * 0.2625,
// //       child: ListView.builder(
// //         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
// //         scrollDirection: Axis.horizontal,
// //         itemCount: restaurants.length,
// //         itemBuilder: (context, index) {
// //           return Container(
// //                 width: screenWidth * 0.375,
// //                 margin: EdgeInsets.symmetric(
// //                   horizontal: screenWidth * 0.02,
// //                   vertical: screenHeight * 0.005,
// //                 ),
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(screenWidth * 0.04),
// //                   color: Colors.white,
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withOpacity(0.05),
// //                       blurRadius: screenWidth * 0.025,
// //                       offset: Offset(0, screenHeight * 0.00625),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Container(
// //                       height: screenHeight * 0.1375,
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.only(
// //                           topLeft: Radius.circular(screenWidth * 0.04),
// //                           topRight: Radius.circular(screenWidth * 0.04),
// //                         ),
// //                         color: AppColors.restaurantsAccent.withOpacity(0.1),
// //                       ),
// //                       child: Center(
// //                         child: Icon(
// //                           Icons.restaurant_outlined,
// //                           size: screenWidth * 0.125,
// //                           color: AppColors.restaurantsAccent,
// //                         ),
// //                       ),
// //                     ),
// //                     Padding(
// //                       padding: EdgeInsets.all(screenWidth * 0.025),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Container(
// //                             padding: EdgeInsets.symmetric(
// //                               horizontal: screenWidth * 0.015,
// //                               vertical: screenHeight * 0.00375,
// //                             ),
// //                             decoration: BoxDecoration(
// //                               color: AppColors.restaurantsAccent.withOpacity(
// //                                 0.2,
// //                               ),
// //                               borderRadius: BorderRadius.circular(
// //                                 screenWidth * 0.01,
// //                               ),
// //                             ),
// //                             child: Text(
// //                               'Rating: ${restaurants[index]['rating']}',
// //                               style: TextStyle(
// //                                 color: AppColors.restaurantsAccent,
// //                                 fontSize: screenWidth * 0.025,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           ),
// //                           SizedBox(height: screenHeight * 0.0075),
// //                           Text(
// //                             restaurants[index]['name'],
// //                             style: TextStyle(
// //                               fontWeight: FontWeight.w600,
// //                               fontSize: screenWidth * 0.035,
// //                             ),
// //                             maxLines: 1,
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                           SizedBox(height: screenHeight * 0.005),
// //                           Text(
// //                             restaurants[index]['price'],
// //                             style: TextStyle(
// //                               fontWeight: FontWeight.w700,
// //                               fontSize: screenWidth * 0.035,
// //                               color: AppColors.restaurantsAccent,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               )
// //               .animate(delay: (100 * index).ms)
// //               .fadeIn(duration: 400.ms)
// //               .slideX(begin: screenWidth * 0.125, end: 0, duration: 400.ms);
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _buildNearbyRestaurantsCarousel(
// //     double screenWidth,
// //     double screenHeight,
// //   ) {
// //     final List<Map<String, dynamic>> restaurants = [
// //       {'name': 'Cafe Mondegar', 'price': '₹800 for two', 'distance': '1.5 km'},
// //       {'name': 'Leopold Cafe', 'price': '₹1000 for two', 'distance': '2 km'},
// //       {'name': 'Bademiya', 'price': '₹600 for two', 'distance': '1.8 km'},
// //       {'name': 'Britannia & Co.', 'price': '₹1200 for two', 'distance': '3 km'},
// //     ];
// //
// //     return SizedBox(
// //       height: screenHeight * 0.1375,
// //       child: ListView.builder(
// //         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
// //         scrollDirection: Axis.horizontal,
// //         itemCount: restaurants.length,
// //         itemBuilder: (context, index) {
// //           return Container(
// //                 width: screenWidth * 0.7,
// //                 margin: EdgeInsets.only(right: screenWidth * 0.04),
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(screenWidth * 0.04),
// //                   color: Colors.white,
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withOpacity(0.05),
// //                       blurRadius: screenWidth * 0.025,
// //                       offset: Offset(0, screenHeight * 0.00625),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Container(
// //                       width: screenWidth * 0.225,
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.only(
// //                           topLeft: Radius.circular(screenWidth * 0.04),
// //                           bottomLeft: Radius.circular(screenWidth * 0.04),
// //                         ),
// //                         color: AppColors.restaurantsAccent.withOpacity(0.1),
// //                       ),
// //                       child: Center(
// //                         child: Icon(
// //                           Icons.restaurant_outlined,
// //                           size: screenWidth * 0.1,
// //                           color: AppColors.restaurantsAccent,
// //                         ),
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: Padding(
// //                         padding: EdgeInsets.all(screenWidth * 0.03),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Container(
// //                               padding: EdgeInsets.symmetric(
// //                                 horizontal: screenWidth * 0.02,
// //                                 vertical: screenHeight * 0.00375,
// //                               ),
// //                               decoration: BoxDecoration(
// //                                 color: AppColors.restaurantsAccent.withOpacity(
// //                                   0.1,
// //                                 ),
// //                                 borderRadius: BorderRadius.circular(
// //                                   screenWidth * 0.01,
// //                                 ),
// //                               ),
// //                               child: Text(
// //                                 restaurants[index]['distance'],
// //                                 style: TextStyle(
// //                                   color: AppColors.restaurantsAccent,
// //                                   fontSize: screenWidth * 0.025,
// //                                   fontWeight: FontWeight.w500,
// //                                 ),
// //                               ),
// //                             ),
// //                             SizedBox(height: screenHeight * 0.0075),
// //                             Text(
// //                               restaurants[index]['name'],
// //                               style: TextStyle(
// //                                 fontWeight: FontWeight.w600,
// //                                 fontSize: screenWidth * 0.03,
// //                               ),
// //                             ),
// //                             SizedBox(height: screenHeight * 0.005),
// //                             Text(
// //                               restaurants[index]['price'],
// //                               style: TextStyle(
// //                                 color: AppColors.textSecondary,
// //                                 fontSize: screenWidth * 0.025,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                     Padding(
// //                       padding: EdgeInsets.all(screenWidth * 0.03),
// //                       child: Container(
// //                         padding: EdgeInsets.all(screenWidth * 0.015),
// //                         decoration: const BoxDecoration(
// //                           color: AppColors.restaurantsAccent,
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: Icon(
// //                           Icons.bookmark_border,
// //                           color: Colors.white,
// //                           size: screenWidth * 0.045,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               )
// //               .animate(delay: (150 * index).ms)
// //               .fadeIn(duration: 500.ms)
// //               .slideX(begin: screenWidth * 0.075, end: 0, duration: 500.ms);
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRestaurantCard(
// //     int index,
// //     double screenWidth,
// //     double screenHeight,
// //   ) {
// //     final List<Map<String, dynamic>> restaurants = [
// //       {
// //         'name': 'Masala Library',
// //         'price': '₹2500 for two',
// //         'discount': '20% OFF',
// //       },
// //       {'name': 'Yauatcha', 'price': '₹2000 for two', 'discount': ''},
// //       {'name': 'Ziya', 'price': '₹3000 for two', 'discount': '15% OFF'},
// //       {'name': 'Farzi Cafe', 'price': '₹1800 for two', 'discount': ''},
// //       {
// //         'name': 'Smoke House Deli',
// //         'price': '₹1500 for two',
// //         'discount': '10% OFF',
// //       },
// //       {'name': 'Indigo Deli', 'price': '₹2000 for two', 'discount': ''},
// //     ];
// //
// //     return AnimationConfiguration.staggeredGrid(
// //       position: index,
// //       columnCount: 2,
// //       duration: const Duration(milliseconds: 500),
// //       child: ScaleAnimation(
// //         scale: 0.8,
// //         child: FadeInAnimation(
// //           child: Container(
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(screenWidth * 0.04),
// //               color: Colors.white,
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.05),
// //                   blurRadius: screenWidth * 0.025,
// //                   offset: Offset(0, screenHeight * 0.00625),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Stack(
// //                   children: [
// //                     Container(
// //                       height: screenHeight * 0.175,
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.only(
// //                           topLeft: Radius.circular(screenWidth * 0.04),
// //                           topRight: Radius.circular(screenWidth * 0.04),
// //                         ),
// //                         color: AppColors.restaurantsAccent.withOpacity(0.1),
// //                       ),
// //                       child: Center(
// //                         child: Icon(
// //                           Icons.restaurant_outlined,
// //                           size: screenWidth * 0.15,
// //                           color: AppColors.restaurantsAccent,
// //                         ),
// //                       ),
// //                     ),
// //                     if (restaurants[index]['discount'].isNotEmpty)
// //                       Positioned(
// //                         top: screenHeight * 0.0125,
// //                         left: screenWidth * 0.025,
// //                         child: Container(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: screenWidth * 0.02,
// //                             vertical: screenHeight * 0.005,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: AppColors.restaurantsAccent,
// //                             borderRadius: BorderRadius.circular(
// //                               screenWidth * 0.01,
// //                             ),
// //                           ),
// //                           child: Text(
// //                             restaurants[index]['discount'],
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontSize: screenWidth * 0.025,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     Positioned(
// //                       top: screenHeight * 0.0125,
// //                       right: screenWidth * 0.025,
// //                       child: Container(
// //                         padding: EdgeInsets.all(screenWidth * 0.015),
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           shape: BoxShape.circle,
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: Colors.black.withOpacity(0.1),
// //                               blurRadius: screenWidth * 0.0125,
// //                             ),
// //                           ],
// //                         ),
// //                         child: Icon(
// //                           Icons.favorite_border,
// //                           color: AppColors.restaurantsAccent,
// //                           size: screenWidth * 0.04,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 Padding(
// //                   padding: EdgeInsets.all(screenWidth * 0.025),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         restaurants[index]['name'],
// //                         style: TextStyle(
// //                           fontWeight: FontWeight.w600,
// //                           fontSize: screenWidth * 0.035,
// //                         ),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                       SizedBox(height: screenHeight * 0.005),
// //                       Text(
// //                         restaurants[index]['price'],
// //                         style: TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: screenWidth * 0.035,
// //                           color: AppColors.restaurantsAccent,
// //                         ),
// //                       ),
// //                       SizedBox(height: screenHeight * 0.005),
// //                       Row(
// //                         children: [
// //                           Icon(
// //                             Icons.star,
// //                             color: Colors.amber,
// //                             size: screenWidth * 0.04,
// //                           ),
// //                           SizedBox(width: screenWidth * 0.01),
// //                           Text(
// //                             '4.${index + 4}',
// //                             style: TextStyle(
// //                               color: AppColors.textSecondary,
// //                               fontSize: screenWidth * 0.03,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
//
// /// --------------------
// /// MODEL
// /// --------------------
// class Restaurant {
//   final String name;
//   final double rating;
//   final double price;
//   final bool isVeg;
//   final bool isWifi;
//
//   Restaurant({
//     required this.name,
//     required this.rating,
//     required this.price,
//     required this.isVeg,
//     required this.isWifi,
//   });
// }
//
// /// --------------------
// /// FILTER MODEL
// /// --------------------
// class RestaurantFilter {
//   final double? minPrice;
//   final double? maxPrice;
//   final double? minRating;
//   final bool? isVeg;
//   final bool? isWifi;
//   final String? sortBy;
//
//   RestaurantFilter({
//     this.minPrice,
//     this.maxPrice,
//     this.minRating,
//     this.isVeg,
//     this.isWifi,
//     this.sortBy,
//   });
//
//   RestaurantFilter copyWith({
//     double? minPrice,
//     double? maxPrice,
//     double? minRating,
//     bool? isVeg,
//     bool? isWifi,
//     String? sortBy,
//   }) {
//     return RestaurantFilter(
//       minPrice: minPrice,
//       maxPrice: maxPrice,
//       minRating: minRating,
//       isVeg: isVeg,
//       isWifi: isWifi,
//       sortBy: sortBy,
//     );
//   }
// }
//
// /// --------------------
// /// PROVIDERS
// /// --------------------
// final restaurantListProvider = Provider<List<Restaurant>>((ref) {
//   return [
//     Restaurant(name: "Spice Hub", rating: 4.5, price: 300, isVeg: true, isWifi: true),
//     Restaurant(name: "Food Palace", rating: 4.0, price: 250, isVeg: false, isWifi: false),
//     Restaurant(name: "Green Leaf", rating: 4.8, price: 400, isVeg: true, isWifi: true),
//     Restaurant(name: "Urban Tadka", rating: 3.9, price: 200, isVeg: false, isWifi: true),
//   ];
// });
//
// final restaurantFilterProvider =
// StateProvider<RestaurantFilter>((ref) => RestaurantFilter());
//
// final filteredRestaurantProvider = Provider<List<Restaurant>>((ref) {
//   final list = ref.watch(restaurantListProvider);
//   final filter = ref.watch(restaurantFilterProvider);
//
//   var result = list.where((r) {
//     if (filter.minPrice != null && r.price < filter.minPrice!) return false;
//     if (filter.maxPrice != null && r.price > filter.maxPrice!) return false;
//     if (filter.minRating != null && r.rating < filter.minRating!) return false;
//     if (filter.isVeg == true && !r.isVeg) return false;
//     if (filter.isWifi == true && !r.isWifi) return false;
//     return true;
//   }).toList();
//
//   if (filter.sortBy == 'price') {
//     result.sort((a, b) => a.price.compareTo(b.price));
//   } else if (filter.sortBy == 'rating') {
//     result.sort((a, b) => b.rating.compareTo(a.rating));
//   }
//
//   return result;
// });
//
// /// --------------------
// /// MAIN SCREEN
// /// --------------------
// class RestaurentScreen extends ConsumerWidget {
//   const RestaurentScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final restaurants = ref.watch(filteredRestaurantProvider);
//     final filter = ref.watch(restaurantFilterProvider);
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         foregroundColor: Colors.black,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Restaurants",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Text("${restaurants.length} found",
//                 style: TextStyle(fontSize: 12, color: Colors.grey)),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.tune),
//             onPressed: () => _showFilter(context, ref),
//           ),
//           IconButton(
//             icon: const Icon(Icons.sort),
//             onPressed: () => _showSort(context, ref),
//           ),
//         ],
//       ),
//       body: restaurants.isEmpty
//           ? _emptyState()
//           : AnimationLimiter(
//         child: ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: restaurants.length,
//           itemBuilder: (context, index) {
//             final r = restaurants[index];
//             return AnimationConfiguration.staggeredList(
//               position: index,
//               duration: const Duration(milliseconds: 400),
//               child: SlideAnimation(
//                 verticalOffset: 50,
//                 child: FadeInAnimation(
//                   child: _restaurantCard(r),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   /// --------------------
//   /// RESTAURANT CARD
//   /// --------------------
//   Widget _restaurantCard(Restaurant r) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600)),
//         subtitle: Text("⭐ ${r.rating}  •  ₹${r.price}"),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (r.isVeg) const Text("VEG", style: TextStyle(color: Colors.green)),
//             if (r.isWifi)
//               const Icon(Icons.wifi, size: 16, color: Colors.blue),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// --------------------
//   /// EMPTY STATE
//   /// --------------------
//   Widget _emptyState() {
//     return const Center(
//       child: Text("No restaurants found"),
//     );
//   }
//
//   /// --------------------
//   /// FILTER SHEET
//   /// --------------------
//   void _showFilter(BuildContext context, WidgetRef ref) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => Consumer(
//         builder: (context, ref, _) {
//           final filter = ref.watch(restaurantFilterProvider);
//           return Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text("Filters",
//                     style:
//                     TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 CheckboxListTile(
//                   title: const Text("Veg Only"),
//                   value: filter.isVeg ?? false,
//                   onChanged: (v) {
//                     ref.read(restaurantFilterProvider.notifier).state =
//                         filter.copyWith(isVeg: v);
//                   },
//                 ),
//                 CheckboxListTile(
//                   title: const Text("WiFi"),
//                   value: filter.isWifi ?? false,
//                   onChanged: (v) {
//                     ref.read(restaurantFilterProvider.notifier).state =
//                         filter.copyWith(isWifi: v);
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Apply"),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   /// --------------------
//   /// SORT SHEET
//   /// --------------------
//   void _showSort(BuildContext context, WidgetRef ref) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => Consumer(
//         builder: (context, ref, _) {
//           final filter = ref.watch(restaurantFilterProvider);
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               RadioListTile(
//                 title: const Text("Price (Low to High)"),
//                 value: "price",
//                 groupValue: filter.sortBy,
//                 onChanged: (v) {
//                   ref.read(restaurantFilterProvider.notifier).state =
//                       filter.copyWith(sortBy: v);
//                   Navigator.pop(context);
//                 },
//               ),
//               RadioListTile(
//                 title: const Text("Rating (High to Low)"),
//                 value: "rating",
//                 groupValue: filter.sortBy,
//                 onChanged: (v) {
//                   ref.read(restaurantFilterProvider.notifier).state =
//                       filter.copyWith(sortBy: v);
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
