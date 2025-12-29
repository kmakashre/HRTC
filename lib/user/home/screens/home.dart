import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/presentations/provider/app_provider.dart';
import 'package:hrtc/user/brijguid/screens/brajdarshan.dart';
import 'package:hrtc/user/cabs/screens/cabs.dart';
import 'package:hrtc/user/home/provider/home_provider.dart';
import 'package:hrtc/user/hotels/screens/hotels.dart';
import 'package:hrtc/user/hrtc/screens/hrtc.dart';
import 'package:hrtc/user/travel/Travel/screens/travel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Widget> _screens;
  late List<bool> _loadedTabs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabNames.length, vsync: this);
    _loadedTabs = List.generate(tabNames.length, (index) => index == 0);

    // Initialize screens list
    _screens = [
      const HRTCScreen(),
      const HotelsScreen(),
      const TravelScreen(),
      const BrajDarshanScreen(),
    ];

    // Listen to tab changes with debouncing
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      final index = _tabController.index;

      // Load tab content lazily
      if (index < _loadedTabs.length && !_loadedTabs[index]) {
        setState(() {
          _loadedTabs[index] = true;
        });
      }

      // Update home provider
      Future.microtask(() {
        if (mounted) {
          ref.read(homeStateProvider.notifier).changeTab(index);

          // Update app provider
          try {
            ref
                .read(appStateProvider.notifier)
                .setCurrentSection(AppSection.values[index]);
          } catch (e) {
            debugPrint('HomeScreen: Error setting section: $e');
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return ProviderScope(
      overrides: [
        screenDimensionsProvider.overrideWithValue(
          ScreenDimensions(width: screenSize.width, height: screenSize.height),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Custom Tab Bar
                  const _AnimatedTabBar(),
                  // Tab Content with Lazy Loading
                  Expanded(
                    child: _LazyTabContent(
                      controller: _tabController,
                      screens: _screens,
                      loadedTabs: _loadedTabs,
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Navigation Bar
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _AnimatedBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}

// Optimized Tab Bar Widget
class _AnimatedTabBar extends ConsumerWidget {
  const _AnimatedTabBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenDimensions = ref.watch(screenDimensionsProvider);
    final homeState = ref.watch(homeStateProvider);

    if (!homeState.isTabBarVisible) return const SizedBox.shrink();

    return RepaintBoundary(
      child: Container(
            height: screenDimensions.height * 0.07,
            margin: EdgeInsets.symmetric(
              horizontal: screenDimensions.width * 0.04,
              vertical: screenDimensions.height * 0.015,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: tabNames.length,
              cacheExtent: 500,
              itemBuilder:
                  (context, index) =>
                      RepaintBoundary(child: _TabItem(index: index)),
            ),
          )
          .animate()
          .fadeIn(duration: 500.ms)
          .slideY(
            begin: -0.2,
            end: 0,
            duration: 500.ms,
            curve: Curves.easeOutQuad,
          ),
    );
  }
}

// Optimized Tab Item Widget
class _TabItem extends ConsumerWidget {
  final int index;

  const _TabItem({required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenDimensions = ref.watch(screenDimensionsProvider);
    final tabData = ref.watch(tabItemDataProvider(index));

    return RepaintBoundary(
      child: _DebouncedGestureDetector(
        onTap: () {
          final homeScreenState =
              context.findAncestorStateOfType<_HomeScreenState>();
          if (homeScreenState != null) {
            homeScreenState._tabController.animateTo(index);
          }
        },
        debounceDuration: Duration.zero,
        child: Container(
          width: screenDimensions.width * 0.3,
          height: screenDimensions.height * 0.07,
          margin: EdgeInsets.only(right: screenDimensions.width * 0.02),
          child: Card(
            color: tabData['isSelected'] ? tabData['color'] : Colors.white,
            elevation: tabData['isSelected'] ? 8 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  tabData['icon'],
                  size: screenDimensions.width * 0.04,
                  color:
                      tabData['isSelected']
                          ? Colors.white
                          : AppColors.textSecondary,
                ),
                SizedBox(width: screenDimensions.width * 0.015),
                Flexible(
                  child: Text(
                    tabData['title'],
                    style: TextStyle(
                      color:
                          tabData['isSelected']
                              ? Colors.white
                              : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: screenDimensions.width * 0.03,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ).animate().scale(
            duration: 300.ms,
            begin:
                tabData['isSelected']
                    ? const Offset(1.0, 1.0)
                    : const Offset(0.9, 0.9),
            end:
                tabData['isSelected']
                    ? const Offset(1.0, 1.0)
                    : const Offset(0.9, 0.9),
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }
}

// Lazy Loading Tab Content
class _LazyTabContent extends StatefulWidget {
  final TabController controller;
  final List<Widget> screens;
  final List<bool> loadedTabs;

  const _LazyTabContent({
    required this.controller,
    required this.screens,
    required this.loadedTabs,
  });

  @override
  State<_LazyTabContent> createState() => _LazyTabContentState();
}

class _LazyTabContentState extends State<_LazyTabContent> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.controller,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        widget.screens.length,
        (index) =>
            widget.loadedTabs[index]
                ? _KeepAliveWrapper(child: widget.screens[index])
                : const _LoadingPlaceholder(),
      ),
    );
  }
}

// Keep Alive Wrapper for Tab Content
class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RepaintBoundary(child: widget.child);
  }
}

// Loading Placeholder
class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.hrtcAccent),
    );
  }
}

// Optimized Bottom Navigation Bar Widget
class _AnimatedBottomNavBar extends ConsumerWidget {
  const _AnimatedBottomNavBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenDimensions = ref.watch(screenDimensionsProvider);

    return RepaintBoundary(
      child: Container(
            height: screenDimensions.height * 0.09,
            padding: EdgeInsets.symmetric(
              horizontal: screenDimensions.width * 0.02,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(screenDimensions.width * 0.06),
                topRight: Radius.circular(screenDimensions.width * 0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: screenDimensions.width * 0.025,
                  offset: Offset(0, -screenDimensions.height * 0.005),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                bottomNavItems.length,
                (index) => RepaintBoundary(child: _BottomNavItem(index: index)),
              ),
            ),
          )
          .animate()
          .fadeIn(duration: 500.ms)
          .slideY(
            begin: 0.2,
            end: 0,
            duration: 500.ms,
            curve: Curves.easeOutQuad,
          ),
    );
  }
}

// Optimized Bottom Navigation Item Widget
class _BottomNavItem extends ConsumerWidget {
  final int index;

  const _BottomNavItem({required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenDimensions = ref.watch(screenDimensionsProvider);
    final navData = ref.watch(navItemDataProvider(index));
    final homeNotifier = ref.read(homeStateProvider.notifier);

    return RepaintBoundary(
      child: _DebouncedGestureDetector(
        onTap: () {
          homeNotifier.changeBottomNav(index);

          // Handle navigation based on bottom nav item
          switch (index) {
            case 0: // Home - stay on current tab
              break;
            case 1: // Notifications
              _handleNotificationNavigation(context);
              break;
            case 2: // Favorites
              _handleFavoritesNavigation(context);
              break;
            case 3: // Profile
              _handleProfileNavigation(context);
              break;
          }
        },
        debounceDuration: Duration.zero,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
            vertical: screenDimensions.height * 0.01,
          ),
          width: screenDimensions.width * 0.2,
          decoration: BoxDecoration(
            color:
                navData['isSelected']
                    ? navData['accentColor']
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(screenDimensions.width * 0.04),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                navData['icon'],
                size: screenDimensions.width * 0.06,
                color:
                    navData['isSelected']
                        ? Colors.white
                        : AppColors.textSecondary,
              ),
              Text(
                navData['label'],
                style: TextStyle(
                  color:
                      navData['isSelected']
                          ? Colors.white
                          : AppColors.textSecondary,
                  fontSize: screenDimensions.width * 0.025,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ).animate().scale(
          duration: 200.ms,
          begin:
              navData['isSelected']
                  ? const Offset(1.1, 1.1)
                  : const Offset(1.0, 1.0),
          end:
              navData['isSelected']
                  ? const Offset(1.1, 1.1)
                  : const Offset(1.0, 1.0),
        ),
      ),
    );
  }

  void _handleNotificationNavigation(BuildContext context) {
    // Navigate to notifications screen
  }

  void _handleFavoritesNavigation(BuildContext context) {
    // Navigate to favorites screen
  }

  void _handleProfileNavigation(BuildContext context) {
    // Navigate to profile screen
  }
}

// Debounced Gesture Detector
class _DebouncedGestureDetector extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Duration debounceDuration;

  const _DebouncedGestureDetector({
    this.onTap,
    required this.child,
    required this.debounceDuration,
  });

  @override
  State<_DebouncedGestureDetector> createState() =>
      _DebouncedGestureDetectorState();
}

class _DebouncedGestureDetectorState extends State<_DebouncedGestureDetector> {
  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final now = DateTime.now();
        if (_lastTapTime == null ||
            now.difference(_lastTapTime!) > widget.debounceDuration) {
          _lastTapTime = now;
          widget.onTap?.call();
        }
      },
      child: widget.child,
    );
  }
}
