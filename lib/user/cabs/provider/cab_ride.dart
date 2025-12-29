import 'package:flutter_riverpod/flutter_riverpod.dart';

class RideOption {
  final String id;
  final String name;
  final String description;
  final double pricePerKm;
  final String imageUrl;
  final int capacity;
  final String estimatedTime;
  final List<String> features;
  final double rating;
  final bool isAvailable;
  final String vehicleType;
  final double baseFare;

  RideOption({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerKm,
    required this.imageUrl,
    required this.capacity,
    required this.estimatedTime,
    required this.features,
    required this.rating,
    required this.isAvailable,
    required this.vehicleType,
    required this.baseFare,
  });
}

class Driver {
  final String id;
  final String name;
  final String photoUrl;
  final double rating;
  final String phoneNumber;
  final String vehicleNumber;
  final String vehicleModel;
  final int totalTrips;

  Driver({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.rating,
    required this.phoneNumber,
    required this.vehicleNumber,
    required this.vehicleModel,
    required this.totalTrips,
  });
}

class CabRideState {
  final List<RideOption> rideOptions;
  final List<Driver> availableDrivers;
  final bool isLoading;
  final String? selectedRideId;
  final Driver? selectedDriver;
  final bool showDriverDetails;

  CabRideState({
    this.rideOptions = const [],
    this.availableDrivers = const [],
    this.isLoading = false,
    this.selectedRideId,
    this.selectedDriver,
    this.showDriverDetails = false,
  });

  CabRideState copyWith({
    List<RideOption>? rideOptions,
    List<Driver>? availableDrivers,
    bool? isLoading,
    String? selectedRideId,
    Driver? selectedDriver,
    bool? showDriverDetails,
  }) {
    return CabRideState(
      rideOptions: rideOptions ?? this.rideOptions,
      availableDrivers: availableDrivers ?? this.availableDrivers,
      isLoading: isLoading ?? this.isLoading,
      selectedRideId: selectedRideId ?? this.selectedRideId,
      selectedDriver: selectedDriver ?? this.selectedDriver,
      showDriverDetails: showDriverDetails ?? this.showDriverDetails,
    );
  }
}

class CabRideNotifier extends StateNotifier<CabRideState> {
  CabRideNotifier() : super(CabRideState()) {
    _fetchRideOptions();
  }

  Future<void> _fetchRideOptions() async {
    state = state.copyWith(isLoading: true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final mockRides = [
      RideOption(
        id: '1',
        name: 'Economy',
        description: 'Affordable rides for everyday travel',
        pricePerKm: 10.0,
        baseFare: 30.0,
        imageUrl:
            'https://images.unsplash.com/photo-1549924231-f129b911e442?w=400&h=300&fit=crop',
        capacity: 4,
        estimatedTime: '3-5 min',
        features: ['AC', 'Music System', 'Safe Ride'],
        rating: 4.2,
        isAvailable: true,
        vehicleType: 'Hatchback',
      ),
      RideOption(
        id: '2',
        name: 'Premium',
        description: 'Comfortable rides with premium vehicles',
        pricePerKm: 15.0,
        baseFare: 50.0,
        imageUrl:
            'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=400&h=300&fit=crop',
        capacity: 4,
        estimatedTime: '2-4 min',
        features: ['AC', 'Leather Seats', 'Premium Audio', 'WiFi'],
        rating: 4.5,
        isAvailable: true,
        vehicleType: 'Sedan',
      ),
      RideOption(
        id: '3',
        name: 'SUV',
        description: 'Spacious rides for groups or extra luggage',
        pricePerKm: 20.0,
        baseFare: 70.0,
        imageUrl:
            'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=400&h=300&fit=crop',
        capacity: 7,
        estimatedTime: '4-6 min',
        features: [
          'AC',
          'Extra Space',
          'Luggage Storage',
          'Child Seats Available',
        ],
        rating: 4.3,
        isAvailable: true,
        vehicleType: 'SUV',
      ),
      RideOption(
        id: '4',
        name: 'Luxury',
        description: 'Premium luxury vehicles for special occasions',
        pricePerKm: 35.0,
        baseFare: 150.0,
        imageUrl:
            'https://images.unsplash.com/photo-1563720223185-11003d516935?w=400&h=300&fit=crop',
        capacity: 4,
        estimatedTime: '5-8 min',
        features: [
          'Premium AC',
          'Massage Seats',
          'Premium Audio',
          'Refreshments',
          'WiFi',
        ],
        rating: 4.8,
        isAvailable: true,
        vehicleType: 'Luxury Sedan',
      ),
      RideOption(
        id: '5',
        name: 'Electric',
        description: 'Eco-friendly electric vehicles',
        pricePerKm: 12.0,
        baseFare: 40.0,
        imageUrl:
            'https://images.unsplash.com/photo-1593941707874-ef25b8b4a92b?w=400&h=300&fit=crop',
        capacity: 4,
        estimatedTime: '3-5 min',
        features: ['Zero Emission', 'Silent Ride', 'AC', 'USB Charging'],
        rating: 4.4,
        isAvailable: true,
        vehicleType: 'Electric Car',
      ),
      RideOption(
        id: '6',
        name: 'Mini',
        description: 'Quick and affordable rides for short distances',
        pricePerKm: 8.0,
        baseFare: 25.0,
        imageUrl:
            'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=400&h=300&fit=crop',
        capacity: 3,
        estimatedTime: '2-4 min',
        features: ['AC', 'Compact', 'Fuel Efficient'],
        rating: 4.0,
        isAvailable: false, // Example of unavailable ride
        vehicleType: 'Compact Car',
      ),
    ];

    final mockDrivers = [
      Driver(
        id: '1',
        name: 'Raj Kumar',
        photoUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        rating: 4.8,
        phoneNumber: '+91 98765 43210',
        vehicleNumber: 'MP 09 AB 1234',
        vehicleModel: 'Honda City',
        totalTrips: 1250,
      ),
      Driver(
        id: '2',
        name: 'Priya Sharma',
        photoUrl:
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        rating: 4.9,
        phoneNumber: '+91 87654 32109',
        vehicleNumber: 'MP 09 CD 5678',
        vehicleModel: 'Maruti Swift',
        totalTrips: 980,
      ),
      Driver(
        id: '3',
        name: 'Amit Patel',
        photoUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        rating: 4.7,
        phoneNumber: '+91 76543 21098',
        vehicleNumber: 'MP 09 EF 9012',
        vehicleModel: 'Toyota Innova',
        totalTrips: 2100,
      ),
    ];

    state = state.copyWith(
      rideOptions: mockRides,
      availableDrivers: mockDrivers,
      isLoading: false,
    );
  }

  void selectRide(String rideId) {
    state = state.copyWith(selectedRideId: rideId);
  }

  void selectDriver(Driver driver) {
    state = state.copyWith(selectedDriver: driver, showDriverDetails: true);
  }

  void hideDriverDetails() {
    state = state.copyWith(showDriverDetails: false);
  }

  Future<void> refreshRides() async {
    await _fetchRideOptions();
  }
}

final cabRideProvider = StateNotifierProvider<CabRideNotifier, CabRideState>(
  (ref) => CabRideNotifier(),
);
