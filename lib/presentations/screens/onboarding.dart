import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/presentations/provider/app_provider.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String imagePath;
  final List<Color> gradientColors;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.gradientColors,
  });
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingModel> _onboardingPages = [
    OnboardingModel(
      title: "Welcome to Yatra Buddy",
      description:
          "Explore flight services, hotels, restaurants, and bridge guides with ease",
      imagePath:
          "https://media.istockphoto.com/id/155380716/photo/commercial-jet-flying-over-clouds.jpg?s=612x612&w=0&k=20&c=idhnJ7ZdrLA1Dv5GO2R28A8WCx1SXCFVLu5_2cfdvXw=",
      gradientColors: AppColors.hrtcgradient,
    ),
    OnboardingModel(
      title: "Hotels",
      description: "Find and reserve top-rated hotels for your stay",
      imagePath:
          "https://media.istockphoto.com/id/514102692/photo/udaipur-city-palace-in-rajasthan-state-of-india.jpg?s=612x612&w=0&k=20&c=bYRDPOuf6nFgghl6VAnCn__22SFyu_atC_fiSCzVNtY=",
      gradientColors: AppColors.hotelsGradient,
    ),
    // OnboardingModel(
    //   title: "Restaurants",
    //   description: "Discover the best dining experiences near you",
    //   imagePath:
    //       "https://media.istockphoto.com/id/464597982/photo/indian-thali-indian-food.jpg?s=612x612&w=0&k=20&c=DtzloV4_NnVJNpG96CpM2_DSYb97imp0S959DFzcM9A=",
    //   gradientColors: AppColors.restaurantsGradient,
    // ),
    OnboardingModel(
      title: "Bus Services",
      description: "Book reliable and comfortable bus tickets for your journey",
      imagePath:
          "https://media.istockphoto.com/id/1154164634/photo/white-bus-traveling-on-the-asphalt-road-around-line-of-trees-in-rural-landscape-at-sunset.jpg?s=612x612&w=0&k=20&c=e7W4o2ajRuKWIFkrO7Imkg_azl79fOi3sJ7eacDEUNQ=",
      gradientColors: AppColors.travelGradient,
    ),
    // OnboardingModel(
    //   title: "Braj Darshan",
    //   description: "Get detailed guides for iconic bridges and travel routes",
    //   imagePath:
    //       "https://media.istockphoto.com/id/482024366/photo/krishna-giridhari.jpg?s=612x612&w=0&k=20&c=_kgG2hJ0ONEcfWg_NYr1b4c0L9xnA-kRFi6NqpYXNkc=",
    //   gradientColors: AppColors.servicesGradient,
    // ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _finishOnboarding() {
    if (!mounted) return; // Prevent navigation if widget is disposed
    try {
      // Mark onboarding as completed
      ref.read(appStateProvider.notifier).completeOnboarding();
      debugPrint('OnboardingScreen: Onboarding completed, navigating to /home');

      // Navigate to home screen
      context.pushReplacement('/home');
    } catch (e) {
      debugPrint('OnboardingScreen: Navigation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: _onboardingPages[_currentPage].gradientColors,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: _finishOnboarding,
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _onboardingPages.length,
                    itemBuilder: (context, index) {
                      return OnboardingPage(
                        model: _onboardingPages[index],
                        isActive: _currentPage == index,
                      );
                    },
                  ),
                ),

                // Page indicator and buttons
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page indicator
                      Row(
                        children: List.generate(
                          _onboardingPages.length,
                          (index) => buildDotIndicator(index),
                        ),
                      ),

                      // Next/Finish button
                      ElevatedButton(
                            onPressed: () {
                              if (_currentPage == _onboardingPages.length - 1) {
                                _finishOnboarding();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  _onboardingPages[_currentPage]
                                      .gradientColors[0],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              _currentPage == _onboardingPages.length - 1
                                  ? "Get Started"
                                  : "Next",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          .animate(
                            target:
                                _currentPage == _onboardingPages.length - 1
                                    ? 1
                                    : 0,
                          )
                          .scaleX(end: 1.2, duration: 300.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDotIndicator(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingModel model;
  final bool isActive;

  const OnboardingPage({
    super.key,
    required this.model,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Expanded(
                flex: 2,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        model.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              getIconForTitle(model.title),
                              size: 120,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
              .animate(target: isActive ? 1 : 0)
              .fadeIn(duration: 800.ms, curve: Curves.easeOut)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 800.ms,
                curve: Curves.easeOut,
              ),
          const SizedBox(height: 20),

          // Title
          Text(
                model.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
              .animate(target: isActive ? 1 : 0)
              .fadeIn(delay: 300.ms, duration: 800.ms)
              .moveY(begin: 20, end: 0, delay: 300.ms, duration: 800.ms),

          const SizedBox(height: 16),

          // Description
          Text(
                model.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              )
              .animate(target: isActive ? 1 : 0)
              .fadeIn(delay: 500.ms, duration: 800.ms)
              .moveY(begin: 20, end: 0, delay: 500.ms, duration: 800.ms),

          Expanded(flex: 1, child: Container()),
        ],
      ),
    );
  }

  IconData getIconForTitle(String title) {
    if (title.contains("Welcome")) return Icons.home_outlined;
    if (title.contains("Hotels")) return Icons.hotel_outlined;
    if (title.contains("Restaurants")) return Icons.restaurant_outlined;
    if (title.contains("Bus")) return Icons.directions_bus_outlined;
    if (title.contains("Brij")) return Icons.map_outlined;
    return Icons.star_outline;
  }
}
