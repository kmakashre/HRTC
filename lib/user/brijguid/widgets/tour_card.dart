import 'package:flutter/material.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/brijguid/models/temple_model.dart';
import 'package:hrtc/user/brijguid/screens/guid_booking.dart';

class TourGuideCard extends StatelessWidget {
  final TourGuide guide;
  final bool isSelected;
  final VoidCallback onTap;

  const TourGuideCard({
    Key? key,
    required this.guide,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuideBookingScreen(guide: guide),
          ),
        );
      },
      child: Container(
        width: AppSizes.screenWidth * 0.7,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSizes.radiusMedium,
          border:
              isSelected
                  ? Border.all(color: AppColors.servicesAccent, width: 2)
                  : null,
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? AppColors.servicesAccent.withOpacity(0.2)
                      : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 20 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            _buildContentSection(),
            _buildFooterSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: AppSizes.paddingAllMedium,
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: AppSizes.avatarMedium,
                height: AppSizes.avatarMedium,
                decoration: BoxDecoration(
                  borderRadius: AppSizes.radiusSmall,
                  image: DecorationImage(
                    image: NetworkImage(guide.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (!guide.isAvailable)
                Container(
                  width: AppSizes.avatarMedium,
                  height: AppSizes.avatarMedium,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: AppSizes.radiusSmall,
                  ),
                  child: Center(
                    child: Text(
                      'BUSY',
                      style: AppSizes.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: AppSizes.iconSmall,
                  height: AppSizes.iconSmall,
                  decoration: BoxDecoration(
                    color:
                        guide.isAvailable ? AppColors.success : AppColors.error,
                    borderRadius: AppSizes.radiusCircular,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
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
                  guide.name,
                  style: AppSizes.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSizes.verticalSpaceTinyBox,
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: AppSizes.iconTiny,
                      color: AppColors.warning,
                    ),
                    AppSizes.horizontalSpaceTinyBox,
                    Text(
                      guide.rating.toString(),
                      style: AppSizes.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSizes.horizontalSpaceTinyBox,
                    Text(
                      '(${guide.reviewCount})',
                      style: AppSizes.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                AppSizes.verticalSpaceTinyBox,
                Text(
                  guide.experience,
                  style: AppSizes.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Languages',
            style: AppSizes.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppSizes.verticalSpaceTinyBox,
          Wrap(
            spacing: AppSizes.paddingTiny,
            children:
                guide.languages.map((language) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingSmall,
                      vertical: AppSizes.paddingTiny,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.travelAccent.withOpacity(0.1),
                      borderRadius: AppSizes.radiusSmall,
                    ),
                    child: Text(
                      language,
                      style: AppSizes.caption.copyWith(
                        color: AppColors.travelAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
          ),
          AppSizes.verticalSpaceSmallBox,
          Text(
            'Specializations',
            style: AppSizes.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppSizes.verticalSpaceTinyBox,
          Column(
            children:
                guide.specializations.take(2).map((spec) {
                  return Container(
                    margin: EdgeInsets.only(bottom: AppSizes.paddingTiny),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: AppSizes.iconTiny,
                          color: AppColors.success,
                        ),
                        AppSizes.horizontalSpaceTinyBox,
                        Expanded(
                          child: Text(
                            spec,
                            style: AppSizes.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(BuildContext context) {
    return Container(
      padding: AppSizes.paddingAllMedium,
      // height: AppSizes.appBarHeight + 117,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.radiusMedium.bottomLeft.x),
          bottomRight: Radius.circular(AppSizes.radiusMedium.bottomRight.x),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Per Hour',
                      style: AppSizes.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '₹${guide.pricePerHour.toInt()}',
                      style: AppSizes.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Per Day',
                      style: AppSizes.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '₹${guide.pricePerDay.toInt()}',
                      style: AppSizes.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSizes.verticalSpaceMediumBox,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  guide.isAvailable
                      ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => GuideBookingScreen(guide: guide),
                          ),
                        );
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    guide.isAvailable
                        ? (isSelected
                            ? AppColors.servicesAccent
                            : AppColors.servicesAccent)
                        : AppColors.textSecondary.withOpacity(0.3),
                foregroundColor: Colors.white,
                elevation: isSelected ? 8 : 2,
                padding: AppSizes.paddingVerticalMedium,
                shape: RoundedRectangleBorder(
                  borderRadius: AppSizes.radiusSmall,
                ),
              ),
              child: Text(
                guide.isAvailable
                    ? (isSelected ? 'Selected' : 'Book Guide')
                    : 'Currently Unavailable',
                style: AppSizes.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (guide.isAvailable && !isSelected) ...[
            AppSizes.verticalSpaceSmallBox,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Handle contact action
                    },
                    icon: Icon(
                      Icons.phone,
                      size: AppSizes.iconSmall,
                      color: AppColors.primary,
                    ),
                    label: Text(
                      'Contact',
                      style: AppSizes.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSizes.radiusSmall,
                      ),
                      padding: AppSizes.paddingVerticalSmall,
                    ),
                  ),
                ),
                AppSizes.horizontalSpaceSmallBox,
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => GuideBookingScreen(guide: guide),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.person,
                      size: AppSizes.iconSmall,
                      color: AppColors.travelAccent,
                    ),
                    label: Text(
                      'Profile',
                      style: AppSizes.caption.copyWith(
                        color: AppColors.travelAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.travelAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSizes.radiusSmall,
                      ),
                      padding: AppSizes.paddingVerticalSmall,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
