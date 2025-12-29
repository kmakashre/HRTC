import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/cabs/provider/cab_booking.dart';
import 'package:hrtc/user/cabs/screens/ride_selection.dart';
import 'package:hrtc/user/cabs/widgets/cab_serach.dart';

class CabBookingScreen extends ConsumerWidget {
  const CabBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppSizes.init(context);
    final cabBookingState = ref.watch(cabBookingProvider);

    Widget buildHeader() {
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
                'Book Your safe and secure cab ride instantly',
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: buildHeader(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSizes.paddingAllMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              // Container(
              //   padding: EdgeInsets.all(20),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(16),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.1),
              //         blurRadius: 10,
              //         offset: Offset(0, 5),
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Icon(
              //             Icons.location_on,
              //             color: AppColors.CabsAccent,
              //             size: 28,
              //           ),
              //           SizedBox(width: 12),
              //           Text(
              //             'Current Location',
              //             style: AppSizes.headingSmall.copyWith(
              //               color: AppColors.textPrimary,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 8),
              //       Text(
              //         'Plan your journey with comfort and convenience',
              //         style: AppSizes.bodyMedium.copyWith(
              //           color: Colors.grey[600],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 20),

              // Location Input Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Pickup Location
                    Row(
                      children: [
                        const SizedBox(width: 1),
                        Expanded(
                          child: CabSearchBar(
                            hintText: 'Enter pickup location',
                            onChanged:
                                (value) => ref
                                    .read(cabBookingProvider.notifier)
                                    .updatePickupLocation(value),
                            initialValue: cabBookingState.pickupLocation,
                            icon: Icons.my_location,
                          ),
                        ),
                      ],
                    ),

                    // Dotted Line
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          const SizedBox(width: 1),
                          Expanded(
                            child: GestureDetector(
                              onTap:
                                  () =>
                                      ref
                                          .read(cabBookingProvider.notifier)
                                          .swapLocations(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.CabsAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.swap_vert,
                                  color: AppColors.CabsAccent,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Drop-off Location
                    Row(
                      children: [
                        const SizedBox(width: 1),
                        Expanded(
                          child: CabSearchBar(
                            hintText: 'Enter drop-off location',
                            onChanged:
                                (value) => ref
                                    .read(cabBookingProvider.notifier)
                                    .updateDropoffLocation(value),
                            initialValue: cabBookingState.dropoffLocation,
                            icon: Icons.place,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Recent Locations
              const SizedBox(height: 20),

              // Date & Time Selection
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: AppColors.CabsAccent,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'When do you want to go?',
                          style: AppSizes.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final dateTime = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 30),
                                ),
                              );
                              if (dateTime != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  final selectedDateTime = DateTime(
                                    dateTime.year,
                                    dateTime.month,
                                    dateTime.day,
                                    time.hour,
                                    time.minute,
                                  );
                                  ref
                                      .read(cabBookingProvider.notifier)
                                      .updatePickupDateTime(selectedDateTime);
                                }
                              }
                            },
                            icon: const Icon(Icons.calendar_today, size: 20),
                            label: Text(
                              cabBookingState.pickupDateTime != null
                                  ? _formatDateTime(
                                    cabBookingState.pickupDateTime!,
                                  )
                                  : 'Select Date & Time',
                              style: AppSizes.bodyMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.CabsAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                        if (cabBookingState.isScheduled) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.3),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Scheduled',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Fare Estimation
              if (cabBookingState.estimatedFare != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.CabsAccent.withOpacity(0.1),
                        AppColors.CabsAccent.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.CabsAccent.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimated Fare',
                              style: AppSizes.bodyMedium.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '₹${cabBookingState.estimatedFare!.toStringAsFixed(0)}',
                              style: AppSizes.headingMedium.copyWith(
                                color: AppColors.CabsAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.CabsAccent.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          '${cabBookingState.estimatedDistance!.toStringAsFixed(1)} km',
                          style: const TextStyle(
                            color: AppColors.CabsAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 30),

              // Find Rides Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      cabBookingState.pickupLocation.isNotEmpty &&
                              cabBookingState.dropoffLocation.isNotEmpty &&
                              cabBookingState.pickupDateTime != null
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const RideSelectionScreen(),
                              ),
                            );
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.CabsAccent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation:
                        cabBookingState.pickupLocation.isNotEmpty &&
                                cabBookingState.dropoffLocation.isNotEmpty &&
                                cabBookingState.pickupDateTime != null
                            ? 8
                            : 0,
                    shadowColor: AppColors.CabsAccent.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Find Available Rides',
                        style: AppSizes.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              if (cabBookingState.recentLocations.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Locations',
                        style: AppSizes.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...cabBookingState.recentLocations
                          .map(
                            (location) => GestureDetector(
                              onTap:
                                  () => ref
                                      .read(cabBookingProvider.notifier)
                                      .updateDropoffLocation(location),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.history,
                                      color: Colors.grey[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        location,
                                        style: AppSizes.bodyMedium.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey[400],
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ],

              // Quick Actions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: AppSizes.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickAction(
                            icon: Icons.schedule,
                            title: 'Schedule Ride',
                            subtitle: 'Book for later',
                            color: Colors.blue,
                            onTap: () {
                              // Schedule ride action
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickAction(
                            icon: Icons.local_offer,
                            title: 'View Offers',
                            subtitle: 'Save more',
                            color: Colors.green,
                            onTap: () {
                              // View offers action
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 14,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (targetDate == today) {
      dateStr = 'Today';
    } else if (targetDate == today.add(const Duration(days: 1))) {
      dateStr = 'Tomorrow';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}';
    }

    final timeStr =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr, $timeStr';
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.grey[400]!
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    const double dashHeight = 3;
    const double dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
