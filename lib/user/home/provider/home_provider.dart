import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';

// Tab names as a constant
const List<String> tabNames = [
  'HRTC',
  'Hotels',
  'Restaurants',
  'Travel',
  'Cabs',
  'Braj Darshan',
];

// Bottom navigation items
const List<Map<String, dynamic>> bottomNavItems = [
  {'icon': Icons.home_outlined, 'label': 'Home'},
  {'icon': Icons.notifications_outlined, 'label': 'Notifications'},
  {'icon': Icons.favorite_border, 'label': 'Favorites'},
  {'icon': Icons.person_outline, 'label': 'Profile'},
];

// Tab accent colors mapping
const Map<int, Color> tabAccentColors = {
  0: AppColors.hrtcAccent, // HRTC
  1: AppColors.hotelsAccent, // Hotels
  2: AppColors.restaurantsAccent, // Restaurants
  3: AppColors.travelAccent, // Travel
  4: AppColors.CabsAccent, // Cabs
  5: AppColors.servicesAccent, // BridgeGuide
};

// Tab icons mapping
const Map<int, IconData> tabIcons = {
  0: Icons.home_outlined, // HRTC
  1: Icons.hotel_outlined, // Hotels
  2: Icons.restaurant_outlined, // Restaurants
  3: Icons.flight_outlined, // Travel
  4: Icons.directions_car_outlined, // Cabs
  5: Icons.map_outlined, // BridgeGuide
};

// Home State Model
class HomeState {
  final int currentTabIndex;
  final int selectedNavIndex;
  final bool isTabBarVisible;
  final bool isLoading;

  const HomeState({
    this.currentTabIndex = 0,
    this.selectedNavIndex = 0,
    this.isTabBarVisible = true,
    this.isLoading = false,
  });

  HomeState copyWith({
    int? currentTabIndex,
    int? selectedNavIndex,
    bool? isTabBarVisible,
    bool? isLoading,
  }) {
    return HomeState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      isTabBarVisible: isTabBarVisible ?? this.isTabBarVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeState &&
        other.currentTabIndex == currentTabIndex &&
        other.selectedNavIndex == selectedNavIndex &&
        other.isTabBarVisible == isTabBarVisible &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode {
    return Object.hash(
      currentTabIndex,
      selectedNavIndex,
      isTabBarVisible,
      isLoading,
    );
  }
}

// Home State Notifier
class HomeStateNotifier extends StateNotifier<HomeState> {
  HomeStateNotifier() : super(const HomeState());

  // Change tab index
  void changeTab(int index) {
    if (index >= 0 &&
        index < tabNames.length &&
        index != state.currentTabIndex) {
      state = state.copyWith(currentTabIndex: index);
    }
  }

  // Change bottom navigation index
  void changeBottomNav(int index) {
    if (index >= 0 && index < bottomNavItems.length) {
      state = state.copyWith(selectedNavIndex: index);

      // If Home is selected, maintain current tab
      if (index == 0) {
        // Stay on current tab, don't change anything
        return;
      }

      // Handle other bottom nav items
      // You can add navigation logic here for other items
    }
  }

  // Set tab bar visibility
  void setTabBarVisibility(bool isVisible) {
    if (state.isTabBarVisible != isVisible) {
      state = state.copyWith(isTabBarVisible: isVisible);
    }
  }

  // Set loading state
  void setLoading(bool loading) {
    if (state.isLoading != loading) {
      state = state.copyWith(isLoading: loading);
    }
  }

  // Get current accent color
  Color get currentAccentColor {
    return tabAccentColors[state.currentTabIndex] ?? const Color(0xFFFF5912);
  }

  // Get current tab icon
  IconData get currentTabIcon {
    return tabIcons[state.currentTabIndex] ?? Icons.circle_outlined;
  }

  // Get current tab name
  String get currentTabName {
    return tabNames[state.currentTabIndex];
  }
}

// Provider for Home State
final homeStateProvider = StateNotifierProvider<HomeStateNotifier, HomeState>((
  ref,
) {
  return HomeStateNotifier();
});

// Provider for TabController - using Provider instead of StateNotifier for better performance
final tabControllerProvider = Provider.autoDispose
    .family<TabController, TickerProvider>((ref, vsync) {
      final controller = TabController(length: tabNames.length, vsync: vsync);

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

// Screen dimensions provider
class ScreenDimensions {
  final double width;
  final double height;

  const ScreenDimensions({required this.width, required this.height});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScreenDimensions &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(width, height);
}

final screenDimensionsProvider = Provider<ScreenDimensions>((ref) {
  throw UnimplementedError('screenDimensionsProvider must be overridden');
});

// Performance optimized providers
final isTabSelectedProvider = Provider.family<bool, int>((ref, index) {
  final homeState = ref.watch(homeStateProvider);
  return homeState.currentTabIndex == index;
});

final isNavSelectedProvider = Provider.family<bool, int>((ref, index) {
  final homeState = ref.watch(homeStateProvider);
  return homeState.selectedNavIndex == index;
});

// Tab item data provider
final tabItemDataProvider = Provider.family<Map<String, dynamic>, int>((
  ref,
  index,
) {
  return {
    'title': tabNames[index],
    'icon': tabIcons[index] ?? Icons.circle_outlined,
    'color': tabAccentColors[index] ?? const Color(0xFFFF5912),
    'isSelected': ref.watch(isTabSelectedProvider(index)),
  };
});

// Navigation item data provider
final navItemDataProvider = Provider.family<Map<String, dynamic>, int>((
  ref,
  index,
) {
  final homeState = ref.watch(homeStateProvider);
  return {
    'icon': bottomNavItems[index]['icon'],
    'label': bottomNavItems[index]['label'],
    'isSelected': homeState.selectedNavIndex == index,
    'accentColor': ref.watch(homeStateProvider.notifier).currentAccentColor,
  };
});
