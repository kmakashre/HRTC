import 'package:flutter/material.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/brijguid/screens/temple_details.dart';

import '../models/temple_model.dart';

class TempleCard extends StatelessWidget {
  final Temple temple;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const TempleCard({
    Key? key,
    required this.temple,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TempleDetailsScreen(temple: temple),
          ),
        );
      },
      child: Container(
        width: AppSizes.screenWidth * 0.75,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSizes.radiusMedium,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildImageSection(), _buildContentSection()],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Container(
          height: AppSizes.screenHeight * 0.23,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.radiusMedium.topLeft.x),
              topRight: Radius.circular(AppSizes.radiusMedium.topRight.x),
            ),
            image: DecorationImage(
              image: NetworkImage(temple.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Positioned(
          top: AppSizes.paddingSmall,
          right: AppSizes.paddingSmall,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: AppSizes.paddingAllSmall,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: AppSizes.radiusSmall,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: AppSizes.iconSmall,
                color: isFavorite ? AppColors.error : AppColors.textSecondary,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: AppSizes.paddingSmall,
          left: AppSizes.paddingSmall,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingSmall,
              vertical: AppSizes.paddingTiny,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: AppSizes.radiusSmall,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: AppSizes.iconTiny,
                  color: AppColors.warning,
                ),
                AppSizes.horizontalSpaceTinyBox,
                Text(
                  temple.rating.toString(),
                  style: AppSizes.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSizes.horizontalSpaceTinyBox,
                Text(
                  '(${temple.reviewCount})',
                  style: AppSizes.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: AppSizes.paddingAllMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            temple.name,
            style: AppSizes.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          AppSizes.verticalSpaceTinyBox,
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: AppSizes.iconTiny,
                color: AppColors.textSecondary,
              ),
              AppSizes.horizontalSpaceTinyBox,
              Expanded(
                child: Text(
                  temple.location,
                  style: AppSizes.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          AppSizes.verticalSpaceSmallBox,
          Text(
            temple.description,
            style: AppSizes.caption.copyWith(
              color: AppColors.textLight,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          AppSizes.verticalSpaceSmallBox,
          Row(
            children: [
              _buildFeatureTag(temple.builtYear),
              AppSizes.horizontalSpaceTinyBox,
              _buildFeatureTag(temple.entryFee),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSmall,
        vertical: AppSizes.paddingTiny,
      ),
      decoration: BoxDecoration(
        color: AppColors.servicesAccent.withOpacity(0.1),
        borderRadius: AppSizes.radiusSmall,
      ),
      child: Text(
        text,
        style: AppSizes.caption.copyWith(
          color: AppColors.servicesAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
