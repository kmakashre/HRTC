import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/user/travel/Travel/provider/travel_Provider.dart';

enum FlightClass { economy, premiumEconomy, business, first }

enum AirlineType { fullService, lowCost }

enum FlightType { direct, oneStop, multipleStops }

class Airport {
  final String code;
  final String name;
  final String city;
  final String terminal;

  Airport({
    required this.code,
    required this.name,
    required this.city,
    required this.terminal,
  });
}

class FlightSegment {
  final Airport departure;
  final Airport arrival;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String aircraftType;
  final String flightNumber;
  final Duration duration;

  FlightSegment({
    required this.departure,
    required this.arrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.aircraftType,
    required this.flightNumber,
    required this.duration,
  });
}

class FlightAmenities {
  final bool wifi;
  final bool meals;
  final bool entertainment;
  final bool powerOutlet;
  final bool extraLegroom;
  final int baggageKg;
  final int handBaggageKg;

  FlightAmenities({
    required this.wifi,
    required this.meals,
    required this.entertainment,
    required this.powerOutlet,
    required this.extraLegroom,
    required this.baggageKg,
    required this.handBaggageKg,
  });
}

class Flight {
  final String id;
  final String airline;
  final String airlineCode;
  final AirlineType airlineType;
  final String airlineLogo;
  final List<FlightSegment> segments;
  final FlightType flightType;
  final FlightClass flightClass;
  final double basePrice;
  final double totalPrice;
  final double taxes;
  final double rating;
  final int reviewCount;
  final Duration totalDuration;
  final Duration layoverDuration;
  final FlightAmenities amenities;
  final bool isRefundable;
  final bool isReschedulable;
  final String cancellationPolicy;
  final int seatsAvailable;
  final List<String> fareTypes;
  final DateTime lastUpdated;
  final bool isPopular;
  final bool isCheapest;
  final bool isFastest;
  final List<String> availableSeats;

  Flight({
    required this.id,
    required this.airline,
    required this.airlineCode,
    required this.airlineType,
    required this.airlineLogo,
    required this.segments,
    required this.flightType,
    required this.flightClass,
    required this.basePrice,
    required this.totalPrice,
    required this.taxes,
    required this.rating,
    required this.reviewCount,
    required this.totalDuration,
    required this.layoverDuration,
    required this.amenities,
    required this.isRefundable,
    required this.isReschedulable,
    required this.cancellationPolicy,
    required this.seatsAvailable,
    required this.fareTypes,
    required this.lastUpdated,
    required this.isPopular,
    required this.isCheapest,
    required this.isFastest,
    required this.availableSeats,
  });

  String get route =>
      '${segments.first.departure.city} to ${segments.last.arrival.city}';
  String get timeRange =>
      '${_formatTime(segments.first.departureTime)} - ${_formatTime(segments.last.arrivalTime)}';
  String get departureTime => _formatTime(segments.first.departureTime);
  String get arrivalTime => _formatTime(segments.last.arrivalTime);

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class FlightFilters {
  final RangeValues? priceRange;
  final RangeValues? departureTimeRange;
  final RangeValues? arrivalTimeRange;
  final RangeValues? durationRange;
  final List<String> selectedAirlines;
  final List<FlightType> selectedFlightTypes;
  final List<FlightClass> selectedFlightClasses;
  final double? minRating;
  final bool? refundableOnly;
  final bool? wifiRequired;
  final bool? mealsRequired;
  final bool? directFlightsOnly;
  final String sortBy;

  FlightFilters({
    this.priceRange,
    this.departureTimeRange,
    this.arrivalTimeRange,
    this.durationRange,
    this.selectedAirlines = const [],
    this.selectedFlightTypes = const [],
    this.selectedFlightClasses = const [],
    this.minRating,
    this.refundableOnly,
    this.wifiRequired,
    this.mealsRequired,
    this.directFlightsOnly,
    this.sortBy = 'price',
  });

  FlightFilters copyWith({
    RangeValues? priceRange,
    RangeValues? departureTimeRange,
    RangeValues? arrivalTimeRange,
    RangeValues? durationRange,
    List<String>? selectedAirlines,
    List<FlightType>? selectedFlightTypes,
    List<FlightClass>? selectedFlightClasses,
    double? minRating,
    bool? refundableOnly,
    bool? wifiRequired,
    bool? mealsRequired,
    bool? directFlightsOnly,
    String? sortBy,
  }) {
    return FlightFilters(
      priceRange: priceRange ?? this.priceRange,
      departureTimeRange: departureTimeRange ?? this.departureTimeRange,
      arrivalTimeRange: arrivalTimeRange ?? this.arrivalTimeRange,
      durationRange: durationRange ?? this.durationRange,
      selectedAirlines: selectedAirlines ?? this.selectedAirlines,
      selectedFlightTypes: selectedFlightTypes ?? this.selectedFlightTypes,
      selectedFlightClasses:
          selectedFlightClasses ?? this.selectedFlightClasses,
      minRating: minRating ?? this.minRating,
      refundableOnly: refundableOnly ?? this.refundableOnly,
      wifiRequired: wifiRequired ?? this.wifiRequired,
      mealsRequired: mealsRequired ?? this.mealsRequired,
      directFlightsOnly: directFlightsOnly ?? this.directFlightsOnly,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

final flightFiltersProvider =
    StateNotifierProvider<FlightFiltersNotifier, FlightFilters>((ref) {
      return FlightFiltersNotifier();
    });

class FlightFiltersNotifier extends StateNotifier<FlightFilters> {
  FlightFiltersNotifier() : super(FlightFilters());

  void updateFilters(FlightFilters newFilters) {
    state = newFilters;
  }

  void resetFilters() {
    state = FlightFilters();
  }

  void updateSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }
}

final _airports = {
  'mumbai': Airport(
    code: 'BOM',
    name: 'Chhatrapati Shivaji Maharaj International Airport',
    city: 'Mumbai',
    terminal: 'T2',
  ),
  'delhi': Airport(
    code: 'DEL',
    name: 'Indira Gandhi International Airport',
    city: 'Delhi',
    terminal: 'T3',
  ),
  'bangalore': Airport(
    code: 'BLR',
    name: 'Kempegowda International Airport',
    city: 'Bangalore',
    terminal: 'T1',
  ),
  'hyderabad': Airport(
    code: 'HYD',
    name: 'Rajiv Gandhi International Airport',
    city: 'Hyderabad',
    terminal: 'T1',
  ),
  'chennai': Airport(
    code: 'MAA',
    name: 'Chennai International Airport',
    city: 'Chennai',
    terminal: 'T1',
  ),
};

final flightProvider = Provider<List<Flight>>((ref) {
  final travelState = ref.watch(travelProvider);
  final now = DateTime.now();

  // Debug: Log travelState
  print(
    'flightProvider: from=${travelState.fromLocation}, to=${travelState.toLocation}',
  );

  final flights = [
    Flight(
      id: '1',
      airline: 'IndiGo',
      airlineCode: '6E',
      airlineType: AirlineType.lowCost,
      airlineLogo: 'https://via.placeholder.com/40?text=IndiGo',
      segments: [
        FlightSegment(
          departure:
              _airports[travelState.fromLocation.toLowerCase()] ??
              _airports['mumbai']!,
          arrival:
              _airports[travelState.toLocation.toLowerCase()] ??
              _airports['delhi']!,
          departureTime: DateTime(now.year, now.month, now.day, 6, 30),
          arrivalTime: DateTime(now.year, now.month, now.day, 8, 45),
          aircraftType: 'Airbus A320',
          flightNumber: '6E-345',
          duration: const Duration(hours: 2, minutes: 15),
        ),
      ],
      flightType: FlightType.direct,
      flightClass: FlightClass.economy,
      basePrice: 4200,
      totalPrice: 4950,
      taxes: 750,
      rating: 4.2,
      reviewCount: 2845,
      totalDuration: const Duration(hours: 2, minutes: 15),
      layoverDuration: Duration.zero,
      amenities: FlightAmenities(
        wifi: false,
        meals: false,
        entertainment: true,
        powerOutlet: false,
        extraLegroom: false,
        baggageKg: 15,
        handBaggageKg: 7,
      ),
      isRefundable: false,
      isReschedulable: true,
      cancellationPolicy: 'Non-refundable',
      seatsAvailable: 12,
      fareTypes: ['Saver', 'Flexi'],
      lastUpdated: now,
      isPopular: false,
      isCheapest: true,
      isFastest: true,
      availableSeats: [
        '1A',
        '1B',
        '2A',
        '2B',
        '3A',
        '3B',
        '4A',
        '4B',
        '5A',
        '5B',
        '6A',
        '6B',
      ],
    ),
    Flight(
      id: '2',
      airline: 'Air India',
      airlineCode: 'AI',
      airlineType: AirlineType.fullService,
      airlineLogo: 'https://via.placeholder.com/40?text=AirIndia',
      segments: [
        FlightSegment(
          departure:
              _airports[travelState.fromLocation.toLowerCase()] ??
              _airports['mumbai']!,
          arrival:
              _airports[travelState.toLocation.toLowerCase()] ??
              _airports['delhi']!,
          departureTime: DateTime(now.year, now.month, now.day, 9, 15),
          arrivalTime: DateTime(now.year, now.month, now.day, 11, 45),
          aircraftType: 'Boeing 737',
          flightNumber: 'AI-131',
          duration: const Duration(hours: 2, minutes: 30),
        ),
      ],
      flightType: FlightType.direct,
      flightClass: FlightClass.economy,
      basePrice: 5200,
      totalPrice: 6100,
      taxes: 900,
      rating: 4.0,
      reviewCount: 1823,
      totalDuration: const Duration(hours: 2, minutes: 30),
      layoverDuration: Duration.zero,
      amenities: FlightAmenities(
        wifi: true,
        meals: true,
        entertainment: true,
        powerOutlet: true,
        extraLegroom: false,
        baggageKg: 23,
        handBaggageKg: 8,
      ),
      isRefundable: true,
      isReschedulable: true,
      cancellationPolicy: 'Refundable with fee',
      seatsAvailable: 8,
      fareTypes: ['Economy', 'Premium Economy'],
      lastUpdated: now,
      isPopular: true,
      isCheapest: false,
      isFastest: false,
      availableSeats: ['1C', '1D', '2C', '2D', '3C', '3D', '4C', '4D'],
    ),
    Flight(
      id: '3',
      airline: 'SpiceJet',
      airlineCode: 'SG',
      airlineType: AirlineType.lowCost,
      airlineLogo: 'https://via.placeholder.com/40?text=SpiceJet',
      segments: [
        FlightSegment(
          departure:
              _airports[travelState.fromLocation.toLowerCase()] ??
              _airports['mumbai']!,
          arrival: _airports['hyderabad']!,
          departureTime: DateTime(now.year, now.month, now.day, 12, 30),
          arrivalTime: DateTime(now.year, now.month, now.day, 13, 45),
          aircraftType: 'Boeing 737',
          flightNumber: 'SG-8132',
          duration: const Duration(hours: 1, minutes: 15),
        ),
        FlightSegment(
          departure: _airports['hyderabad']!,
          arrival:
              _airports[travelState.toLocation.toLowerCase()] ??
              _airports['delhi']!,
          departureTime: DateTime(now.year, now.month, now.day, 15, 30),
          arrivalTime: DateTime(now.year, now.month, now.day, 17, 45),
          aircraftType: 'Boeing 737',
          flightNumber: 'SG-425',
          duration: const Duration(hours: 2, minutes: 15),
        ),
      ],
      flightType: FlightType.oneStop,
      flightClass: FlightClass.economy,
      basePrice: 3800,
      totalPrice: 4450,
      taxes: 650,
      rating: 3.8,
      reviewCount: 1456,
      totalDuration: const Duration(hours: 5, minutes: 15),
      layoverDuration: const Duration(hours: 1, minutes: 45),
      amenities: FlightAmenities(
        wifi: false,
        meals: false,
        entertainment: false,
        powerOutlet: false,
        extraLegroom: false,
        baggageKg: 15,
        handBaggageKg: 7,
      ),
      isRefundable: false,
      isReschedulable: false,
      cancellationPolicy: 'Non-refundable',
      seatsAvailable: 18,
      fareTypes: ['SpiceSaver', 'SpiceMax'],
      lastUpdated: now,
      isPopular: false,
      isCheapest: false,
      isFastest: false,
      availableSeats: [
        '7A',
        '7B',
        '8A',
        '8B',
        '9A',
        '9B',
        '10A',
        '10B',
        '11A',
        '11B',
        '12A',
        '12B',
        '13A',
        '13B',
        '14A',
        '14B',
        '15A',
        '15B',
      ],
    ),
    Flight(
      id: '4',
      airline: 'Vistara',
      airlineCode: 'UK',
      airlineType: AirlineType.fullService,
      airlineLogo: 'https://via.placeholder.com/40?text=Vistara',
      segments: [
        FlightSegment(
          departure:
              _airports[travelState.fromLocation.toLowerCase()] ??
              _airports['mumbai']!,
          arrival:
              _airports[travelState.toLocation.toLowerCase()] ??
              _airports['delhi']!,
          departureTime: DateTime(now.year, now.month, now.day, 16, 45),
          arrivalTime: DateTime(now.year, now.month, now.day, 19, 10),
          aircraftType: 'Airbus A320neo',
          flightNumber: 'UK-965',
          duration: const Duration(hours: 2, minutes: 25),
        ),
      ],
      flightType: FlightType.direct,
      flightClass: FlightClass.business,
      basePrice: 12500,
      totalPrice: 14750,
      taxes: 2250,
      rating: 4.6,
      reviewCount: 892,
      totalDuration: const Duration(hours: 2, minutes: 25),
      layoverDuration: Duration.zero,
      amenities: FlightAmenities(
        wifi: true,
        meals: true,
        entertainment: true,
        powerOutlet: true,
        extraLegroom: true,
        baggageKg: 35,
        handBaggageKg: 8,
      ),
      isRefundable: true,
      isReschedulable: true,
      cancellationPolicy: 'Free cancellation',
      seatsAvailable: 4,
      fareTypes: ['Business', 'Premium Business'],
      lastUpdated: now,
      isPopular: true,
      isCheapest: false,
      isFastest: false,
      availableSeats: ['1E', '1F', '2E', '2F'],
    ),
    // Additional flight for broader coverage
    Flight(
      id: '5',
      airline: 'GoAir',
      airlineCode: 'G8',
      airlineType: AirlineType.lowCost,
      airlineLogo: 'https://via.placeholder.com/40?text=GoAir',
      segments: [
        FlightSegment(
          departure:
              _airports[travelState.fromLocation.toLowerCase()] ??
              _airports['mumbai']!,
          arrival:
              _airports[travelState.toLocation.toLowerCase()] ??
              _airports['chennai']!,
          departureTime: DateTime(now.year, now.month, now.day, 10, 0),
          arrivalTime: DateTime(now.year, now.month, now.day, 12, 30),
          aircraftType: 'Airbus A320',
          flightNumber: 'G8-123',
          duration: const Duration(hours: 2, minutes: 30),
        ),
      ],
      flightType: FlightType.direct,
      flightClass: FlightClass.economy,
      basePrice: 4500,
      totalPrice: 5250,
      taxes: 750,
      rating: 3.9,
      reviewCount: 1200,
      totalDuration: const Duration(hours: 2, minutes: 30),
      layoverDuration: Duration.zero,
      amenities: FlightAmenities(
        wifi: false,
        meals: false,
        entertainment: true,
        powerOutlet: false,
        extraLegroom: false,
        baggageKg: 15,
        handBaggageKg: 7,
      ),
      isRefundable: false,
      isReschedulable: true,
      cancellationPolicy: 'Non-refundable',
      seatsAvailable: 10,
      fareTypes: ['GoSmart', 'GoFlexi'],
      lastUpdated: now,
      isPopular: false,
      isCheapest: false,
      isFastest: false,
      availableSeats: [
        '1A',
        '1B',
        '2A',
        '2B',
        '3A',
        '3B',
        '4A',
        '4B',
        '5A',
        '5B',
      ],
    ),
  ];

  // Filter flights based on tripType
  if (travelState.tripType == TripType.roundTrip) {
    final returnFlights =
        flights.map((flight) {
          final newSegments =
              flight.segments.map((segment) {
                return FlightSegment(
                  departure: segment.arrival,
                  arrival: segment.departure,
                  departureTime: segment.arrivalTime.add(
                    const Duration(hours: 24),
                  ),
                  arrivalTime: segment.arrivalTime.add(
                    const Duration(hours: 26, minutes: 15),
                  ),
                  aircraftType: segment.aircraftType,
                  flightNumber: '${segment.flightNumber}-R',
                  duration: segment.duration,
                );
              }).toList();
          return Flight(
            id: '${flight.id}-R',
            airline: flight.airline,
            airlineCode: flight.airlineCode,
            airlineType: flight.airlineType,
            airlineLogo: flight.airlineLogo,
            segments: newSegments,
            flightType: flight.flightType,
            flightClass: flight.flightClass,
            basePrice: flight.basePrice,
            totalPrice: flight.totalPrice,
            taxes: flight.taxes,
            rating: flight.rating,
            reviewCount: flight.reviewCount,
            totalDuration: flight.totalDuration,
            layoverDuration: flight.layoverDuration,
            amenities: flight.amenities,
            isRefundable: flight.isRefundable,
            isReschedulable: flight.isReschedulable,
            cancellationPolicy: flight.cancellationPolicy,
            seatsAvailable: flight.seatsAvailable,
            fareTypes: flight.fareTypes,
            lastUpdated: flight.lastUpdated,
            isPopular: flight.isPopular,
            isCheapest: flight.isCheapest,
            isFastest: flight.isFastest,
            availableSeats: flight.availableSeats,
          );
        }).toList();
    return [...flights, ...returnFlights];
  }

  return flights;
});

final filteredFlightsProvider = Provider<List<Flight>>((ref) {
  final flights = ref.watch(flightProvider);
  final filters = ref.watch(flightFiltersProvider);
  final travelState = ref.watch(travelProvider);

  // Debug: Log filtering inputs
  print(
    'Filtering flights: from=${travelState.fromLocation}, to=${travelState.toLocation}, filters=$filters',
  );

  var filteredFlights =
      flights.where((flight) {
        // Case-insensitive matching
        final fromMatch =
            flight.segments.first.departure.city.toLowerCase() ==
            travelState.fromLocation.toLowerCase();
        final toMatch =
            flight.segments.last.arrival.city.toLowerCase() ==
            travelState.toLocation.toLowerCase();

        if (!fromMatch || !toMatch) {
          print(
            'Flight excluded: ${flight.id}, from=${flight.segments.first.departure.city}, to=${flight.segments.last.arrival.city}',
          );
          return false;
        }

        if (filters.priceRange != null) {
          if (flight.totalPrice < filters.priceRange!.start ||
              flight.totalPrice > filters.priceRange!.end) {
            return false;
          }
        }

        if (filters.selectedAirlines.isNotEmpty &&
            !filters.selectedAirlines.contains(flight.airline)) {
          return false;
        }

        if (filters.selectedFlightTypes.isNotEmpty &&
            !filters.selectedFlightTypes.contains(flight.flightType)) {
          return false;
        }

        if (filters.selectedFlightClasses.isNotEmpty &&
            !filters.selectedFlightClasses.contains(flight.flightClass)) {
          return false;
        }

        if (filters.minRating != null && flight.rating < filters.minRating!) {
          return false;
        }

        if (filters.refundableOnly == true && !flight.isRefundable) {
          return false;
        }

        if (filters.wifiRequired == true && !flight.amenities.wifi) {
          return false;
        }

        if (filters.mealsRequired == true && !flight.amenities.meals) {
          return false;
        }

        if (filters.directFlightsOnly == true &&
            flight.flightType != FlightType.direct) {
          return false;
        }

        return true;
      }).toList();

  // Debug: Log filtered results
  print('Filtered flights count: ${filteredFlights.length}');

  switch (filters.sortBy) {
    case 'price':
      filteredFlights.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
      break;
    case 'duration':
      filteredFlights.sort(
        (a, b) => a.totalDuration.compareTo(b.totalDuration),
      );
      break;
    case 'departure':
      filteredFlights.sort(
        (a, b) => a.segments.first.departureTime.compareTo(
          b.segments.first.departureTime,
        ),
      );
      break;
    case 'rating':
      filteredFlights.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    case 'popularity':
      filteredFlights.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      break;
  }

  return filteredFlights;
});

final flightStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final flights = ref.watch(filteredFlightsProvider);

  if (flights.isEmpty) return {};

  final prices = flights.map((f) => f.totalPrice).toList();
  final durations = flights.map((f) => f.totalDuration.inMinutes).toList();

  return {
    'minPrice': prices.isNotEmpty ? prices.reduce((a, b) => a < b ? a : b) : 0,
    'maxPrice':
        prices.isNotEmpty ? prices.reduce((a, b) => a > b ? a : b) : 20000,
    'avgPrice':
        prices.isNotEmpty ? prices.reduce((a, b) => a + b) / prices.length : 0,
    'minDuration':
        durations.isNotEmpty ? durations.reduce((a, b) => a < b ? a : b) : 0,
    'maxDuration':
        durations.isNotEmpty ? durations.reduce((a, b) => a > b ? a : b) : 0,
    'totalFlights': flights.length,
    'directFlights':
        flights.where((f) => f.flightType == FlightType.direct).length,
    'airlines': flights.map((f) => f.airline).toSet().toList(),
  };
});
