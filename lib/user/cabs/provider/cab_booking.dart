import 'package:flutter_riverpod/flutter_riverpod.dart';

class CabBookingState {
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime? pickupDateTime;
  final String? selectedRideId;
  final double? estimatedDistance;
  final double? estimatedFare;
  final List<String> recentLocations;
  final bool isScheduled;
  final String paymentMethod;
  final Map<String, String>? pickupCoordinates;
  final Map<String, String>? dropoffCoordinates;

  CabBookingState({
    this.pickupLocation = '',
    this.dropoffLocation = '',
    this.pickupDateTime,
    this.selectedRideId,
    this.estimatedDistance,
    this.estimatedFare,
    this.recentLocations = const [],
    this.isScheduled = false,
    this.paymentMethod = 'Cash',
    this.pickupCoordinates,
    this.dropoffCoordinates,
  });

  CabBookingState copyWith({
    String? pickupLocation,
    String? dropoffLocation,
    DateTime? pickupDateTime,
    String? selectedRideId,
    double? estimatedDistance,
    double? estimatedFare,
    List<String>? recentLocations,
    bool? isScheduled,
    String? paymentMethod,
    Map<String, String>? pickupCoordinates,
    Map<String, String>? dropoffCoordinates,
  }) {
    return CabBookingState(
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      pickupDateTime: pickupDateTime ?? this.pickupDateTime,
      selectedRideId: selectedRideId ?? this.selectedRideId,
      estimatedDistance: estimatedDistance ?? this.estimatedDistance,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      recentLocations: recentLocations ?? this.recentLocations,
      isScheduled: isScheduled ?? this.isScheduled,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      pickupCoordinates: pickupCoordinates ?? this.pickupCoordinates,
      dropoffCoordinates: dropoffCoordinates ?? this.dropoffCoordinates,
    );
  }
}

class CabBookingNotifier extends StateNotifier<CabBookingState> {
  CabBookingNotifier() : super(CabBookingState()) {
    _loadRecentLocations();
  }

  void updatePickupLocation(String location) {
    state = state.copyWith(pickupLocation: location);
    _calculateEstimatedFare();
  }

  void updateDropoffLocation(String location) {
    state = state.copyWith(dropoffLocation: location);
    _addToRecentLocations(location);
    _calculateEstimatedFare();
  }

  void updatePickupDateTime(DateTime dateTime) {
    final isScheduled = dateTime.isAfter(
      DateTime.now().add(const Duration(minutes: 30)),
    );
    state = state.copyWith(pickupDateTime: dateTime, isScheduled: isScheduled);
  }

  void selectRide(String rideId) {
    state = state.copyWith(selectedRideId: rideId);
  }

  void updatePaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void _calculateEstimatedFare() {
    if (state.pickupLocation.isNotEmpty && state.dropoffLocation.isNotEmpty) {
      // Simulate distance calculation
      final distance = _calculateDistance();
      const baseFare = 50.0;
      const perKmRate = 12.0;
      final estimatedFare = baseFare + (distance * perKmRate);

      state = state.copyWith(
        estimatedDistance: distance,
        estimatedFare: estimatedFare,
      );
    }
  }

  double _calculateDistance() {
    // Simulate distance calculation based on locations
    return 5.5 +
        (state.pickupLocation.length % 10) +
        (state.dropoffLocation.length % 15);
  }

  void _addToRecentLocations(String location) {
    if (location.isNotEmpty && !state.recentLocations.contains(location)) {
      final updatedLocations =
          [location, ...state.recentLocations.take(4)].toList();
      state = state.copyWith(recentLocations: updatedLocations);
    }
  }

  void _loadRecentLocations() {
    // Simulate loading recent locations from storage
    final mockRecentLocations = [
      'Central Mall, Indore',
      'Railway Station, Indore',
      'Airport, Indore',
      'Palasia Square, Indore',
    ];
    state = state.copyWith(recentLocations: mockRecentLocations);
  }

  void swapLocations() {
    final pickup = state.pickupLocation;
    final dropoff = state.dropoffLocation;
    state = state.copyWith(pickupLocation: dropoff, dropoffLocation: pickup);
  }

  void reset() {
    state = CabBookingState(recentLocations: state.recentLocations);
  }
}

final cabBookingProvider =
    StateNotifierProvider<CabBookingNotifier, CabBookingState>(
      (ref) => CabBookingNotifier(),
    );
