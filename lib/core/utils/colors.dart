import 'package:flutter/material.dart';

class AppColors {
  // Primary color palette
  static const Color primary = Color(0xFF097d7a); // Main primary color
  static const Color primaryDark = Color(0xFF097d7a);
  static const Color primaryLight = Color(0xFF097d7a);

  // Secondary color palette
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color secondaryDark = Color(0xFFE05252);
  static const Color secondaryLight = Color(0xFFFF8A8A);

  // Accent colors for different sections
  static const Color hrtcAccent = Color(0xFF2A62AA); // Primary color
  static const Color hotelsAccent = Color(0xFF895737); // Green
  static const Color restaurantsAccent = Colors.redAccent; // Orange
  static const Color CabsAccent = Color(0xFFFF5912); // Orange
  static const Color travelAccent = Color(0xFF03A9F4); // Blue
  static const Color servicesAccent = Color(0xFF9C27B0); // Purple

  // Neutral colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFEB3B);
  static const Color info = Color(0xFF2196F3);

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFFFF5912),
    Color.fromARGB(255, 246, 111, 53),
  ];
  static const List<Color> secondaryGradient = [secondary, secondaryLight];

  // Section gradients
  static const List<Color> hrtcgradient = [
    Color(0xFF2A62AA),
    Color(0xFF2A62AA),
  ];
  static const List<Color> hotelsGradient = [
    Color(0xFF895737),
    Color(0xFF895737),
  ];
  static const List<Color> restaurantsGradient = [
    Colors.redAccent,
    Color.fromARGB(255, 245, 92, 92),
  ];
  static const List<Color> cabsGradient = [
    Color(0xFFFF5912),
    Color(0xFFFF5912),
  ];
  static const List<Color> travelGradient = [
    Color(0xFF03A9F4),
    Color(0xFF4FC3F7),
  ];
  static const List<Color> servicesGradient = [
    Color(0xFF9C27B0),
    Color(0xFFBA68C8),
  ];
}
