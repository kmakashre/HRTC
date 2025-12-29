import 'package:flutter/material.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';

class BookingSummary extends StatelessWidget {
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime? pickupDateTime;
  final String rideName;
  final double pricePerKm;

  const BookingSummary({
    Key? key,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.pickupDateTime,
    required this.rideName,
    required this.pricePerKm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    return Card(
      elevation: AppSizes.elevationMedium,
      shape: RoundedRectangleBorder(borderRadius: AppSizes.radiusMedium),
      child: Padding(
        padding: AppSizes.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trip Details', style: AppSizes.headingMedium),
            AppSizes.verticalSpaceSmallBox,
            _buildDetailRow('Pickup', pickupLocation),
            AppSizes.verticalSpaceTinyBox,
            _buildDetailRow('Drop-off', dropoffLocation),
            AppSizes.verticalSpaceTinyBox,
            _buildDetailRow(
              'Date & Time',
              pickupDateTime != null
                  ? pickupDateTime!.toString().substring(0, 16)
                  : 'Not set',
            ),
            AppSizes.verticalSpaceTinyBox,
            _buildDetailRow('Ride Type', rideName),
            AppSizes.verticalSpaceTinyBox,
            _buildDetailRow('Price', '₹$pricePerKm/km'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppSizes.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: AppSizes.bodyMedium.copyWith(color: AppColors.CabsAccent),
        ),
      ],
    );
  }
}
