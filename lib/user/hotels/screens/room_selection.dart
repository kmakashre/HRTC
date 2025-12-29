import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/user/hotels/provider/hotel_provider.dart';

class RoomSelectionScreen extends ConsumerWidget {
  const RoomSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppSizes.init(context);
    final screenWidth = AppSizes.screenWidth;
    final screenHeight = AppSizes.screenHeight;
    final hotel = ref.watch(hotelStateProvider).selectedHotel;
    final rooms = ref
        .watch(hotelStateProvider.notifier)
        .getRoomsForHotel(hotel?.id ?? '');

    if (hotel == null) {
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
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar with gradient
          SliverAppBar(
            expandedHeight: 60,
            floating: false,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.hotelsAccent,
            foregroundColor: Colors.white,
            title: const Text(
              'Room Selection',
              style: TextStyle(color: Colors.white),
            ),
          ),

          // Hotel Info Header
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(AppSizes.paddingMedium),
              padding: EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppSizes.radiusMedium,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.hotelsAccent.withOpacity(0.1),
                      borderRadius: AppSizes.radiusSmall,
                    ),
                    child: const Icon(
                      Icons.hotel,
                      color: AppColors.hotelsAccent,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: AppSizes.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel.name,
                          style: AppSizes.headingMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${hotel.city} • ${hotel.address}',
                                style: AppSizes.bodyMedium.copyWith(
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  Icons.star,
                                  size: 16,
                                  color:
                                      index < hotel.rating.floor()
                                          ? Colors.amber
                                          : Colors.grey[300],
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${hotel.rating} (${hotel.reviews} reviews)',
                              style: AppSizes.bodySmall.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2, end: 0),
          ),

          // Room Count Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
              child: Text(
                '${rooms.length} rooms available',
                style: AppSizes.headingSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ).animate().fadeIn(delay: 200.ms),
            ),
          ),

          // Rooms List
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final room = rooms[index];
                return _buildRoomCard(context, ref, room, index, screenHeight);
              }, childCount: rooms.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(
    BuildContext context,
    WidgetRef ref,
    Room room,
    int index,
    double screenHeight,
  ) {
    return Container(
          margin: EdgeInsets.only(bottom: AppSizes.paddingMedium),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppSizes.radiusMedium,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppSizes.radiusMedium,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Image with Overlay
                Stack(
                  children: [
                    Container(
                      height: screenHeight * 0.2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.hotelsAccent.withOpacity(0.1),
                            AppColors.hotelsAccent.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.bed,
                              size: AppSizes.iconLarge * 1.5,
                              color: AppColors.hotelsAccent.withOpacity(0.3),
                            ),
                          ),
                          // Decorative elements
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Popular',
                                    style: AppSizes.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Room Details
                Padding(
                  padding: EdgeInsets.all(AppSizes.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Room Type and Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.type,
                                  style: AppSizes.headingMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Best Deal',
                                    style: AppSizes.bodySmall.copyWith(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                room.price.toStringAsFixed(0),
                                style: AppSizes.headingMedium.copyWith(
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
                        ],
                      ),

                      SizedBox(height: AppSizes.verticalSpaceMedium),

                      // Features Section
                      Text(
                        'Room Features',
                        style: AppSizes.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: AppSizes.verticalSpaceSmall),

                      // Features Grid
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            room.features.map((feature) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.hotelsAccent.withOpacity(
                                    0.05,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.hotelsAccent.withOpacity(
                                      0.2,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getFeatureIcon(feature),
                                      size: 14,
                                      color: AppColors.hotelsAccent,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      feature,
                                      style: AppSizes.bodySmall.copyWith(
                                        color: AppColors.hotelsAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),

                      SizedBox(height: AppSizes.verticalSpaceMedium),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(hotelStateProvider.notifier)
                                .selectRoom(room);
                            context.push('/hotels/booking');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.hotelsAccent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSizes.radiusSmall,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Select Room',
                                style: AppSizes.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                size: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(delay: (100 * index).ms)
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.3, end: 0, curve: Curves.easeOutCubic)
        .then(delay: 100.ms)
        .shimmer(duration: 1000.ms, color: Colors.white.withOpacity(0.3));
  }

  IconData _getFeatureIcon(String feature) {
    switch (feature.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'breakfast':
        return Icons.free_breakfast;
      case 'room service':
        return Icons.room_service;
      case 'minibar':
        return Icons.local_bar;
      case 'balcony':
        return Icons.balcony;
      case 'jacuzzi':
        return Icons.hot_tub;
      case 'work desk':
        return Icons.desk;
      case 'city view':
        return Icons.location_city;
      case 'sea view':
        return Icons.waves;
      case 'garden view':
        return Icons.nature;
      case 'beach view':
        return Icons.beach_access;
      case 'king bed':
      case 'queen bed':
      case 'two beds':
        return Icons.bed;
      case 'living area':
        return Icons.weekend;
      case 'extra space':
        return Icons.open_in_full;
      case 'private garden':
        return Icons.park;
      default:
        return Icons.check_circle;
    }
  }
}
