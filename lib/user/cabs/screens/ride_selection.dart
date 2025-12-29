import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/cabs/provider/cab_booking.dart';
import 'package:hrtc/user/cabs/provider/cab_ride.dart';
import 'package:hrtc/user/cabs/screens/booking_confirmation.dart';
import 'package:hrtc/user/cabs/screens/cabs.dart';

class RideSelectionScreen extends ConsumerWidget {
  const RideSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppSizes.init(context);
    final cabRideState = ref.watch(cabRideProvider);
    final cabBookingState = ref.watch(cabBookingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Your Ride',
          style: AppSizes.headingMedium.copyWith(
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        scrolledUnderElevation: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () => ref.read(cabRideProvider.notifier).refreshRides(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Trip Details Header
          Container(
            margin: AppSizes.paddingAllMedium,
            padding: AppSizes.paddingAllMedium,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppSizes.radiusMedium,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 30,
                      margin: AppSizes.paddingVerticalSmall,
                      child: CustomPaint(painter: DottedLinePainter()),
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                AppSizes.horizontalSpaceSmallBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cabBookingState.pickupLocation,
                        style: AppSizes.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppSizes.verticalSpaceSmallBox,
                      Text(
                        cabBookingState.dropoffLocation,
                        style: AppSizes.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (cabBookingState.estimatedDistance != null)
                      Container(
                        padding: AppSizes.paddingHorizontalSmall,
                        decoration: BoxDecoration(
                          color: AppColors.CabsAccent.withOpacity(0.1),
                          borderRadius: AppSizes.radiusSmall,
                        ),
                        child: Text(
                          '${cabBookingState.estimatedDistance!.toStringAsFixed(1)} km',
                          style: AppSizes.bodySmall.copyWith(
                            color: AppColors.CabsAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (cabBookingState.pickupDateTime != null) ...[
                      AppSizes.verticalSpaceTinyBox,
                      Container(
                        padding: AppSizes.paddingHorizontalSmall,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: AppSizes.radiusSmall,
                        ),
                        child: Text(
                          _formatTime(cabBookingState.pickupDateTime!),
                          style: AppSizes.bodySmall.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Available Rides Section
          Expanded(
            child:
                cabRideState.isLoading
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.CabsAccent,
                            ),
                          ),
                          AppSizes.verticalSpaceSmallBox,
                          Text(
                            'Finding available rides...',
                            style: AppSizes.bodyMedium.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh:
                          () =>
                              ref.read(cabRideProvider.notifier).refreshRides(),
                      child: ListView.builder(
                        padding: AppSizes.paddingHorizontalMedium,
                        itemCount: cabRideState.rideOptions.length,
                        itemBuilder: (context, index) {
                          final ride = cabRideState.rideOptions[index];
                          final estimatedFare = _calculateFare(
                            ride,
                            cabBookingState.estimatedDistance ?? 5.0,
                          );

                          return Container(
                            margin: AppSizes.paddingVerticalSmall,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppSizes.radiusMedium,
                              border: Border.all(
                                color:
                                    cabRideState.selectedRideId == ride.id
                                        ? AppColors.CabsAccent
                                        : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: AppSizes.radiusMedium,
                                onTap:
                                    ride.isAvailable
                                        ? () {
                                          ref
                                              .read(cabRideProvider.notifier)
                                              .selectRide(ride.id);
                                          ref
                                              .read(cabBookingProvider.notifier)
                                              .selectRide(ride.id);
                                        }
                                        : null,
                                child: Padding(
                                  padding: AppSizes.paddingAllMedium,
                                  child: Row(
                                    children: [
                                      // Vehicle Image
                                      ClipRRect(
                                        borderRadius: AppSizes.radiusSmall,
                                        child: Image.network(
                                          ride.imageUrl,
                                          width: 80,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              width: 80,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    AppSizes.radiusSmall,
                                              ),
                                              child: Icon(
                                                Icons.directions_car,
                                                color: Colors.grey[400],
                                                size: 32,
                                              ),
                                            );
                                          },
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Container(
                                              width: 80,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    AppSizes.radiusSmall,
                                              ),
                                              child: const Center(
                                                child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(AppColors.CabsAccent),
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      AppSizes.horizontalSpaceSmallBox,

                                      // Ride Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    ride.name,
                                                    style: AppSizes.bodyLarge
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              ride.isAvailable
                                                                  ? AppColors
                                                                      .textPrimary
                                                                  : Colors.grey,
                                                        ),
                                                  ),
                                                ),
                                                if (!ride.isAvailable)
                                                  Container(
                                                    padding:
                                                        AppSizes
                                                            .paddingHorizontalSmall,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          AppSizes.radiusSmall,
                                                    ),
                                                    child: Text(
                                                      'Unavailable',
                                                      style: AppSizes.caption
                                                          .copyWith(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                              ],
                                            ),

                                            AppSizes.verticalSpaceTinyBox,

                                            Text(
                                              ride.description,
                                              style: AppSizes.bodySmall
                                                  .copyWith(
                                                    color: Colors.grey[600],
                                                  ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            AppSizes.verticalSpaceTinyBox,

                                            // Features and Info
                                            Row(
                                              children: [
                                                // Capacity
                                                Icon(
                                                  Icons.person,
                                                  size: AppSizes.iconSmall,
                                                  color: Colors.grey[600],
                                                ),
                                                AppSizes.horizontalSpaceTinyBox,
                                                Text(
                                                  '${ride.capacity}',
                                                  style: AppSizes.bodySmall
                                                      .copyWith(
                                                        color: Colors.grey[600],
                                                      ),
                                                ),

                                                AppSizes
                                                    .horizontalSpaceSmallBox,

                                                // Rating
                                                Icon(
                                                  Icons.star,
                                                  size: AppSizes.iconSmall,
                                                  color: Colors.amber,
                                                ),
                                                AppSizes.horizontalSpaceTinyBox,
                                                Text(
                                                  ride.rating.toString(),
                                                  style: AppSizes.bodySmall
                                                      .copyWith(
                                                        color: Colors.grey[600],
                                                      ),
                                                ),

                                                AppSizes
                                                    .horizontalSpaceSmallBox,

                                                // ETA
                                                Icon(
                                                  Icons.access_time,
                                                  size: AppSizes.iconSmall,
                                                  color: Colors.grey[600],
                                                ),
                                                AppSizes.horizontalSpaceTinyBox,
                                                Text(
                                                  ride.estimatedTime,
                                                  style: AppSizes.bodySmall
                                                      .copyWith(
                                                        color: Colors.grey[600],
                                                      ),
                                                ),
                                              ],
                                            ),

                                            AppSizes.verticalSpaceTinyBox,

                                            // Features Tags
                                            Wrap(
                                              spacing: 6,
                                              runSpacing: 4,
                                              children:
                                                  ride.features
                                                      .take(3)
                                                      .map(
                                                        (feature) => Container(
                                                          padding:
                                                              AppSizes
                                                                  .paddingHorizontalSmall,
                                                          decoration: BoxDecoration(
                                                            color: AppColors
                                                                .CabsAccent.withOpacity(
                                                              0.1,
                                                            ),
                                                            borderRadius:
                                                                AppSizes
                                                                    .radiusSmall,
                                                          ),
                                                          child: Text(
                                                            feature,
                                                            style: AppSizes
                                                                .caption
                                                                .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .CabsAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                            ),
                                          ],
                                        ),
                                      ),

                                      AppSizes.horizontalSpaceSmallBox,

                                      // Price and Action
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '₹${estimatedFare.toStringAsFixed(0)}',
                                            style: AppSizes.headingMedium
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      ride.isAvailable
                                                          ? AppColors.CabsAccent
                                                          : Colors.grey,
                                                ),
                                          ),

                                          AppSizes.verticalSpaceTinyBox,

                                          Text(
                                            'Est. total',
                                            style: AppSizes.caption.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                          ),

                                          AppSizes.verticalSpaceTinyBox,

                                          if (ride.isAvailable)
                                            Container(
                                              padding:
                                                  AppSizes
                                                      .paddingHorizontalSmall,
                                              decoration: BoxDecoration(
                                                color:
                                                    cabRideState.selectedRideId ==
                                                            ride.id
                                                        ? AppColors.CabsAccent
                                                        : AppColors
                                                            .CabsAccent.withOpacity(
                                                          0.1,
                                                        ),
                                                borderRadius:
                                                    AppSizes.radiusSmall,
                                              ),
                                              child: Text(
                                                cabRideState.selectedRideId ==
                                                        ride.id
                                                    ? 'Selected'
                                                    : 'Select',
                                                style: AppSizes.caption.copyWith(
                                                  color:
                                                      cabRideState.selectedRideId ==
                                                              ride.id
                                                          ? Colors.white
                                                          : AppColors
                                                              .CabsAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          ),

          // Book Now Button
          if (cabRideState.selectedRideId != null)
            Container(
              padding: AppSizes.paddingAllMedium,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const BookingConfirmationScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.CabsAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSizes.radiusLarge,
                      ),
                      elevation: AppSizes.elevationMedium,
                      shadowColor: AppColors.CabsAccent.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_taxi, size: AppSizes.iconMedium),
                        AppSizes.horizontalSpaceSmallBox,
                        Text(
                          'Book Now',
                          style: AppSizes.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        AppSizes.horizontalSpaceSmallBox,
                        Icon(Icons.arrow_forward, size: AppSizes.iconSmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _calculateFare(RideOption ride, double distance) {
    return ride.baseFare + (ride.pricePerKm * distance);
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now).inMinutes;

    if (difference < 60) {
      return '${difference}m';
    } else {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(dateTime)}';
  }
}
