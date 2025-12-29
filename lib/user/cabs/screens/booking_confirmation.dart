import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/cabs/provider/cab_booking.dart';
import 'package:hrtc/user/cabs/provider/cab_ride.dart' show cabRideProvider;
import 'package:hrtc/user/cabs/widgets/booking_summary.dart';

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  const BookingConfirmationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends ConsumerState<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppSizes.radiusLarge),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: 24,
              ),
              SizedBox(width: AppSizes.bodySmallSize),
              Text(
                'Confirm Booking',
                style: AppSizes.headingMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to confirm this booking? This action cannot be undone.',
            style: AppSizes.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppSizes.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmBooking();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.CabsAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: AppSizes.radiusMedium,
                ),
              ),
              child: Text(
                'Confirm',
                style: AppSizes.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmBooking() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ref.read(cabBookingProvider.notifier).reset();

      // Show success animation
      _showSuccessDialog();

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppSizes.radiusLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: AppSizes.bodySmallSize),
              Text(
                'Booking Confirmed!',
                style: AppSizes.headingMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              SizedBox(height: AppSizes.bodySmallSize),
              Text(
                'Your cab has been booked successfully. You will receive a confirmation SMS shortly.',
                style: AppSizes.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.bodySmallSize),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.CabsAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSizes.radiusMedium,
                  ),
                  minimumSize: const Size(120, 40),
                ),
                child: Text(
                  'Done',
                  style: AppSizes.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final cabBookingState = ref.watch(cabBookingProvider);
    final rideState = ref.watch(cabRideProvider);
    final selectedRide = rideState.rideOptions.firstWhere(
      (ride) => ride.id == cabBookingState.selectedRideId,
      orElse: () => rideState.rideOptions[0],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm Booking',
          style: AppSizes.headingMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            child: Padding(
              padding: AppSizes.paddingAllMedium,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: AppSizes.paddingAllMedium,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppSizes.radiusLarge,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.receipt_long_rounded,
                              color: AppColors.CabsAccent,
                              size: 24,
                            ),
                            SizedBox(width: AppSizes.bodySmallSize),
                            Text(
                              'Booking Summary',
                              style: AppSizes.headingLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.bodySmallSize),
                        Text(
                          'Please review your booking details below',
                          style: AppSizes.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSizes.verticalSpaceMediumBox,
                  // Booking Summary Card
                  Expanded(
                    child: BookingSummary(
                      pickupLocation: cabBookingState.pickupLocation,
                      dropoffLocation: cabBookingState.dropoffLocation,
                      pickupDateTime: cabBookingState.pickupDateTime,
                      rideName: selectedRide.name,
                      pricePerKm: selectedRide.pricePerKm,
                    ),
                  ),

                  AppSizes.verticalSpaceMediumBox,

                  // Terms and Conditions
                  Container(
                    padding: AppSizes.paddingAllMedium,
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: AppSizes.radiusMedium,
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        SizedBox(width: AppSizes.bodySmallSize),
                        Expanded(
                          child: Text(
                            'By confirming this booking, you agree to our terms and conditions. Cancellation charges may apply.',
                            style: AppSizes.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppSizes.verticalSpaceMediumBox,

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.CabsAccent,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSizes.radiusLarge,
                            ),
                            minimumSize: Size(0, AppSizes.buttonHeight),
                          ),
                          child: Text(
                            'Back',
                            style: AppSizes.bodyLarge.copyWith(
                              color: AppColors.CabsAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSizes.bodySmallSize),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed:
                              _isLoading ? null : _showConfirmationDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.CabsAccent,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSizes.radiusLarge,
                            ),
                            minimumSize: Size(0, AppSizes.buttonHeight),
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: AppSizes.bodySmallSize),
                                      Text(
                                        'Confirm Booking',
                                        style: AppSizes.bodyLarge.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                    ],
                  ),

                  AppSizes.verticalSpaceMediumBox,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
