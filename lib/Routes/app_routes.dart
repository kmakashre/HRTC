import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrtc/presentations/screens/spalsh_screen.dart';
import 'package:hrtc/user/hotels/screens/hotels_derails.dart';

import '../presentations/screens/onboarding.dart';
import '../user/home/screens/home.dart';
import '../user/hrtc/screens/hrtc.dart';
import '../user/hotels/screens/hotels.dart';
import '../user/hotels/screens/searched_hotels.dart';

import '../user/hotels/screens/room_selection.dart';
import '../user/hotels/screens/booking_confirmation.dart';
import '../user/restaurents/screens/restaurent.dart';
import '../user/travel/Bus/screens/bus_screen.dart';
import '../user/travel/Travel/screens/travel.dart';
import '../user/cabs/screens/cabs.dart';
import '../user/brijguid/screens/brajdarshan.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  errorBuilder:
      (context, state) => Scaffold(
        body: Center(
          child: Text('Error: Route ${state.uri.toString()} not found'),
        ),
      ),
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/hrtc',
      name: 'hrtc',
      builder: (context, state) => const HRTCScreen(),
    ),
    GoRoute(
      path: '/hotels',
      name: 'hotels',
      builder: (context, state) => const HotelsScreen(),
    ),
    GoRoute(
      path: '/hotels/search',
      name: 'searched_hotels',
      builder: (context, state) => const SearchedHotelsScreen(),
    ),
    GoRoute(
      path: '/hotels/details',
      name: 'hotel_details',
      builder: (context, state) => const HotelDetailsScreen(),
    ),
    GoRoute(
      path: '/hotels/rooms',
      name: 'room_selection',
      builder: (context, state) => const RoomSelectionScreen(),
    ),
    GoRoute(
      path: '/hotels/booking',
      name: 'booking_confirmation',
      builder: (context, state) => const BookingConfirmationScreen(),
    ),
    GoRoute(
      path: '/Bus',
      name: 'Bus',
      builder: (context, state) => const BusSearchScreen(),
    ),
    GoRoute(
      path: '/travel',
      name: 'travel',
      builder: (context, state) => const TravelScreen(),
    ),
    GoRoute(
      path: '/cabs',
      name: 'cabs',
      builder: (context, state) => const CabBookingScreen(),
    ),
    // GoRoute(
    //   path: '/bridgeguide',
    //   name: 'bridgeguide',
    //   builder: (context, state) => const BrajDarshanScreen(),
    // ),
  ],
);
