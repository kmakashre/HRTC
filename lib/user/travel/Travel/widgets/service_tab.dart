import 'package:flutter/material.dart';import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/travel/Travel/provider/travel_Provider.dart';

class ServiceTab extends ConsumerWidget {
  // final int index;

  const ServiceTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelState = ref.watch(travelProvider);

    final tabs = [
      {
        'title': 'Flights',
        'icon': Icons.flight_takeoff,
        'subtitle': 'Book flights',
        'color': AppColors.travelAccent,
        'gradient': AppColors.travelGradient,
      },
      // {
      //   'title': 'Buses',
      //   'icon': Icons.directions_bus,
      //   'subtitle': 'Bus tickets',
      //   'color': AppColors.travelAccent,
      //   'gradient': AppColors.travelGradient,
      // },
    ];

    // final tabData = tabs[index];
    // final isSelected = travelState.tabIndex == index;

    return GestureDetector(
      onTap: () {
        // ref.read(travelProvider.notifier).setTabIndex(index);
        // Add haptic feedback
        // HapticFeedback.selectionClick();
      },
      child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            margin: EdgeInsets.only(right: AppSizes.paddingSmall),
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
              vertical: AppSizes.paddingMedium,
            ),
            // decoration: BoxDecoration(
            //   gradient:
            //       isSelected
            //           ? LinearGradient(
            //             colors: tabData['gradient'] as List<Color>,
            //             begin: Alignment.topLeft,
            //             end: Alignment.bottomRight,
            //           )
            //           : null,
            //   color: isSelected ? null : AppColors.cardBackground,
            //   borderRadius: BorderRadius.circular(
            //     AppSizes.radiusMedium.topLeft.x,
            //   ),
            //   boxShadow: [
            //     if (isSelected)
            //       BoxShadow(
            //         color: (tabData['color'] as Color).withOpacity(0.3),
            //         blurRadius: AppSizes.elevationMedium,
            //         offset: const Offset(0, 4),
            //         spreadRadius: 0,
            //       )
            //     else
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.05),
            //         blurRadius: AppSizes.elevationLow,
            //         offset: const Offset(0, 2),
            //       ),
            //   ],
            //   border:
            //       isSelected
            //           ? null
            //           : Border.all(
            //             color: AppColors.textLight.withOpacity(0.1),
            //             width: 1,
            //           ),
            // ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Icon Container
                // AnimatedContainer(
                //   duration: const Duration(milliseconds: 300),
                //   padding: EdgeInsets.all(AppSizes.paddingTiny),
                //   decoration: BoxDecoration(
                //     color:
                //         isSelected
                //             ? Colors.white.withOpacity(0.2)
                //             : (tabData['color'] as Color).withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(
                //       AppSizes.radiusSmall.topLeft.x,
                //     ),
                //   ),
                //   child: Icon(
                //     tabData['icon'] as IconData,
                //     color:
                //         isSelected ? Colors.white : tabData['color'] as Color,
                //     size: AppSizes.iconSmall,
                //   ),
                // ),

                SizedBox(width: AppSizes.paddingSmall),

                // Text Content
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     // Text(
                //     //   tabData['title'] as String,
                //     //   style: AppSizes.bodyMedium.copyWith(
                //     //     color:
                //     //         isSelected ? Colors.white : AppColors.textPrimary,
                //     //     fontWeight:
                //     //         isSelected ? FontWeight.w700 : FontWeight.w600,
                //     //     letterSpacing: 0.5,
                //     //   ),
                //     // ),
                //     if (isSelected) ...[
                //       const SizedBox(height: 2),
                //       Text(
                //         tabData['subtitle'] as String,
                //         style: AppSizes.bodySmall.copyWith(
                //           color: Colors.white.withOpacity(0.9),
                //           fontSize: AppSizes.bodySmallSize * 0.85,
                //         ),
                //       ),
                //     ],
                //   ],
                // ),

                // Selection Indicator
                // if (isSelected) ...[
                //   SizedBox(width: AppSizes.paddingSmall),
                //   Container(
                //         width: 6,
                //         height: 6,
                //         decoration: const BoxDecoration(
                //           color: Colors.white,
                //           shape: BoxShape.circle,
                //         ),
                //       )
                //       .animate(target: isSelected ? 1 : 0)
                //       .scale(duration: 200.ms)
                //       .then()
                //       .shimmer(
                //         duration: 1000.ms,
                //         color: Colors.white.withOpacity(0.5),
                //       ),
                // ],
              ],
            ),
          )
          // .animate(target: isSelected ? 1 : 0)
          // .scale(
          //   duration: 200.ms,
          //   begin: const Offset(0.95, 0.95),
          //   end: const Offset(1.0, 1.0),
          //   curve: Curves.easeOutBack,
          // )
          // .then()
          // .animate(target: isSelected ? 1 : 0)
          // .shimmer(
          //   delay: 300.ms,
          //   duration: 1500.ms,
          //   color: Colors.white.withOpacity(0.3),
          // ),
    );
  }
}
