import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/presentations/provider/app_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppSizes.longAnimationDuration,
    );

    // Navigate to next screen after animation completes
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (!mounted) return; // Prevent navigation if widget is disposed
      try {
        // Check if onboarding is completed
        final hasCompletedOnboarding =
            ref.read(appStateProvider).hasCompletedOnboarding;
        debugPrint(
          'SplashScreen: hasCompletedOnboarding=$hasCompletedOnboarding',
        );

        if (hasCompletedOnboarding) {
          context.pushReplacement('/home');
        } else {
          context.pushReplacement('/onboarding');
        }
      } catch (e) {
        debugPrint('SplashScreen: Navigation error: $e');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo animation
              Image(
                    image: const AssetImage('assets/images/logo.png'),
                    width: screenWidth * 0.6,
                    height: screenWidth * 0.6,
                  )
                  .animate()
                  .scale(
                    duration: 1200.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0.2, 0.2),
                    end: const Offset(1.0, 1.0),
                  )
                  .then()
                  .shimmer(
                    duration: 2400.ms,
                    color: Colors.white.withOpacity(0.8),
                  ),

              SizedBox(height: screenHeight * 0.05),

              // App name
              Text(
                    AppSizes.appName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 800.ms)
                  .moveY(
                    begin: screenHeight * 0.02,
                    end: 0,
                    delay: 400.ms,
                    duration: 800.ms,
                    curve: Curves.easeOutQuad,
                  ),

              SizedBox(height: screenHeight * 0.02),

              // Slogan
              Text(
                    AppSizes.appSlogan,
                    style: TextStyle(
                      color: const Color(0xFF2A62AA),
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 800.ms)
                  .moveY(
                    begin: screenHeight * 0.02,
                    end: 0,
                    delay: 700.ms,
                    duration: 800.ms,
                    curve: Curves.easeOutQuad,
                  ),

              SizedBox(height: screenHeight * 0.075),

              // Loading indicator
              CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF2A62AA),
                ),
                strokeWidth: screenWidth * 0.008,
              ).animate().fadeIn(delay: 1000.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
