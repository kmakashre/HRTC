import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/travel/Bus/screens/bus_screen.dart';
import 'package:hrtc/user/travel/Travel/provider/travel_Provider.dart';

import '../../flight/screens/flight_screen.dart';

class BusFormScreen extends ConsumerWidget {
  const BusFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppSizes.init(context);
    final state = ref.watch(travelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ================= BUS FORM =================
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSizes.paddingAllMedium,
              child: Column(
                children: [
                  _buildBusLocationFields(ref, state),
                  SizedBox(height: AppSizes.verticalSpaceMedium),
                  _buildBusDateField(ref, state),
                  SizedBox(height: AppSizes.verticalSpaceLarge),
                  _buildSearchButton(context, state),
                ],
              ),
            ),
          ),

          // ================= DEALS =================
          SliverToBoxAdapter(
            child: _buildDealsSection(state),
          ),

          // ================= POPULAR DESTINATIONS =================
          SliverToBoxAdapter(
            child: _buildPopularDestinations(),
          ),

          // ================= TRAVEL TIPS =================
          SliverToBoxAdapter(
            child: _buildTravelTips(),
          ),

          // ================= RECENT SEARCHES =================
          SliverToBoxAdapter(
            child: _buildRecentSearches(),
          ),

          // ================= BOTTOM SPACE =================
          SliverToBoxAdapter(
            child: SizedBox(height: AppSizes.verticalSpaceLarge),
          ),
        ],
      ),

    );
  }

  // ================= FROM / TO =================
  Widget _buildBusLocationFields(WidgetRef ref, TravelState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppSizes.radiusMedium,
      ),
      child: Column(
        children: [
          _locationTile(
            icon: Icons.directions_bus,
            label: 'From',
            value: state.fromLocation,
            onTap: () => _showLocationPicker(ref, true),
          ),
          const Divider(height: 1),
          _locationTile(
            icon: Icons.location_on,
            label: 'To',
            value: state.toLocation,
            onTap: () => _showLocationPicker(ref, false),
          ),
        ],
      ),
    );
  }

  Widget _locationTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: AppSizes.paddingAllMedium,
        child: Row(
          children: [
            Icon(icon, color: AppColors.restaurantsAccent),
            SizedBox(width: AppSizes.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppSizes.bodySmall),
                  SizedBox(height: 4),
                  Text(
                    value.isEmpty ? 'Select $label' : value,
                    style: AppSizes.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  // ================= DATE =================
  Widget _buildBusDateField(WidgetRef ref, TravelState state) {
    return InkWell(
      onTap: () => _showDatePicker(ref),
      child: Container(
        padding: AppSizes.paddingAllMedium,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: AppSizes.radiusMedium,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today,
                color: AppColors.restaurantsAccent),
            SizedBox(width: AppSizes.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Journey Date', style: AppSizes.bodySmall),
                  SizedBox(height: 4),
                  Text(
                    state.departureDate.isEmpty
                        ? 'Select Date'
                        : state.departureDate,
                    style: AppSizes.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SEARCH =================
  Widget _buildSearchButton(BuildContext context, TravelState state) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.restaurantsAccent,
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMedium,
          ),
        ),
        onPressed: state.canSearch
            ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const BusSearchScreen(),
            ),
          );
        }
            : null,
        child: const Text(
          'Search Buses',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  // ================= HELPERS =================
  void _showLocationPicker(WidgetRef ref, bool isFrom) {
    showModalBottomSheet(
      context: ref.context,
      builder: (_) => _LocationPickerModal(isFrom: isFrom),
    );
  }

  void _showDatePicker(WidgetRef ref) async {
    final picked = await showDatePicker(
      context: ref.context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      ref
          .read(travelProvider.notifier)
          .setDepartureDate(
        ref.read(travelProvider.notifier).formatDate(picked),
      );
    }
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
                  color: AppColors.restaurantsAccent,
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
                                    color: AppColors.restaurantsAccent,
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
                color: AppColors.restaurantsAccent,
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
                      color: AppColors.restaurantsAccent,
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
                color: AppColors.restaurantsAccent,
                borderRadius: AppSizes.radiusMedium,
                border: Border.all(
                  color: AppColors.textLight.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color: AppColors.restaurantsAccent,
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

// ================= LOCATION PICKER =================
class _LocationPickerModal extends ConsumerWidget {
  final bool isFrom;

  const _LocationPickerModal({required this.isFrom});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularCities = [
      {
        'name': 'Mumbai',
        'code': 'BOM',
        'airport': 'Chhatrapati Shivaji Maharaj International Airport',
      },
      {
        'name': 'Delhi',
        'code': 'DEL',
        'airport': 'Indira Gandhi International Airport',
      },
      {
        'name': 'Bangalore',
        'code': 'BLR',
        'airport': 'Kempegowda International Airport',
      },
      {
        'name': 'Chennai',
        'code': 'MAA',
        'airport': 'Chennai International Airport',
      },
      {
        'name': 'Kolkata',
        'code': 'CCU',
        'airport': 'Netaji Subhas Chandra Bose International Airport',
      },
      {
        'name': 'Hyderabad',
        'code': 'HYD',
        'airport': 'Rajiv Gandhi International Airport',
      },
      {'name': 'Pune', 'code': 'PNQ', 'airport': 'Pune Airport'},
      {
        'name': 'Ahmedabad',
        'code': 'AMD',
        'airport': 'Sardar Vallabhbhai Patel International Airport',
      },
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Column(
            children: [
              Container(
                padding: AppSizes.paddingAllMedium,
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(height: AppSizes.verticalSpaceMedium),
                    Text(
                      'Select ${isFrom ? 'Departure' : 'Destination'} City',
                      style: AppSizes.headingSmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: popularCities.length,
                  itemBuilder: (context, index) {
                    final city = popularCities[index];
                    return ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(AppSizes.paddingSmall),
                        decoration: BoxDecoration(
                          color: AppColors.restaurantsAccent.withOpacity(0.1),
                          borderRadius: AppSizes.radiusSmall,
                        ),
                        child: Text(
                          city['code']!,
                          style: AppSizes.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.restaurantsAccent,
                          ),
                        ),
                      ),
                      title: Text(city['name']!, style: AppSizes.bodyMedium),
                      subtitle: Text(
                        city['airport']!,
                        style: AppSizes.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      onTap: () {
                        if (isFrom) {
                          ref
                              .read(travelProvider.notifier)
                              .setFromLocation(city['name']!);
                        } else {
                          ref
                              .read(travelProvider.notifier)
                              .setToLocation(city['name']!);
                        }
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

