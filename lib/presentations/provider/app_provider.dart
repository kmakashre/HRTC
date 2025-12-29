import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// App state enum for tracking current section
enum AppSection { nearProp, groceries, food, travel, cabs, services }

// State class for the app
class AppState {
  final AppSection currentSection;
  final bool isDarkMode;
  final bool hasCompletedOnboarding;

  const AppState({
    this.currentSection = AppSection.nearProp,
    this.isDarkMode = false,
    this.hasCompletedOnboarding = false,
  });

  AppState copyWith({
    AppSection? currentSection,
    bool? isDarkMode,
    bool? hasCompletedOnboarding,
  }) {
    return AppState(
      currentSection: currentSection ?? this.currentSection,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}

// App state notifier
class AppStateNotifier extends StateNotifier<AppState> {
  static const _onboardingKey = 'has_completed_onboarding';
  late SharedPreferences _prefs;

  AppStateNotifier() : super(const AppState()) {
    _init();
  }

  Future<void> _init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final hasCompletedOnboarding = _prefs.getBool(_onboardingKey) ?? false;
      state = state.copyWith(hasCompletedOnboarding: hasCompletedOnboarding);
      debugPrint(
        'AppStateNotifier: Loaded onboarding state: $hasCompletedOnboarding',
      );
    } catch (e) {
      debugPrint('AppStateNotifier: Error initializing preferences: $e');
    }
  }

  void setCurrentSection(AppSection section) {
    state = state.copyWith(currentSection: section);
    debugPrint('AppStateNotifier: Section changed to $section');
  }

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
    debugPrint('AppStateNotifier: Dark mode set to ${state.isDarkMode}');
  }

  Future<void> completeOnboarding() async {
    try {
      state = state.copyWith(hasCompletedOnboarding: true);
      await _prefs.setBool(_onboardingKey, true);
      debugPrint('AppStateNotifier: Onboarding completed and saved');
    } catch (e) {
      debugPrint('AppStateNotifier: Error saving onboarding state: $e');
    }
  }
}

// Provider for app state
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((
  ref,
) {
  return AppStateNotifier();
});
