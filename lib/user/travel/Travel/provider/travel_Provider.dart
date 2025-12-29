import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TripType { oneWay, roundTrip, multiCity }

class TravelState {
  final int tabIndex;
  final String fromLocation;
  final String toLocation;
  final String departureDate;
  final String returnDate;
  final int adults;
  final int children;
  final int infants;
  final String travelClass;
  final TripType tripType;
  final List<String> recentSearches;
  final bool isLoading;
  final String? error;

  TravelState({
    this.tabIndex = 0,
    this.fromLocation = '',
    this.toLocation = '',
    this.departureDate = '',
    this.returnDate = '',
    this.adults = 1,
    this.children = 0,
    this.infants = 0,
    this.travelClass = 'Economy',
    this.tripType = TripType.oneWay,
    this.recentSearches = const [],
    this.isLoading = false,
    this.error,
  });

  TravelState copyWith({
    int? tabIndex,
    String? fromLocation,
    String? toLocation,
    String? departureDate,
    String? returnDate,
    int? adults,
    int? children,
    int? infants,
    String? travelClass,
    TripType? tripType,
    List<String>? recentSearches,
    bool? isLoading,
    String? error,
  }) {
    return TravelState(
      tabIndex: tabIndex ?? this.tabIndex,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      infants: infants ?? this.infants,
      travelClass: travelClass ?? this.travelClass,
      tripType: tripType ?? this.tripType,
      recentSearches: recentSearches ?? this.recentSearches,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  // Computed properties used in SearchCard
  String get formattedDateRange {
    if (departureDate.isEmpty) return 'Select dates';
    if (tripType == TripType.roundTrip && returnDate.isNotEmpty) {
      return '$departureDate - $returnDate';
    }
    return departureDate;
  }

  String get passengerSummary {
    final totalPassengers = adults + children + infants;
    if (totalPassengers == 1) {
      return '1 Passenger';
    }

    List<String> parts = [];
    if (adults > 0) parts.add('$adults Adult${adults > 1 ? 's' : ''}');
    if (children > 0) parts.add('$children Child${children > 1 ? 'ren' : ''}');
    if (infants > 0) parts.add('$infants Infant${infants > 1 ? 's' : ''}');

    return parts.join(', ');
  }

  String get passengerText {
    final totalPassengers = adults + children + infants;
    return totalPassengers == 1 ? '1 Passenger' : '$totalPassengers Passengers';
  }

  bool get canSearch {
    // For flights, need from, to, departure date, and at least 1 adult
    if (tabIndex == 0) {
      bool hasBasicInfo =
          fromLocation.isNotEmpty &&
          toLocation.isNotEmpty &&
          departureDate.isNotEmpty &&
          adults > 0;

      // For round trip, also need return date
      if (tripType == TripType.roundTrip) {
        return hasBasicInfo && returnDate.isNotEmpty;
      }

      return hasBasicInfo;
    }

    // For buses, need from, to, and departure date
    return fromLocation.isNotEmpty &&
        toLocation.isNotEmpty &&
        departureDate.isNotEmpty;
  }

  int get totalPassengers => adults + children + infants;
}

class TravelNotifier extends StateNotifier<TravelState> {
  TravelNotifier() : super(TravelState()) {
    _initializeDefaults();
  }

  void _initializeDefaults() {
    final now = DateTime.now();
    final departureDate = now.add(const Duration(days: 1));
    final returnDate = departureDate.add(const Duration(days: 7));

    state = state.copyWith(
      departureDate: formatDate(departureDate),
      returnDate: formatDate(returnDate),
    );
  }

  String formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  // Tab management
  void setTabIndex(int index) {
    state = state.copyWith(
      tabIndex: index,
      error: null,
      // Reset some fields when switching tabs
      fromLocation: '',
      toLocation: '',
    );
  }

  // Location management
  void setFromLocation(String location) {
    state = state.copyWith(fromLocation: location, error: null);
  }

  void setToLocation(String location) {
    state = state.copyWith(toLocation: location, error: null);
  }

  void swapLocations() {
    if (state.fromLocation.isNotEmpty || state.toLocation.isNotEmpty) {
      final temp = state.fromLocation;
      state = state.copyWith(fromLocation: state.toLocation, toLocation: temp);
    }
  }

  // Date management
  void setDepartureDate(String date) {
    state = state.copyWith(departureDate: date, error: null);
  }

  void setReturnDate(String date) {
    state = state.copyWith(returnDate: date);
  }

  // Trip type management
  void setTripType(TripType tripType) {
    state = state.copyWith(tripType: tripType);

    // Clear return date if switching from round trip
    if (tripType != TripType.roundTrip) {
      state = state.copyWith(returnDate: '');
    }
  }

  // Passenger management
  void updatePassengerCount(String type, int count) {
    switch (type) {
      case 'adults':
        if (count >= 1 && count <= 9) {
          state = state.copyWith(adults: count);
        }
        break;
      case 'children':
        if (count >= 0 && count <= 9) {
          state = state.copyWith(children: count);
        }
        break;
      case 'infants':
        if (count >= 0 && count <= 9) {
          // Infants cannot exceed adults
          final maxInfants = state.adults;
          state = state.copyWith(
            infants: count > maxInfants ? maxInfants : count,
          );
        }
        break;
    }
  }

  void setPassengers(int count) {
    if (count > 0 && count <= 9) {
      state = state.copyWith(adults: count);
    }
  }

  // Travel class management
  void setTravelClass(String travelClass) {
    state = state.copyWith(travelClass: travelClass);
  }

  // Loading and error management
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  // Recent searches management
  void addRecentSearch() {
    if (state.toLocation.isNotEmpty && state.fromLocation.isNotEmpty) {
      final searchType = state.tabIndex == 0 ? 'Flight' : 'Bus';
      final searchQuery =
          '$searchType: ${state.fromLocation} → ${state.toLocation}';
      final updatedSearches =
          {searchQuery, ...state.recentSearches}.take(10).toList();
      state = state.copyWith(recentSearches: updatedSearches);
    }
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: []);
  }

  void removeRecentSearch(String search) {
    final updatedSearches =
        state.recentSearches.where((item) => item != search).toList();
    state = state.copyWith(recentSearches: updatedSearches);
  }

  // Search functionality
  Future<void> performSearch() async {
    if (!state.canSearch) {
      String errorMessage = 'Please fill in all required fields';

      if (state.fromLocation.isEmpty) {
        errorMessage = 'Please select departure location';
      } else if (state.toLocation.isEmpty) {
        errorMessage = 'Please select destination';
      } else if (state.departureDate.isEmpty) {
        errorMessage = 'Please select departure date';
      } else if (state.tripType == TripType.roundTrip &&
          state.returnDate.isEmpty) {
        errorMessage = 'Please select return date';
      } else if (state.adults < 1) {
        errorMessage = 'At least 1 adult passenger is required';
      }

      setError(errorMessage);
      return;
    }

    setLoading(true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));
      addRecentSearch();
      setLoading(false);

      // You can add navigation logic here or handle it in the UI
    } catch (e) {
      setError('Search failed. Please try again.');
    }
  }

  // Validation helpers
  // bool get isValidSearch {
  //   return canSearch;
  // }

  String? get validationError {
    if (state.fromLocation.isEmpty) return 'Select departure location';
    if (state.toLocation.isEmpty) return 'Select destination';
    if (state.departureDate.isEmpty) return 'Select departure date';
    if (state.tripType == TripType.roundTrip && state.returnDate.isEmpty) {
      return 'Select return date';
    }
    if (state.adults < 1) return 'At least 1 adult required';
    return null;
  }

  // Utility methods
  void toggleTripType() {
    final newTripType =
        state.tripType == TripType.oneWay
            ? TripType.roundTrip
            : TripType.oneWay;
    setTripType(newTripType);
  }

  void resetSearch() {
    state = state.copyWith(
      fromLocation: '',
      toLocation: '',
      departureDate: '',
      returnDate: '',
      adults: 1,
      children: 0,
      infants: 0,
      travelClass: 'Economy',
      tripType: TripType.oneWay,
      error: null,
      isLoading: false,
    );
    _initializeDefaults();
  }

  void reset() {
    state = TravelState();
    _initializeDefaults();
  }

  // Quick preset methods for common scenarios
  void setDomesticDefaults() {
    state = state.copyWith(
      travelClass: 'Economy',
      adults: 1,
      children: 0,
      infants: 0,
      tripType: TripType.oneWay,
    );
  }

  void setInternationalDefaults() {
    state = state.copyWith(
      travelClass: 'Economy',
      adults: 2,
      children: 0,
      infants: 0,
      tripType: TripType.roundTrip,
    );
  }

  // Business travel preset
  void setBusinessTravelDefaults() {
    state = state.copyWith(
      travelClass: 'Business',
      adults: 1,
      children: 0,
      infants: 0,
      tripType: TripType.roundTrip,
    );
  }

  // Family travel preset
  void setFamilyTravelDefaults() {
    state = state.copyWith(
      travelClass: 'Economy',
      adults: 2,
      children: 2,
      infants: 0,
      tripType: TripType.roundTrip,
    );
  }
}

final travelProvider = StateNotifierProvider<TravelNotifier, TravelState>(
  (ref) => TravelNotifier(),
);

// Additional providers for specific use cases
final canSearchProvider = Provider<bool>((ref) {
  return ref.watch(travelProvider).canSearch;
});

final passengerSummaryProvider = Provider<String>((ref) {
  return ref.watch(travelProvider).passengerSummary;
});

final validationErrorProvider = Provider<String?>((ref) {
  return ref.read(travelProvider.notifier).validationError;
});
