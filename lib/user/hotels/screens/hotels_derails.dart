import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/user/hotels/provider/hotel_provider.dart';
import 'package:intl/intl.dart';

class HotelDetailsScreen extends ConsumerWidget {
  const HotelDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppSizes.init(context);
    final screenWidth = AppSizes.screenWidth;
    final screenHeight = AppSizes.screenHeight;
    final hotelState = ref.watch(hotelStateProvider);
    final hotel = hotelState.selectedHotel;
    final search = hotelState.search;

    if (hotel == null || search == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hotel_outlined, size: 64, color: Colors.grey[400]),
              SizedBox(height: AppSizes.verticalSpaceMedium),
              Text(
                'No hotel selected',
                style: AppSizes.headingMedium.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar with Image
          SliverAppBar(
            expandedHeight: screenHeight * 0.4,
            pinned: true,
            elevation: 0,

            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            backgroundColor: AppColors.hotelsAccent,
            title: Text(
              hotel.name,
              style: const TextStyle(color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hotel Image
                  ClipRRect(
                    child: Image.network(
                      hotel.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.hotel,
                            size: AppSizes.iconExtraLarge,
                            color: AppColors.hotelsAccent,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                              color: AppColors.hotelsAccent,
                            ),
                          ),
                        );
                      },
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
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),
                  // Hotel Name and Rating Overlay
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppSizes.verticalSpaceSmall),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.paddingSmall,
                                vertical: AppSizes.paddingTiny,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: AppSizes.iconSmall,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    hotel.rating.toString(),
                                    style: AppSizes.bodyMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: AppSizes.paddingSmall),
                            Text(
                              '(${hotel.reviews} reviews)',
                              style: AppSizes.bodyMedium.copyWith(
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Hotel Info Card
                Container(
                  margin: EdgeInsets.all(AppSizes.paddingMedium),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.hotelsAccent,
                              size: AppSizes.iconMedium,
                            ),
                            SizedBox(width: AppSizes.paddingSmall),
                            Expanded(
                              child: Text(
                                hotel.address,
                                style: AppSizes.bodyMedium.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.verticalSpaceMedium),

                        // Price Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppSizes.paddingMedium),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.hotelsAccent.withOpacity(0.1),
                                AppColors.hotelsAccent.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.hotelsAccent.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Starting from',
                                style: AppSizes.bodySmall.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                hotel.pricePerNight,
                                style: AppSizes.headingLarge.copyWith(
                                  color: AppColors.hotelsAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'per night',
                                style: AppSizes.bodySmall.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Details Card
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMedium,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: AppColors.hotelsAccent,
                              size: AppSizes.iconMedium,
                            ),
                            SizedBox(width: AppSizes.paddingSmall),
                            Text(
                              'Your Search',
                              style: AppSizes.headingMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.verticalSpaceMedium),

                        // Search details in a grid
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 3,
                          crossAxisSpacing: AppSizes.paddingSmall,
                          mainAxisSpacing: AppSizes.paddingSmall,
                          children: [
                            _buildSearchDetail(
                              Icons.location_city,
                              'City',
                              search.city,
                            ),
                            _buildSearchDetail(
                              Icons.people,
                              'Guests',
                              '${search.adults + search.children}',
                            ),
                            _buildSearchDetail(
                              Icons.login,
                              'Check-in',
                              DateFormat('dd MMM').format(search.checkIn),
                            ),
                            _buildSearchDetail(
                              Icons.logout,
                              'Check-out',
                              DateFormat('dd MMM').format(search.checkOut),
                            ),
                          ],
                        ),

                        SizedBox(height: AppSizes.verticalSpaceSmall),

                        // Duration
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppSizes.paddingSmall),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${search.checkOut.difference(search.checkIn).inDays} nights stay',
                            style: AppSizes.bodyMedium.copyWith(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: AppSizes.verticalSpaceMedium),

                // Amenities Card
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMedium,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.wifi,
                              color: AppColors.hotelsAccent,
                              size: AppSizes.iconMedium,
                            ),
                            SizedBox(width: AppSizes.paddingSmall),
                            Text(
                              'Amenities',
                              style: AppSizes.headingMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.verticalSpaceMedium),

                        // Amenities grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 4,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: hotel.amenities.length,
                          itemBuilder: (context, index) {
                            return _buildAmenityItem(hotel.amenities[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom spacing for the floating button
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      // Enhanced floating action button
      floatingActionButton: Container(
        width: screenWidth * 0.9,
        height: 56,
        margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
        child: FloatingActionButton.extended(
          onPressed: () => context.push('/hotels/rooms'),
          backgroundColor: AppColors.hotelsAccent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Room',
                style: AppSizes.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: AppSizes.paddingSmall),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: AppSizes.iconMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSearchDetail(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingSmall),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.iconSmall, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppSizes.bodySmall.copyWith(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: AppSizes.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(String amenity) {
    IconData icon;
    switch (amenity.toLowerCase()) {
      case 'wifi':
        icon = Icons.wifi;
        break;
      case 'pool':
        icon = Icons.pool;
        break;
      case 'spa':
        icon = Icons.spa;
        break;
      case 'restaurant':
        icon = Icons.restaurant;
        break;
      case 'parking':
        icon = Icons.local_parking;
        break;
      case 'gym':
        icon = Icons.fitness_center;
        break;
      case 'bar':
        icon = Icons.local_bar;
        break;
      case 'room service':
        icon = Icons.room_service;
        break;
      case 'beach access':
        icon = Icons.beach_access;
        break;
      case 'breakfast included':
        icon = Icons.free_breakfast;
        break;
      case 'casino':
        icon = Icons.casino;
        break;
      case 'garden':
        icon = Icons.local_florist;
        break;
      case 'yoga classes':
        icon = Icons.self_improvement;
        break;
      default:
        icon = Icons.check_circle;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSmall,
        vertical: AppSizes.paddingTiny,
      ),
      decoration: BoxDecoration(
        color: AppColors.hotelsAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hotelsAccent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.iconSmall, color: AppColors.hotelsAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              amenity,
              style: AppSizes.bodySmall.copyWith(
                color: AppColors.hotelsAccent,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
