import 'package:flutter_riverpod/flutter_riverpod.dart';

// Hotel model
class Hotel {
  final String id;
  final String name;
  final String city;
  final String address;
  final double rating;
  final int reviews;
  final String pricePerNight;
  final List<String> amenities;
  final String imageUrl;
  final bool isTopRated;

  Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.rating,
    required this.reviews,
    required this.pricePerNight,
    required this.amenities,
    required this.imageUrl,
    this.isTopRated = false,
  });
}

// Room model
class Room {
  final String id;
  final String hotelId;
  final String type;
  final double price;
  final List<String> features;
  final String imageUrl;

  Room({
    required this.id,
    required this.hotelId,
    required this.type,
    required this.price,
    required this.features,
    required this.imageUrl,
  });
}

// Search parameters
class HotelSearch {
  final String city;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int children;
  final int rooms;

  HotelSearch({
    required this.city,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.children,
    required this.rooms,
  });
}

// Filter state
class HotelFilter {
  final double minPrice;
  final double maxPrice;
  final double minRating;
  final List<String> amenities;
  final String sortBy;

  HotelFilter({
    this.minPrice = 0,
    this.maxPrice = 20000.0,
    this.minRating = 0,
    this.amenities = const [],
    this.sortBy = 'Popular',
  });

  HotelFilter copyWith({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    List<String>? amenities,
    String? sortBy,
  }) {
    return HotelFilter(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      amenities: amenities ?? this.amenities,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

// Hotel state
class HotelState {
  final HotelSearch? search;
  final HotelFilter filter;
  final Hotel? selectedHotel;
  final Room? selectedRoom;

  HotelState({
    this.search,
    required this.filter,
    this.selectedHotel,
    this.selectedRoom,
  });

  HotelState copyWith({
    HotelSearch? search,
    HotelFilter? filter,
    Hotel? selectedHotel,
    Room? selectedRoom,
  }) {
    return HotelState(
      search: search ?? this.search,
      filter: filter ?? this.filter,
      selectedHotel: selectedHotel ?? this.selectedHotel,
      selectedRoom: selectedRoom ?? this.selectedRoom,
    );
  }
}

// Static hotel data
final List<Hotel> _hotels = [
  // Top-rated hotels
  Hotel(
    id: '1',
    name: 'Taj Mahal Palace',
    city: 'Mumbai',
    address: 'Apollo Bunder, Colaba',
    rating: 4.8,
    reviews: 3500,
    pricePerNight: '₹12000.0',
    amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant', 'Parking'],
    imageUrl:
        'https://images.unsplash.com/photo-1660924053994-e9a18d16b810?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGhvdGVscyUyMHZpZXd8ZW58MHx8MHx8fDA%3D',
    isTopRated: true,
  ),
  Hotel(
    id: '2',
    name: 'The Oberoi',
    city: 'Mumbai',
    address: 'Nariman Point',
    rating: 4.9,
    reviews: 2800,
    pricePerNight: '₹15000.0',
    amenities: ['WiFi', 'Gym', 'Restaurant', 'Bar', 'Room Service'],
    imageUrl: 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9',
    isTopRated: true,
  ),
  Hotel(
    id: '3',
    name: 'Leela Palace',
    city: 'Delhi',
    address: 'Diplomatic Enclave, Chanakyapuri',
    rating: 4.7,
    reviews: 3000,
    pricePerNight: '₹14000.0',
    amenities: ['WiFi', 'Pool', 'Bar', 'Spa', 'Breakfast Included'],
    imageUrl: 'https://images.unsplash.com/photo-1542314831-8f72cc1d260b',
    isTopRated: true,
  ),
  // Mumbai hotels
  Hotel(
    id: '4',
    name: 'JW Marriott',
    city: 'Mumbai',
    address: 'Juhu Tara Rd, Juhu',
    rating: 4.6,
    reviews: 2000,
    pricePerNight: '₹11000.0',
    amenities: ['WiFi', 'Spa', 'Gym', 'Pool', 'Restaurant'],
    imageUrl: 'https://images.unsplash.com/photo-1584132967334-10e028bd69f7',
  ),
  Hotel(
    id: '5',
    name: 'Trident',
    city: 'Mumbai',
    address: 'Bandra Kurla Complex',
    rating: 4.5,
    reviews: 1800,
    pricePerNight: '₹9000.0',
    amenities: ['WiFi', 'Restaurant', 'Parking', 'Room Service'],
    imageUrl: 'https://images.unsplash.com/photo-1596394519084-2b8b34085e47',
  ),
  Hotel(
    id: '6',
    name: 'Sofitel BKC',
    city: 'Mumbai',
    address: 'Bandra Kurla Complex',
    rating: 4.4,
    reviews: 1500,
    pricePerNight: '₹9500',
    amenities: ['WiFi', 'Pool', 'Gym', 'Bar'],
    imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
  ),
  // Goa hotels
  Hotel(
    id: '7',
    name: 'Grand Hyatt',
    city: 'Goa',
    address: 'Bambolim Beach',
    rating: 4.7,
    reviews: 2200,
    pricePerNight: '₹13000.0',
    amenities: ['WiFi', 'Pool', 'Beach Access', 'Spa', 'Restaurant'],
    imageUrl: 'https://images.unsplash.com/photo-1611892440504-42a792e24d3f',
  ),
  Hotel(
    id: '8',
    name: 'Alila Diwa',
    city: 'Goa',
    address: 'Majorda Beach',
    rating: 4.6,
    reviews: 1900,
    pricePerNight: '₹1000.00',
    amenities: ['WiFi', 'Spa', 'Pool', 'Restaurant', 'Yoga Classes'],
    imageUrl: 'https://images.unsplash.com/photo-1561501900-3701fa6a086f',
  ),
  Hotel(
    id: '9',
    name: 'Zuri White Sands',
    city: 'Goa',
    address: 'Varca Beach',
    rating: 4.5,
    reviews: 1700,
    pricePerNight: '₹11000.0',
    amenities: ['WiFi', 'Beach Access', 'Casino', 'Pool'],
    imageUrl: 'https://images.unsplash.com/photo-1578683012567-0085b2b7d7e4',
  ),
  // Delhi hotels
  Hotel(
    id: '10',
    name: 'ITC Maurya',
    city: 'Delhi',
    address: 'Sardar Patel Marg',
    rating: 4.8,
    reviews: 2500,
    pricePerNight: '₹12500',
    amenities: ['WiFi', 'Pool', 'Gym', 'Spa', 'Restaurant'],
    imageUrl: 'https://images.unsplash.com/photo-1596436889106-be35e843f974',
  ),
  Hotel(
    id: '11',
    name: 'The Lalit',
    city: 'Delhi',
    address: 'Barakhamba Rd, Connaught Place',
    rating: 4.4,
    reviews: 1400,
    pricePerNight: '₹8500',
    amenities: ['WiFi', 'Restaurant', 'Bar', 'Parking'],
    imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2',
  ),
  Hotel(
    id: '12',
    name: 'Shangri-La Eros',
    city: 'Delhi',
    address: 'Ashoka Rd, Connaught Place',
    rating: 4.6,
    reviews: 1800,
    pricePerNight: '₹11500',
    amenities: ['WiFi', 'Pool', 'Spa', 'Gym'],
    imageUrl: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b',
  ),
  // Bangalore hotels
  Hotel(
    id: '13',
    name: 'Ritz Carlton',
    city: 'Bangalore',
    address: 'Residency Rd',
    rating: 4.9,
    reviews: 2000,
    pricePerNight: '₹16000.0',
    amenities: ['WiFi', 'Spa', 'Bar', 'Restaurant', 'Gym'],
    imageUrl: 'https://images.unsplash.com/photo-1578683012567-0085b2b7d7e4',
  ),
  Hotel(
    id: '14',
    name: 'Taj West End',
    city: 'Bangalore',
    address: 'Race Course Rd',
    rating: 4.7,
    reviews: 1700,
    pricePerNight: '₹11500',
    amenities: ['WiFi', 'Pool', 'Garden', 'Restaurant'],
    imageUrl: 'https://images.unsplash.com/photo-1445019980597-56d615e416d6',
  ),
  Hotel(
    id: '15',
    name: 'The Leela Palace',
    city: 'Bangalore',
    address: 'HAL Airport Rd',
    rating: 4.8,
    reviews: 1900,
    pricePerNight: '₹14000.0',
    amenities: ['WiFi', 'Pool', 'Spa', 'Gym'],
    imageUrl: 'https://images.unsplash.com/photo-1561501900-3701fa6a086f',
  ),
  // Jaipur hotels
  Hotel(
    id: '16',
    name: 'Rambagh Palace',
    city: 'Jaipur',
    address: 'Bhawani Singh Rd',
    rating: 4.8,
    reviews: 2500,
    pricePerNight: '₹18000.0',
    amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant', 'Garden'],
    imageUrl: 'https://images.unsplash.com/photo-1584132967334-10e028bd69f7',
  ),
  Hotel(
    id: '17',
    name: 'Oberoi Rajvilas',
    city: 'Jaipur',
    address: 'Goner Rd',
    rating: 4.9,
    reviews: 2200,
    pricePerNight: '₹2000.00',
    amenities: ['WiFi', 'Garden', 'Spa', 'Pool', 'Restaurant'],
    imageUrl: 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9',
  ),
  Hotel(
    id: '18',
    name: 'Fairmont Jaipur',
    city: 'Jaipur',
    address: 'RIICO Industrial Area',
    rating: 4.7,
    reviews: 1800,
    pricePerNight: '₹15000.0',
    amenities: ['WiFi', 'Pool', 'Spa', 'Gym'],
    imageUrl: 'https://images.unsplash.com/photo-1564507592333-cbc4d80de2c0',
  ),
  // Hyderabad hotels
  Hotel(
    id: '19',
    name: 'Taj Krishna',
    city: 'Hyderabad',
    address: 'Banjara Hills',
    rating: 4.7,
    reviews: 2000,
    pricePerNight: '₹12000.0',
    amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant', 'Gym'],
    imageUrl: 'https://images.unsplash.com/photo-1596394519084-2b8b34085e47',
  ),
  Hotel(
    id: '20',
    name: 'Novotel Hyderabad',
    city: 'Hyderabad',
    address: 'Hitech City',
    rating: 4.5,
    reviews: 1600,
    pricePerNight: '₹9000.0',
    amenities: ['WiFi', 'Pool', 'Restaurant', 'Parking'],
    imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
  ),
  // Chennai hotels
  Hotel(
    id: '21',
    name: 'Taj Coromandel',
    city: 'Chennai',
    address: 'Nungambakkam',
    rating: 4.6,
    reviews: 1800,
    pricePerNight: '₹11000.0',
    amenities: ['WiFi', 'Spa', 'Restaurant', 'Gym'],
    imageUrl: 'https://images.unsplash.com/photo-1611892440504-42a792e24d3f',
  ),
  Hotel(
    id: '22',
    name: 'ITC Grand Chola',
    city: 'Chennai',
    address: 'Guindy',
    rating: 4.8,
    reviews: 2200,
    pricePerNight: '₹14000.0',
    amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant', 'Gym'],
    imageUrl: 'https://images.unsplash.com/photo-1542314831-8f72cc1d260b',
  ),
  // Kolkata hotels
  Hotel(
    id: '23',
    name: 'The Oberoi Grand',
    city: 'Kolkata',
    address: 'Chowringhee Rd',
    rating: 4.7,
    reviews: 1900,
    pricePerNight: '₹13000.0',
    amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant'],
    imageUrl: 'https://images.unsplash.com/photo-1596436889106-be35e843f974',
  ),
  Hotel(
    id: '24',
    name: 'Taj Bengal',
    city: 'Kolkata',
    address: 'Alipore',
    rating: 4.6,
    reviews: 1700,
    pricePerNight: '₹12000.0',
    amenities: ['WiFi', 'Pool', 'Restaurant', 'Gym'],
    imageUrl: 'https://images.unsplash.com/photo-1582719478250-c89a1e4b85b',
  ),
];

// Static room data
final List<Room> _rooms = [
  // Taj Mahal Palace (Mumbai)
  Room(
    id: '1',
    hotelId: '1',
    type: 'Standard Room',
    price: 12000.0,
    features: ['Queen Bed', 'City View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1444201983204-c5186a2c0ee6',
  ),
  Room(
    id: '2',
    hotelId: '1',
    type: 'Deluxe Room',
    price: 15000.0,
    features: ['King Bed', 'Sea View', 'WiFi', 'Room Service'],
    imageUrl: 'https://images.unsplash.com/photo-1618773928121-c32242e63f39',
  ),
  Room(
    id: '3',
    hotelId: '1',
    type: 'Suite',
    price: 20000.00,
    features: ['King Bed', 'Balcony', 'WiFi', 'Minibar', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1573045731011-c8de6b468750',
  ),
  // The Oberoi (Mumbai)
  Room(
    id: '4',
    hotelId: '2',
    type: 'Executive Room',
    price: 15000.0,
    features: ['Queen Bed', 'City View', 'WiFi', 'Work Desk'],
    imageUrl: 'https://images.unsplash.com/photo-1590490360182-c33d57733427',
  ),
  Room(
    id: '5',
    hotelId: '2',
    type: 'Presidential Suite',
    price: 25000.0,
    features: ['King Bed', 'Jacuzzi', 'WiFi', 'Living Area', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1618221710808-1c93a3e7b66c',
  ),
  // Leela Palace (Delhi)
  Room(
    id: '6',
    hotelId: '3',
    type: 'Deluxe Room',
    price: 14000.0,
    features: ['King Bed', 'Garden View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1585829365295-ab7cd400c227',
  ),
  Room(
    id: '7',
    hotelId: '3',
    type: 'Suite',
    price: 22000.0,
    features: ['King Bed', 'Balcony', 'WiFi', 'Minibar'],
    imageUrl: 'https://images.unsplash.com/photo-1591088398332-8a5d0d84c0d3',
  ),
  // JW Marriott (Mumbai)
  Room(
    id: '8',
    hotelId: '4',
    type: 'Standard Room',
    price: 11000.0,
    features: ['Queen Bed', 'City View', 'WiFi'],
    imageUrl: 'https://images.unsplash.com/photo-1590490359688-94155a1d0f0b',
  ),
  Room(
    id: '9',
    hotelId: '4',
    type: 'Deluxe Room',
    price: 135000,
    features: ['King Bed', 'Sea View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1611892440504-42a792e24d3f',
  ),
  // Trident (Mumbai)
  Room(
    id: '10',
    hotelId: '5',
    type: 'Standard Room',
    price: 9000.0,
    features: ['Queen Bed', 'WiFi', 'Work Desk'],
    imageUrl: 'https://images.unsplash.com/photo-1590490360182-c33d577334c7',
  ),
  Room(
    id: '11',
    hotelId: '5',
    type: 'Family Room',
    price: 14000.0,
    features: ['Two Beds', 'WiFi', 'Breakfast', 'Extra Space'],
    imageUrl: 'https://images.unsplash.com/photo-1578683012567-01a5b2b7d7e4',
  ),
  // Sofitel BKC (Mumbai)
  Room(
    id: '12',
    hotelId: '6',
    type: 'Deluxe Room',
    price: 9500,
    features: ['King Bed', 'WiFi', 'City View'],
    imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
  ),
  // Grand Hyatt (Goa)
  Room(
    id: '13',
    hotelId: '7',
    type: 'Standard Room',
    price: 13000.0,
    features: ['Queen Bed', 'Beach View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1596394519084-2d8b34085e47',
  ),
  Room(
    id: '14',
    hotelId: '7',
    type: 'Suite',
    price: 20000.0,
    features: ['King Bed', 'Balcony', 'WiFi', 'Minibar'],
    imageUrl: 'https://images.unsplash.com/photo-1561501900-3701fa6-a086f0',
  ),
  // Alila Diwa (Goa)
  Room(
    id: '15',
    hotelId: '8',
    type: 'Deluxe Room',
    price: 10000.00,
    features: ['King Bed', 'Garden View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1596436889106-be35e843f974',
  ),
  // Zuri White Sands (Goa)
  Room(
    id: '16',
    hotelId: '9',
    type: 'Standard Room',
    price: 11000.0,
    features: ['Queen Bed', 'Beach View', 'WiFi'],
    imageUrl: 'https://images.unsplash.com/photo-1582719478250-c89a-c1e4b85b',
  ),
  // ITC Maurya (Delhi)
  Room(
    id: '17',
    hotelId: '10',
    type: 'Deluxe Room',
    price: 13000.0,
    features: ['King Bed', 'City View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1444201983204-b5186ac2c0e6',
  ),
  // The Lalit (Delhi)
  Room(
    id: '18',
    hotelId: '11',
    type: 'Standard Room',
    price: 8500,
    features: ['Queen Bed', 'WiFi', 'Work Desk'],
    imageUrl: 'https://images.unsplash.com/photo-1618773928121-c32242e63f39',
  ),
  // Shangri-La Eros (Delhi)
  Room(
    id: '19',
    hotelId: '12',
    type: 'Deluxe Room',
    price: 11500,
    features: ['King Bed', 'City View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1573045731011-abc8f4680750',
  ),
  // Ritz Carlton (Bangalore)
  Room(
    id: '20',
    hotelId: '13',
    type: 'Executive Room',
    price: 16000.0,
    features: ['King Bed', 'City View', 'WiFi', 'Minibar'],
    imageUrl: 'https://images.unsplash.com/photo-1590490360182-c33d57733427',
  ),
  // Taj West End (Bangalore)
  Room(
    id: '21',
    hotelId: '14',
    type: 'Deluxe Room',
    price: 11500,
    features: ['Queen Bed', 'Garden View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1618221710808-1c293a3e7b66c',
  ),
  // The Leela Palace (Bangalore)
  Room(
    id: '22',
    hotelId: '15',
    type: 'Suite',
    price: 14000.0,
    features: ['King Bed', 'Balcony', 'WiFi', 'Minibar'],
    imageUrl: 'https://images.unsplash.com/photo-1585829365295-ab7cd400c227',
  ),
  // Rambagh Palace (Jaipur)
  Room(
    id: '23',
    hotelId: '16',
    type: 'Deluxe Room',
    price: 18000.0,
    features: ['King Bed', 'Garden View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1591088398332-8a5d0d84c0d3',
  ),
  // Oberoi Rajvilas (Jaipur)
  Room(
    id: '24',
    hotelId: '17',
    type: 'Suite',
    price: 20000.0,
    features: ['King Bed', 'Private Garden', 'WiFi', 'Minibar'],
    imageUrl: 'https://images.unsplash.com/photo-1590490359688-94155a1d0f0b',
  ),
  // Fairmont Jaipur (Jaipur)
  Room(
    id: '25',
    hotelId: '18',
    type: 'Standard Room',
    price: 15000.0,
    features: ['Queen Bed', 'City View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1611892440504-42a792e24d3f',
  ),
  // Taj Krishna (Hyderabad)
  Room(
    id: '26',
    hotelId: '19',
    type: 'Deluxe Room',
    price: 12000.0,
    features: ['King Bed', 'City View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1578683012567-01a5b2b7d7e4',
  ),
  // Novotel Hyderabad (Hyderabad)
  Room(
    id: '27',
    hotelId: '20',
    type: 'Standard Room',
    price: 9000.0,
    features: ['Queen Bed', 'WiFi', 'Work Desk'],
    imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
  ),
  // Taj Coromandel (Chennai)
  Room(
    id: '28',
    hotelId: '21',
    type: 'Deluxe Room',
    price: 11000.0,
    features: ['King Bed', 'City View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1596394519084-2d8b34085e47',
  ),
  // ITC Grand Chola (Chennai)
  Room(
    id: '29',
    hotelId: '22',
    type: 'Suite',
    price: 14000.0,
    features: ['King Bed', 'Balcony', 'WiFi', 'Minibar'],
    imageUrl: 'https://images.unsplash.com/photo-1542314831-8f72cc1d260b',
  ),
  // The Oberoi Grand (Kolkata)
  Room(
    id: '30',
    hotelId: '23',
    type: 'Deluxe Room',
    price: 13000.0,
    features: ['King Bed', 'City View', 'WiFi', 'Breakfast'],
    imageUrl: 'https://images.unsplash.com/photo-1596436889106-be35e843f974',
  ),
  // Taj Bengal (Kolkata)
  Room(
    id: '31',
    hotelId: '24',
    type: 'Standard Room',
    price: 12000.0,
    features: ['Queen Bed', 'WiFi', 'Work Desk'],
    imageUrl: 'https://images.unsplash.com/photo-1582719478250-c89a-c1e4b85b',
  ),
];

// Hotel state notifier
class HotelStateNotifier extends StateNotifier<HotelState> {
  HotelStateNotifier() : super(HotelState(filter: HotelFilter()));

  void setSearch(HotelSearch search) {
    state = state.copyWith(search: search);
  }

  void updateFilter(HotelFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void selectHotel(Hotel hotel) {
    state = state.copyWith(selectedHotel: hotel);
  }

  void selectRoom(Room room) {
    state = state.copyWith(selectedRoom: room);
  }

  void clearSelection() {
    state = state.copyWith(selectedHotel: null, selectedRoom: null);
  }

  List<Hotel> getFilteredHotels() {
    if (state.search == null) return _hotels;
    var hotels =
        _hotels
            .where(
              (hotel) =>
                  hotel.city.toLowerCase() == state.search!.city.toLowerCase(),
            )
            .toList();
    hotels =
        hotels.where((hotel) {
          // Remove currency symbol and parse to double
          double price =
              double.tryParse(
                hotel.pricePerNight.replaceAll(RegExp(r'[^\d.]'), ''),
              ) ??
              0.0;
          return price >= state.filter.minPrice &&
              price <= state.filter.maxPrice &&
              hotel.rating >= state.filter.minRating &&
              (state.filter.amenities.isEmpty ||
                  state.filter.amenities.every(
                    (amenity) => hotel.amenities.contains(amenity),
                  ));
        }).toList();

    switch (state.filter.sortBy) {
      case 'Price: Low to High':
        hotels.sort(
          (a, b) => (double.tryParse(
                    a.pricePerNight.replaceAll(RegExp(r'[^\d.]'), ''),
                  ) ??
                  0.0)
              .compareTo(
                double.tryParse(
                      b.pricePerNight.replaceAll(RegExp(r'[^\d.]'), ''),
                    ) ??
                    0.0,
              ),
        );
        break;
      case 'Price: High to Low':
        hotels.sort(
          (a, b) => (double.tryParse(
                    b.pricePerNight.replaceAll(RegExp(r'[^\d.]'), ''),
                  ) ??
                  0.0)
              .compareTo(
                double.tryParse(
                      a.pricePerNight.replaceAll(RegExp(r'[^\d.]'), ''),
                    ) ??
                    0.0,
              ),
        );
        break;
      case 'Rating: High to Low':
        hotels.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return hotels;
  }

  List<Room> getRoomsForHotel(String hotelId) {
    return _rooms.where((room) => room.hotelId == hotelId).toList();
  }

  List<Hotel> getTopRatedHotels() {
    return _hotels.where((hotel) => hotel.isTopRated).toList();
  }

  List<Hotel> getHotelsByCity(String city) {
    return _hotels
        .where((hotel) => hotel.city.toLowerCase() == city.toLowerCase())
        .toList();
  }

  void clearFilters() {}
}

// Providers
final hotelStateProvider =
    StateNotifierProvider<HotelStateNotifier, HotelState>(
      (ref) => HotelStateNotifier(),
    );
