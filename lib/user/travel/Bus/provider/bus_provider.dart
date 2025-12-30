import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ===============================
/// MODELS
/// ===============================

class BusAmenity {
  final String name;
  final String icon;

  BusAmenity({required this.name, required this.icon});
}

class Review {
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class SeatLayout {
  final int totalSeats;
  final int availableSeats;
  final String busType;

  SeatLayout({
    required this.totalSeats,
    required this.availableSeats,
    required this.busType,
  });
}

class Bus {
  final String id;
  final String operator;
  final String operatorLogo;
  final String route;
  final String fromCity;
  final String toCity;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final double price;
  final double originalPrice;
  final double rating;
  final int totalReviews;
  final List<BusAmenity> amenities;
  final SeatLayout seatLayout;
  final List<Review> reviews;
  final String busNumber;
  final String busImage;
  final bool isAC;
  final bool isWiFi;
  final bool isGPS;
  final bool isCCTV;
  final String cancellationPolicy;
  final List<String> pickupPoints;
  final List<String> dropoffPoints;
  final String busOwner;
  final double discountPercent;

  Bus({
    required this.id,
    required this.operator,
    required this.operatorLogo,
    required this.route,
    required this.fromCity,
    required this.toCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.totalReviews,
    required this.amenities,
    required this.seatLayout,
    required this.reviews,
    required this.busNumber,
    required this.busImage,
    required this.isAC,
    required this.isWiFi,
    required this.isGPS,
    required this.isCCTV,
    required this.cancellationPolicy,
    required this.pickupPoints,
    required this.dropoffPoints,
    required this.busOwner,
    required this.discountPercent,
  });

  double get discountAmount => originalPrice - price;
}

/// ===============================
/// BUS FORM STATE (✅ NEW)
/// ===============================

class BusFormState {
  final String fromCity;
  final String toCity;
  final String journeyDate;

  const BusFormState({
    this.fromCity = '',
    this.toCity = '',
    this.journeyDate = '',
  });

  bool get canSearch =>
      fromCity.isNotEmpty &&
          toCity.isNotEmpty &&
          journeyDate.isNotEmpty;

  BusFormState copyWith({
    String? fromCity,
    String? toCity,
    String? journeyDate,
  }) {
    return BusFormState(
      fromCity: fromCity ?? this.fromCity,
      toCity: toCity ?? this.toCity,
      journeyDate: journeyDate ?? this.journeyDate,
    );
  }
}

class BusFormNotifier extends StateNotifier<BusFormState> {
  BusFormNotifier() : super(const BusFormState());

  void setFromCity(String value) {
    state = state.copyWith(fromCity: value);
  }

  void setToCity(String value) {
    state = state.copyWith(toCity: value);
  }

  void setJourneyDate(String value) {
    state = state.copyWith(journeyDate: value);
  }

  void swapCities() {
    state = state.copyWith(
      fromCity: state.toCity,
      toCity: state.fromCity,
    );
  }

  void clear() {
    state = const BusFormState();
  }
}

/// 🔹 BUS FORM PROVIDER (USE THIS IN FORM SCREEN)
final busFormProvider =
StateNotifierProvider<BusFormNotifier, BusFormState>(
      (ref) => BusFormNotifier(),
);

/// ===============================
/// FILTER MODEL
/// ===============================

class BusFilter {
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool? isAC;
  final bool? isWiFi;
  final String? busType;
  final String? sortBy; // price | rating | departure

  BusFilter({
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.isAC,
    this.isWiFi,
    this.busType,
    this.sortBy,
  });

  BusFilter copyWith({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? isAC,
    bool? isWiFi,
    String? busType,
    String? sortBy,
  }) {
    return BusFilter(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      isAC: isAC ?? this.isAC,
      isWiFi: isWiFi ?? this.isWiFi,
      busType: busType ?? this.busType,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

/// ===============================
/// BUS DATA PROVIDER
/// ===============================

final busProvider = Provider<List<Bus>>((ref) {
  return _dummyBuses;
});

/// ===============================
/// FILTER STATE PROVIDER
/// ===============================

final busFilterProvider =
StateProvider<BusFilter>((ref) => BusFilter());

/// ===============================
/// FILTERED BUS PROVIDER
/// ===============================

final filteredBusProvider = Provider<List<Bus>>((ref) {
  final buses = ref.watch(busProvider);
  final filter = ref.watch(busFilterProvider);

  List<Bus> filtered = buses.where((bus) {
    if (filter.minPrice != null && bus.price < filter.minPrice!) return false;
    if (filter.maxPrice != null && bus.price > filter.maxPrice!) return false;
    if (filter.minRating != null && bus.rating < filter.minRating!) return false;
    if (filter.isAC != null && bus.isAC != filter.isAC!) return false;
    if (filter.isWiFi != null && bus.isWiFi != filter.isWiFi!) return false;
    if (filter.busType != null &&
        !bus.seatLayout.busType
            .toLowerCase()
            .contains(filter.busType!.toLowerCase())) {
      return false;
    }
    return true;
  }).toList();

  switch (filter.sortBy) {
    case 'price':
      filtered.sort((a, b) => a.price.compareTo(b.price));
      break;
    case 'rating':
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    case 'departure':
      filtered.sort(
            (a, b) => a.departureTime.compareTo(b.departureTime),
      );
      break;
  }

  return filtered;
});

/// ===============================
/// DUMMY BUS DATA
/// ===============================

final List<Bus> _dummyBuses = [
  // 👉 apna existing bus_001 → bus_004 yahin paste karo
];
