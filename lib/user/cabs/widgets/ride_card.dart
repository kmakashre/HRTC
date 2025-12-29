import 'package:flutter/material.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/cabs/provider/cab_ride.dart';

class RideCard extends StatelessWidget {
  final RideOption ride;
  final VoidCallback onSelect;
  final bool isSelected;
  final double? estimatedFare;

  const RideCard({
    Key? key,
    required this.ride,
    required this.onSelect,
    this.isSelected = false,
    this.estimatedFare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Container(
      margin: AppSizes.paddingVerticalSmall,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSizes.radiusMedium,
        border: Border.all(
          color: isSelected ? AppColors.CabsAccent : Colors.transparent,
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
          onTap: ride.isAvailable ? onSelect : null,
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
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: AppSizes.radiusSmall,
                        ),
                        child: Icon(
                          Icons.directions_car,
                          color: Colors.grey[400],
                          size: 32,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: AppSizes.radiusSmall,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.CabsAccent,
                            ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ride.name,
                              style: AppSizes.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    ride.isAvailable
                                        ? AppColors.textPrimary
                                        : Colors.grey,
                              ),
                            ),
                          ),
                          if (!ride.isAvailable)
                            Container(
                              padding: AppSizes.paddingHorizontalSmall,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: AppSizes.radiusSmall,
                              ),
                              child: Text(
                                'Unavailable',
                                style: AppSizes.caption.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),

                      AppSizes.verticalSpaceTinyBox,

                      Text(
                        ride.description,
                        style: AppSizes.bodySmall.copyWith(
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
                            style: AppSizes.bodySmall.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),

                          AppSizes.horizontalSpaceSmallBox,

                          // Rating
                          Icon(
                            Icons.star,
                            size: AppSizes.iconSmall,
                            color: Colors.amber,
                          ),
                          AppSizes.horizontalSpaceTinyBox,
                          Text(
                            ride.rating.toString(),
                            style: AppSizes.bodySmall.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),

                          AppSizes.horizontalSpaceSmallBox,

                          // ETA
                          Icon(
                            Icons.access_time,
                            size: AppSizes.iconSmall,
                            color: Colors.grey[600],
                          ),
                          AppSizes.horizontalSpaceTinyBox,
                          Text(
                            ride.estimatedTime,
                            style: AppSizes.bodySmall.copyWith(
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
                                    padding: AppSizes.paddingHorizontalSmall,
                                    decoration: BoxDecoration(
                                      color: AppColors.CabsAccent.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: AppSizes.radiusSmall,
                                    ),
                                    child: Text(
                                      feature,
                                      style: AppSizes.caption.copyWith(
                                        color: AppColors.CabsAccent,
                                        fontWeight: FontWeight.w500,
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      estimatedFare != null
                          ? '₹${estimatedFare!.toStringAsFixed(0)}'
                          : '₹${ride.baseFare.toStringAsFixed(0)}',
                      style: AppSizes.headingMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            ride.isAvailable
                                ? AppColors.CabsAccent
                                : Colors.grey,
                      ),
                    ),

                    AppSizes.verticalSpaceTinyBox,

                    Text(
                      estimatedFare != null ? 'Est. total' : 'Base fare',
                      style: AppSizes.caption.copyWith(color: Colors.grey[600]),
                    ),

                    AppSizes.verticalSpaceTinyBox,

                    if (ride.isAvailable)
                      Container(
                        padding: AppSizes.paddingHorizontalSmall,
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.CabsAccent
                                  : AppColors.CabsAccent.withOpacity(0.1),
                          borderRadius: AppSizes.radiusSmall,
                        ),
                        child: Text(
                          isSelected ? 'Selected' : 'Select',
                          style: AppSizes.caption.copyWith(
                            color:
                                isSelected
                                    ? Colors.white
                                    : AppColors.CabsAccent,
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
  }
}
