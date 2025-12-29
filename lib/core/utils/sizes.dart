import 'package:flutter/material.dart';
import 'colors.dart';

class AppSizes {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeScreenWidth;
  static late double safeScreenHeight;

  // Device type detection
  static bool get isMobile => screenWidth < 650;
  static bool get isTablet => screenWidth >= 650 && screenWidth < 1100;
  static bool get isDesktop => screenWidth >= 1100;

  // Initialize responsive values
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeScreenWidth = screenWidth - safeAreaHorizontal;
    safeScreenHeight = screenHeight - safeAreaVertical;
  }

  // Font sizes based on screen width percentage
  static double get headingLargeSize =>
      screenWidth * 0.065; // ~6.5% of screen width
  static double get headingMediumSize =>
      screenWidth * 0.055; // ~5.5% of screen width
  static double get headingSmallSize =>
      screenWidth * 0.045; // ~4.5% of screen width
  static double get bodyLargeSize => screenWidth * 0.04; // ~4% of screen width
  static double get bodyMediumSize =>
      screenWidth * 0.035; // ~3.5% of screen width
  static double get bodySmallSize => screenWidth * 0.03; // ~3% of screen width

  // Caption and label sizes
  static double get captionSize => screenWidth * 0.025; // ~2.5% of screen width
  static double get labelSize => screenWidth * 0.032; // ~3.2% of screen width

  // Responsive text styles
  static TextStyle get headingLarge => TextStyle(
    fontSize: headingLargeSize,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static TextStyle get headingMedium => TextStyle(
    fontSize: headingMediumSize,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static TextStyle get headingSmall => TextStyle(
    fontSize: headingSmallSize,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static TextStyle get bodyLarge => TextStyle(
    fontSize: bodyLargeSize,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static TextStyle get bodyMedium => TextStyle(
    fontSize: bodyMediumSize,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: bodySmallSize,
    color: AppColors.textLight,
    fontFamily: 'Poppins',
  );

  static TextStyle get caption => TextStyle(
    fontSize: captionSize,
    color: AppColors.textLight,
    fontFamily: 'Poppins',
  );

  static TextStyle get label => TextStyle(
    fontSize: labelSize,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

  // Spacing based on screen dimensions
  static double get paddingTiny => screenWidth * 0.01; // ~1% of screen width
  static double get paddingSmall => screenWidth * 0.02; // ~2% of screen width
  static double get paddingMedium => screenWidth * 0.04; // ~4% of screen width
  static double get paddingLarge => screenWidth * 0.06; // ~6% of screen width
  static double get paddingExtraLarge =>
      screenWidth * 0.08; // ~8% of screen width

  // Vertical spacing based on screen height
  static double get verticalSpaceTiny =>
      screenHeight * 0.005; // ~0.5% of screen height
  static double get verticalSpaceSmall =>
      screenHeight * 0.01; // ~1% of screen height
  static double get verticalSpaceMedium =>
      screenHeight * 0.02; // ~2% of screen height
  static double get verticalSpaceLarge =>
      screenHeight * 0.03; // ~3% of screen height
  static double get verticalSpaceExtraLarge =>
      screenHeight * 0.05; // ~5% of screen height

  // Margins (same as padding for consistency)
  static double get marginTiny => paddingTiny;
  static double get marginSmall => paddingSmall;
  static double get marginMedium => paddingMedium;
  static double get marginLarge => paddingLarge;
  static double get marginExtraLarge => paddingExtraLarge;

  // Heights based on screen height percentage
  static double get buttonHeight => screenHeight * 0.06; // ~6% of screen height
  static double get inputFieldHeight =>
      screenHeight * 0.055; // ~5.5% of screen height
  static double get cardHeight => screenHeight * 0.15; // ~15% of screen height
  static double get cardHeightSmall =>
      screenHeight * 0.1; // ~10% of screen height
  static double get cardHeightLarge =>
      screenHeight * 0.25; // ~25% of screen height
  static double get appBarHeight => screenHeight * 0.08; // ~8% of screen height
  static double get bottomNavHeight =>
      screenHeight * 0.08; // ~8% of screen height
  static double get tabBarHeight => screenHeight * 0.06; // ~6% of screen height

  // Widths based on screen width percentage
  static double get maxContentWidth =>
      screenWidth * 0.9; // ~90% of screen width
  static double get cardWidth => screenWidth * 0.85; // ~85% of screen width
  static double get buttonWidth => screenWidth * 0.8; // ~80% of screen width
  static double get dialogWidth => screenWidth * 0.85; // ~85% of screen width
  static double get sidebarWidth => screenWidth * 0.7; // ~70% of screen width

  // Icon sizes based on screen width
  static double get iconTiny => screenWidth * 0.03; // ~3% of screen width
  static double get iconSmall => screenWidth * 0.04; // ~4% of screen width
  static double get iconMedium => screenWidth * 0.06; // ~6% of screen width
  static double get iconLarge => screenWidth * 0.08; // ~8% of screen width
  static double get iconExtraLarge =>
      screenWidth * 0.12; // ~12% of screen width

  // Avatar and profile image sizes
  static double get avatarSmall => screenWidth * 0.08; // ~8% of screen width
  static double get avatarMedium => screenWidth * 0.12; // ~12% of screen width
  static double get avatarLarge => screenWidth * 0.2; // ~20% of screen width

  // Border radius based on screen width
  static BorderRadius get radiusTiny =>
      BorderRadius.circular(screenWidth * 0.01);
  static BorderRadius get radiusSmall =>
      BorderRadius.circular(screenWidth * 0.02);
  static BorderRadius get radiusMedium =>
      BorderRadius.circular(screenWidth * 0.03);
  static BorderRadius get radiusLarge =>
      BorderRadius.circular(screenWidth * 0.04);
  static BorderRadius get radiusExtraLarge =>
      BorderRadius.circular(screenWidth * 0.06);
  static BorderRadius get radiusCircular =>
      BorderRadius.circular(screenWidth * 0.5);

  // Elevation values
  static double get elevationLow => 2.0;
  static double get elevationMedium => 4.0;
  static double get elevationHigh => 8.0;

  // Border widths
  static double get borderThin => screenWidth * 0.002; // ~0.2% of screen width
  static double get borderMedium =>
      screenWidth * 0.004; // ~0.4% of screen width
  static double get borderThick => screenWidth * 0.008; // ~0.8% of screen width

  // Grid and list spacing
  static double get gridSpacing => screenWidth * 0.02; // ~2% of screen width
  static double get listItemSpacing =>
      screenHeight * 0.01; // ~1% of screen height

  // Image dimensions
  static double get imageSmall => screenWidth * 0.15; // ~15% of screen width
  static double get imageMedium => screenWidth * 0.25; // ~25% of screen width
  static double get imageLarge => screenWidth * 0.4; // ~40% of screen width
  static double get imageExtraLarge =>
      screenWidth * 0.6; // ~60% of screen width

  // Container dimensions
  static double get containerSmall => screenWidth * 0.2; // ~20% of screen width
  static double get containerMedium =>
      screenWidth * 0.4; // ~40% of screen width
  static double get containerLarge => screenWidth * 0.6; // ~60% of screen width
  static double get containerExtraLarge =>
      screenWidth * 0.8; // ~80% of screen width

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // Helper methods for custom percentage-based sizing
  static double widthPercent(double percent) => screenWidth * (percent / 100);
  static double heightPercent(double percent) => screenHeight * (percent / 100);
  static double safeWidthPercent(double percent) =>
      safeScreenWidth * (percent / 100);
  static double safeHeightPercent(double percent) =>
      safeScreenHeight * (percent / 100);

  // Responsive spacing helpers using screen percentages
  static EdgeInsets get paddingHorizontalTiny =>
      EdgeInsets.symmetric(horizontal: paddingTiny);
  static EdgeInsets get paddingHorizontalSmall =>
      EdgeInsets.symmetric(horizontal: paddingSmall);
  static EdgeInsets get paddingHorizontalMedium =>
      EdgeInsets.symmetric(horizontal: paddingMedium);
  static EdgeInsets get paddingHorizontalLarge =>
      EdgeInsets.symmetric(horizontal: paddingLarge);

  static EdgeInsets get paddingVerticalTiny =>
      EdgeInsets.symmetric(vertical: verticalSpaceTiny);
  static EdgeInsets get paddingVerticalSmall =>
      EdgeInsets.symmetric(vertical: verticalSpaceSmall);
  static EdgeInsets get paddingVerticalMedium =>
      EdgeInsets.symmetric(vertical: verticalSpaceMedium);
  static EdgeInsets get paddingVerticalLarge =>
      EdgeInsets.symmetric(vertical: verticalSpaceLarge);

  static EdgeInsets get paddingAllTiny => EdgeInsets.all(paddingTiny);
  static EdgeInsets get paddingAllSmall => EdgeInsets.all(paddingSmall);
  static EdgeInsets get paddingAllMedium => EdgeInsets.all(paddingMedium);
  static EdgeInsets get paddingAllLarge => EdgeInsets.all(paddingLarge);

  // Custom padding helper
  static EdgeInsets customPadding({
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsets.only(
      top: top ?? vertical ?? 0,
      bottom: bottom ?? vertical ?? 0,
      left: left ?? horizontal ?? 0,
      right: right ?? horizontal ?? 0,
    );
  }

  // SizedBox helpers
  static Widget get verticalSpaceTinyBox => SizedBox(height: verticalSpaceTiny);
  static Widget get verticalSpaceSmallBox =>
      SizedBox(height: verticalSpaceSmall);
  static Widget get verticalSpaceMediumBox =>
      SizedBox(height: verticalSpaceMedium);
  static Widget get verticalSpaceLargeBox =>
      SizedBox(height: verticalSpaceLarge);
  static Widget get verticalSpaceExtraLargeBox =>
      SizedBox(height: verticalSpaceExtraLarge);

  static Widget get horizontalSpaceTinyBox => SizedBox(width: paddingTiny);
  static Widget get horizontalSpaceSmallBox => SizedBox(width: paddingSmall);
  static Widget get horizontalSpaceMediumBox => SizedBox(width: paddingMedium);
  static Widget get horizontalSpaceLargeBox => SizedBox(width: paddingLarge);
  static Widget get horizontalSpaceExtraLargeBox =>
      SizedBox(width: paddingExtraLarge);

  // App-specific constants
  static const String appName = "HRTC";
  static const String appSlogan = "Your complete travel companion";

  // Tab names
  static const List<String> tabNames = [
    "HRTC",
    "Hotels",
    "Restaurants",
    "Travel",
    "Brij Guide",
  ];

  // Tab icons
  static const List<String> tabIcons = [
    "assets/icons/hrtc_logo.png",
    "assets/icons/hotel_logo.png",
    "assets/icons/restaurant_logo.png",
    "assets/icons/travel_logo.png",
    "assets/icons/bridgeguide_logo.png",
  ];

  // Responsive layout helpers
  static Widget responsiveBuilder({
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  static T responsiveValue<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // Grid columns based on screen width
  static int get gridColumns {
    if (screenWidth < 400) return 1;
    if (screenWidth < 600) return 2;
    if (screenWidth < 900) return 3;
    if (screenWidth < 1200) return 4;
    return 5;
  }

  // Responsive aspect ratios
  static double get cardAspectRatio => screenWidth > 600 ? 1.2 : 1.5;
  static double get imageAspectRatio => screenWidth > 600 ? 16 / 9 : 4 / 3;
}
