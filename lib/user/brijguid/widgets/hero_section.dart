// widgets/hero_section.dart
import 'package:flutter/material.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSizes.paddingHorizontalMedium,
      child: Column(
        children: [
          _buildWelcomeCard(),
          AppSizes.verticalSpaceMediumBox,
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: AppSizes.paddingAllLarge,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.servicesGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSizes.radiusLarge,
        boxShadow: [
          BoxShadow(
            color: AppColors.servicesAccent.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSizes.paddingAllSmall,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: AppSizes.radiusSmall,
                ),
                child: Icon(
                  Icons.temple_hindu,
                  size: AppSizes.iconMedium,
                  color: Colors.white,
                ),
              ),
              AppSizes.horizontalSpaceMediumBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Braj Bhumi',
                      style: AppSizes.headingMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'The Sacred Land of Lord Krishna',
                      style: AppSizes.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSizes.verticalSpaceSmallBox,
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.white.withOpacity(0.2),
          ),
          AppSizes.verticalSpaceSmallBox,
          Text(
            'Embark on a spiritual journey through the holy temples of Vrindavan. Experience divine darshan, learn ancient stories, and connect with expert guides who will make your pilgrimage unforgettable.',
            style: AppSizes.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.95),
              height: 1.5,
            ),
          ),
          AppSizes.verticalSpaceMediumBox,
          Row(
            children: [
              _buildFeatureChip('🕉️ Sacred Temples'),
              AppSizes.horizontalSpaceSmallBox,
              _buildFeatureChip('🎯 Expert Guides'),
            ],
          ),
          AppSizes.verticalSpaceSmallBox,
          Row(
            children: [
              _buildFeatureChip('📱 Digital Darshan'),
              AppSizes.horizontalSpaceSmallBox,
              _buildFeatureChip('🌟 Spiritual Stories'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSmall,
        vertical: AppSizes.paddingTiny,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: AppSizes.radiusSmall,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: AppSizes.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.temple_hindu,
            title: '50+',
            subtitle: 'Sacred Temples',
            color: AppColors.servicesAccent,
          ),
        ),
        AppSizes.horizontalSpaceSmallBox,
        Expanded(
          child: _buildStatCard(
            icon: Icons.person_pin,
            title: '25+',
            subtitle: 'Expert Guides',
            color: AppColors.travelAccent,
          ),
        ),
        AppSizes.horizontalSpaceSmallBox,
        Expanded(
          child: _buildStatCard(
            icon: Icons.star,
            title: '4.8',
            subtitle: 'Rating',
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: AppSizes.paddingAllMedium,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSizes.radiusMedium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: AppSizes.paddingAllSmall,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: AppSizes.radiusSmall,
            ),
            child: Icon(icon, size: AppSizes.iconMedium, color: color),
          ),
          AppSizes.verticalSpaceSmallBox,
          Text(
            title,
            style: AppSizes.headingSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            subtitle,
            style: AppSizes.caption.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
