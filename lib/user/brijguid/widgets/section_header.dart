// widgets/section_header.dart
import 'package:flutter/material.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onSeeAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSizes.paddingAllMedium,
      decoration: BoxDecoration(
        color: AppColors.surface,
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
            padding: AppSizes.paddingAllSmall,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.servicesGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppSizes.radiusSmall,
            ),
            child: Icon(icon, size: AppSizes.iconMedium, color: Colors.white),
          ),
          AppSizes.horizontalSpaceMediumBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppSizes.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppSizes.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Container(
                padding: AppSizes.paddingAllSmall,
                decoration: BoxDecoration(
                  color: AppColors.servicesAccent.withOpacity(0.1),
                  borderRadius: AppSizes.radiusSmall,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See All',
                      style: AppSizes.caption.copyWith(
                        color: AppColors.servicesAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSizes.horizontalSpaceTinyBox,
                    Icon(
                      Icons.arrow_forward_ios,
                      size: AppSizes.iconTiny,
                      color: AppColors.servicesAccent,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
