import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final String busType; // AC/Non-AC, Sleeper/Semi-Sleeper, etc.

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

// Sample data provider
final busProvider = Provider<List<Bus>>((ref) {
  return [
    Bus(
      id: 'bus_001',
      operator: 'RedBus Premium Express',
      operatorLogo:
          'https://logos-world.net/wp-content/uploads/2021/11/RedBus-Logo.png',
      route: 'Bangalore to Chennai',
      fromCity: 'Bangalore',
      toCity: 'Chennai',
      departureTime: '8:00 PM',
      arrivalTime: '5:00 AM',
      duration: '9h 00m',
      price: 680.0,
      originalPrice: 850.0,
      rating: 4.6,
      totalReviews: 2847,
      busNumber: 'KA05AB1234',
      busImage:
          'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=500&h=300&fit=crop',
      busOwner: 'RedBus Travels Pvt Ltd',
      isAC: true,
      isWiFi: true,
      isGPS: true,
      isCCTV: true,
      discountPercent: 20.0,
      cancellationPolicy: 'Free cancellation up to 24 hours before departure',
      pickupPoints: [
        'Electronic City - 7:30 PM',
        'Silk Board - 7:45 PM',
        'Bommanahalli - 8:00 PM',
        'Majestic Bus Station - 8:15 PM',
      ],
      dropoffPoints: [
        'Koyambedu Bus Terminal - 4:45 AM',
        'Chennai Central - 5:00 AM',
        'T Nagar - 5:15 AM',
        'Velachery - 5:30 AM',
      ],
      amenities: [
        BusAmenity(name: 'AC', icon: '❄️'),
        BusAmenity(name: 'WiFi', icon: '📶'),
        BusAmenity(name: 'GPS', icon: '🛰️'),
        BusAmenity(name: 'CCTV', icon: '📹'),
        BusAmenity(name: 'Charging Port', icon: '🔌'),
        BusAmenity(name: 'Reading Light', icon: '💡'),
      ],
      seatLayout: SeatLayout(
        totalSeats: 45,
        availableSeats: 12,
        busType: 'AC Semi-Sleeper',
      ),
      reviews: [
        Review(
          userName: 'Priya S.',
          rating: 4.5,
          comment:
              'Comfortable journey with good amenities. Driver was professional.',
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Review(
          userName: 'Rajesh K.',
          rating: 4.8,
          comment:
              'Excellent service, on-time departure and arrival. Highly recommended!',
          date: DateTime.now().subtract(const Duration(days: 12)),
        ),
      ],
    ),
    Bus(
      id: 'bus_002',
      operator: 'VRL Travels Deluxe',
      operatorLogo: 'https://www.vrlgroup.in/images/logo.png',
      route: 'Bangalore to Chennai',
      fromCity: 'Bangalore',
      toCity: 'Chennai',
      departureTime: '9:00 PM',
      arrivalTime: '6:00 AM',
      duration: '9h 00m',
      price: 750.0,
      originalPrice: 900.0,
      rating: 4.5,
      totalReviews: 1923,
      busNumber: 'KA02CD5678',
      busImage:
          'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?w=500&h=300&fit=crop',
      busOwner: 'VRL Logistics Ltd',
      isAC: true,
      isWiFi: false,
      isGPS: true,
      isCCTV: true,
      discountPercent: 16.7,
      cancellationPolicy: 'Cancellation charges apply as per policy',
      pickupPoints: [
        'Yeshwantpur - 8:30 PM',
        'Hebbal - 8:45 PM',
        'Devanahalli - 9:00 PM',
        'Whitefield - 9:15 PM',
      ],
      dropoffPoints: [
        'Madhavaram - 5:30 AM',
        'Koyambedu - 5:45 AM',
        'Chennai Central - 6:00 AM',
        'Mylapore - 6:15 AM',
      ],
      amenities: [
        BusAmenity(name: 'AC', icon: '❄️'),
        BusAmenity(name: 'GPS', icon: '🛰️'),
        BusAmenity(name: 'CCTV', icon: '📹'),
        BusAmenity(name: 'Charging Port', icon: '🔌'),
        BusAmenity(name: 'Water Bottle', icon: '💧'),
      ],
      seatLayout: SeatLayout(
        totalSeats: 40,
        availableSeats: 8,
        busType: 'AC Sleeper',
      ),
      reviews: [
        Review(
          userName: 'Anita M.',
          rating: 4.3,
          comment: 'Good service but could improve on punctuality.',
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Review(
          userName: 'Suresh R.',
          rating: 4.7,
          comment: 'Very comfortable seats and smooth ride. Will book again.',
          date: DateTime.now().subtract(const Duration(days: 8)),
        ),
      ],
    ),
    Bus(
      id: 'bus_003',
      operator: 'SRS Travels Luxury',
      operatorLogo: 'https://via.placeholder.com/100x50/0066CC/FFFFFF?text=SRS',
      route: 'Bangalore to Chennai',
      fromCity: 'Bangalore',
      toCity: 'Chennai',
      departureTime: '10:30 PM',
      arrivalTime: '7:30 AM',
      duration: '9h 00m',
      price: 950.0,
      originalPrice: 1200.0,
      rating: 4.8,
      totalReviews: 3421,
      busNumber: 'TN09EF9101',
      busImage:
          'https://images.unsplash.com/photo-1558618138-1076c918ac74?w=500&h=300&fit=crop',
      busOwner: 'SRS Logistics Pvt Ltd',
      isAC: true,
      isWiFi: true,
      isGPS: true,
      isCCTV: true,
      discountPercent: 20.8,
      cancellationPolicy: 'Free cancellation up to 12 hours before departure',
      pickupPoints: [
        'HSR Layout - 10:00 PM',
        'BTM Layout - 10:15 PM',
        'Jayanagar - 10:30 PM',
        'Banashankari - 10:45 PM',
      ],
      dropoffPoints: [
        'Tambaram - 7:00 AM',
        'Guindy - 7:15 AM',
        'Chennai Airport - 7:30 AM',
        'Anna Nagar - 7:45 AM',
      ],
      amenities: [
        BusAmenity(name: 'AC', icon: '❄️'),
        BusAmenity(name: 'WiFi', icon: '📶'),
        BusAmenity(name: 'GPS', icon: '🛰️'),
        BusAmenity(name: 'CCTV', icon: '📹'),
        BusAmenity(name: 'Charging Port', icon: '🔌'),
        BusAmenity(name: 'Entertainment', icon: '🎬'),
        BusAmenity(name: 'Blanket', icon: '🛏️'),
        BusAmenity(name: 'Snacks', icon: '🍪'),
      ],
      seatLayout: SeatLayout(
        totalSeats: 32,
        availableSeats: 15,
        busType: 'Luxury AC Sleeper',
      ),
      reviews: [
        Review(
          userName: 'Deepika L.',
          rating: 5.0,
          comment: 'Outstanding service! Premium experience worth every penny.',
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Review(
          userName: 'Vikram P.',
          rating: 4.6,
          comment:
              'Excellent comfort and hospitality. Highly recommended for long journeys.',
          date: DateTime.now().subtract(const Duration(days: 7)),
        ),
      ],
    ),
    Bus(
      id: 'bus_004',
      operator: 'Orange Travels Express',
      operatorLogo:
          'https://via.placeholder.com/100x50/FF6600/FFFFFF?text=ORANGE',
      route: 'Bangalore to Chennai',
      fromCity: 'Bangalore',
      toCity: 'Chennai',
      departureTime: '11:45 PM',
      arrivalTime: '8:45 AM',
      duration: '9h 00m',
      price: 580.0,
      originalPrice: 720.0,
      rating: 4.2,
      totalReviews: 1456,
      busNumber: 'KA03GH2468',
      busImage:
          'https://images.unsplash.com/photo-1544620677-3391c4e9e97e?w=500&h=300&fit=crop',
      busOwner: 'Orange Express Pvt Ltd',
      isAC: true,
      isWiFi: false,
      isGPS: true,
      isCCTV: false,
      discountPercent: 19.4,
      cancellationPolicy: 'Cancellation charges as per terms and conditions',
      pickupPoints: [
        'KR Puram - 11:15 PM',
        'Marathahalli - 11:30 PM',
        'Bellandur - 11:45 PM',
        'Electronic City - 12:00 AM',
      ],
      dropoffPoints: [
        'Poonamallee - 8:15 AM',
        'Perambur - 8:30 AM',
        'Chennai Central - 8:45 AM',
        'Egmore - 9:00 AM',
      ],
      amenities: [
        BusAmenity(name: 'AC', icon: '❄️'),
        BusAmenity(name: 'GPS', icon: '🛰️'),
        BusAmenity(name: 'Charging Port', icon: '🔌'),
        BusAmenity(name: 'Reading Light', icon: '💡'),
      ],
      seatLayout: SeatLayout(
        totalSeats: 50,
        availableSeats: 22,
        busType: 'AC Semi-Sleeper',
      ),
      reviews: [
        Review(
          userName: 'Ravi K.',
          rating: 4.0,
          comment: 'Good value for money. Basic amenities available.',
          date: DateTime.now().subtract(const Duration(days: 4)),
        ),
        Review(
          userName: 'Meera S.',
          rating: 4.4,
          comment: 'Comfortable journey with friendly staff.',
          date: DateTime.now().subtract(const Duration(days: 9)),
        ),
      ],
    ),
  ];
});

// Filter providers
final busFilterProvider = StateProvider<BusFilter>((ref) => BusFilter());

class BusFilter {
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool? isAC;
  final bool? isWiFi;
  final String? busType;
  final String? sortBy; // price, rating, duration, departure

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

final filteredBusProvider = Provider<List<Bus>>((ref) {
  final buses = ref.watch(busProvider);
  final filter = ref.watch(busFilterProvider);

  var filteredBuses =
      buses.where((bus) {
        if (filter.minPrice != null && bus.price < filter.minPrice!) {
          return false;
        }
        if (filter.maxPrice != null && bus.price > filter.maxPrice!) {
          return false;
        }
        if (filter.minRating != null && bus.rating < filter.minRating!) {
          return false;
        }
        if (filter.isAC != null && bus.isAC != filter.isAC!) return false;
        if (filter.isWiFi != null && bus.isWiFi != filter.isWiFi!) return false;
        if (filter.busType != null &&
            !bus.seatLayout.busType.contains(filter.busType!)) {
          return false;
        }
        return true;
      }).toList();

  // Sort buses
  if (filter.sortBy != null) {
    switch (filter.sortBy) {
      case 'price':
        filteredBuses.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'rating':
        filteredBuses.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'departure':
        filteredBuses.sort(
          (a, b) => a.departureTime.compareTo(b.departureTime),
        );
        break;
    }
  }

  return filteredBuses;
});
