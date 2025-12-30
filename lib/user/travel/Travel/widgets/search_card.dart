import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/travel/Bus/screens/bus_screen.dart';
import 'package:hrtc/user/travel/Travel/provider/travel_Provider.dart';
import 'package:hrtc/user/travel/Travel/widgets/service_tab.dart';
import 'package:hrtc/user/travel/flight/screens/flight_screen.dart';

class SearchCard extends ConsumerWidget {
  const SearchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelState = ref.watch(travelProvider);

    return Container(
      margin: AppSizes.paddingAllMedium,
      padding: AppSizes.paddingAllMedium,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppSizes.radiusMedium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppSizes.elevationMedium,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: AppSizes.tabBarHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: 2,
              itemBuilder: (context, index) {
                return ServiceTab();
              },
            ),
          ),

          SizedBox(height: AppSizes.paddingSmall),

          // Flight-specific UI
          if (travelState.tabIndex == 0) ...[
            _buildFlightTripTypeSelector(ref, travelState),
            SizedBox(height: AppSizes.verticalSpaceSmall),
            _buildFlightLocationFields(ref, travelState),
            SizedBox(height: AppSizes.verticalSpaceSmall),
            _buildFlightDateFields(ref, travelState),
            SizedBox(height: AppSizes.verticalSpaceSmall),
            _buildPassengerClassSelector(ref, travelState),
          ],

          // Bus-specific UI
          if (travelState.tabIndex == 1) ...[
            _buildBusLocationFields(ref, travelState),
            SizedBox(height: AppSizes.verticalSpaceSmall),
            _buildBusDateField(ref, travelState),
          ],

          SizedBox(height: AppSizes.verticalSpaceMedium),

          // Search Button
          _buildSearchButton(context, ref, travelState),
        ],
      ),
    );
  }

  Widget _buildFlightTripTypeSelector(WidgetRef ref, TravelState travelState) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingTiny),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppSizes.radiusSmall,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTripTypeButton(
              ref,
              'One Way',
              TripType.oneWay,
              travelState.tripType == TripType.oneWay,
            ),
          ),
          SizedBox(width: AppSizes.paddingTiny),
          Expanded(
            child: _buildTripTypeButton(
              ref,
              'Round Trip',
              TripType.roundTrip,
              travelState.tripType == TripType.roundTrip,
            ),
          ),
          SizedBox(width: AppSizes.paddingTiny),
          Expanded(
            child: _buildTripTypeButton(
              ref,
              'Multi City',
              TripType.multiCity,
              travelState.tripType == TripType.multiCity,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripTypeButton(
    WidgetRef ref,
    String title,
    TripType type,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => ref.read(travelProvider.notifier).setTripType(type),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingSmall,
          horizontal: AppSizes.paddingTiny,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.travelAccent : Colors.transparent,
          borderRadius: AppSizes.radiusSmall,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppSizes.bodySmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: AppSizes.bodySmallSize * 0.9,
          ),
        ),
      ),
    );
  }

  Widget _buildFlightLocationFields(WidgetRef ref, TravelState travelState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppSizes.radiusMedium,
      ),
      child: Column(
        children: [
          // From Location
          _buildLocationField(
            ref,
            'From',
            travelState.fromLocation,
            Icons.flight_takeoff,
            true,
            (value) => ref.read(travelProvider.notifier).setFromLocation(value),
          ),

          // Swap Button
          Container(
            height: 1,
            color: AppColors.textLight.withOpacity(0.2),
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap:
                      () => ref.read(travelProvider.notifier).swapLocations(),
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.paddingTiny),
                    decoration: const BoxDecoration(
                      color: AppColors.travelAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.swap_vert,
                      color: Colors.white,
                      size: AppSizes.iconSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // To Location
          _buildLocationField(
            ref,
            'To',
            travelState.toLocation,
            Icons.flight_land,
            false,
            (value) => ref.read(travelProvider.notifier).setToLocation(value),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField(
    WidgetRef ref,
    String label,
    String value,
    IconData icon,
    bool isFrom,
    Function(String) onChanged,
  ) {
    return GestureDetector(
      onTap: () => _showLocationPicker(ref, isFrom),
      child: Container(
        padding: AppSizes.paddingAllMedium,
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.travelAccent,
              size: AppSizes.iconMedium,
            ),
            SizedBox(width: AppSizes.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppSizes.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: AppSizes.bodySmallSize * 0.9,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingTiny / 2),
                  Text(
                    value.isNotEmpty ? value : 'Select $label',
                    style: AppSizes.bodyMedium.copyWith(
                      color:
                          value.isNotEmpty
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                      fontWeight:
                          value.isNotEmpty
                              ? FontWeight.w600
                              : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
              size: AppSizes.iconSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightDateFields(WidgetRef ref, TravelState travelState) {
    return Row(
      children: [
        Expanded(
          child: _buildDateField(
            ref,
            'Departure',
            travelState.departureDate,
            Icons.calendar_today,
            () => _showDatePicker(ref, true),
          ),
        ),
        if (travelState.tripType == TripType.roundTrip) ...[
          SizedBox(width: AppSizes.paddingSmall),
          Expanded(
            child: _buildDateField(
              ref,
              'Return',
              travelState.returnDate,
              Icons.calendar_today,
              () => _showDatePicker(ref, false),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBusLocationFields(WidgetRef ref, TravelState travelState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppSizes.radiusMedium,
      ),
      child: Column(
        children: [
          // From Location
          _buildLocationField(
            ref,
            'From',
            travelState.fromLocation,
            Icons.directions_bus,
            true,
            (value) => ref.read(travelProvider.notifier).setFromLocation(value),
          ),

          // Swap Button
          Container(
            height: 1,
            color: AppColors.textLight.withOpacity(0.2),
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap:
                      () => ref.read(travelProvider.notifier).swapLocations(),
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.paddingTiny),
                    decoration: const BoxDecoration(
                      color: AppColors.travelAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.swap_vert,
                      color: Colors.white,
                      size: AppSizes.iconSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // To Location
          _buildLocationField(
            ref,
            'To',
            travelState.toLocation,
            Icons.location_on,
            false,
            (value) => ref.read(travelProvider.notifier).setToLocation(value),
          ),
        ],
      ),
    );
  }

  Widget _buildBusDateField(WidgetRef ref, TravelState travelState) {
    return _buildDateField(
      ref,
      'Journey Date',
      travelState.departureDate,
      Icons.calendar_today,
      () => _showDatePicker(ref, true),
    );
  }

  Widget _buildDateField(
    WidgetRef ref,
    String label,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSizes.paddingAllMedium,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppSizes.radiusMedium,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.travelAccent,
              size: AppSizes.iconMedium,
            ),
            SizedBox(width: AppSizes.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppSizes.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: AppSizes.bodySmallSize * 0.9,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingTiny / 2),
                  Text(
                    value.isNotEmpty ? value : 'Select date',
                    style: AppSizes.bodyMedium.copyWith(
                      color:
                          value.isNotEmpty
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                      fontWeight:
                          value.isNotEmpty
                              ? FontWeight.w600
                              : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
              size: AppSizes.iconSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerClassSelector(WidgetRef ref, TravelState travelState) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _showPassengerSelector(ref),
            child: Container(
              padding: AppSizes.paddingAllMedium,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppSizes.radiusMedium,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: AppColors.travelAccent,
                    size: AppSizes.iconMedium,
                  ),
                  SizedBox(width: AppSizes.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Passengers',
                          style: AppSizes.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: AppSizes.bodySmallSize * 0.9,
                          ),
                        ),
                        SizedBox(height: AppSizes.paddingTiny / 2),
                        Text(
                          travelState.passengerSummary,
                          style: AppSizes.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                    size: AppSizes.iconSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: AppSizes.paddingSmall),
        Expanded(
          child: GestureDetector(
            onTap: () => _showClassSelector(ref),
            child: Container(
              padding: AppSizes.paddingAllMedium,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppSizes.radiusMedium,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.airline_seat_recline_normal,
                    color: AppColors.travelAccent,
                    size: AppSizes.iconMedium,
                  ),
                  SizedBox(width: AppSizes.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Class',
                          style: AppSizes.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: AppSizes.bodySmallSize * 0.9,
                          ),
                        ),
                        SizedBox(height: AppSizes.paddingTiny / 2),
                        Text(
                          travelState.travelClass,
                          style: AppSizes.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                    size: AppSizes.iconSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton(
    BuildContext context,
    WidgetRef ref,
    TravelState travelState,
  ) {
    final isFlightSearch = travelState.tabIndex == 0;
    final buttonColor =
        isFlightSearch ? AppColors.travelAccent : AppColors.travelAccent;

    return ElevatedButton(
      onPressed:
          travelState.canSearch
              ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            isFlightSearch
                                ? const FlightSearchScreen()
                                : const BusSearchScreen(),
                  ),
                );
              }
              : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, AppSizes.buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: AppSizes.radiusMedium),
        elevation: travelState.canSearch ? 4 : 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFlightSearch ? Icons.search : Icons.search,
            size: AppSizes.iconMedium,
          ),
          SizedBox(width: AppSizes.paddingSmall),
          Text(
            'Search ${isFlightSearch ? 'Flights' : 'Buses'}',
            style: AppSizes.bodyLarge.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ).animate().shimmer(delay: 3.seconds, duration: 1.seconds);
  }

  void _showLocationPicker(WidgetRef ref, bool isFrom) {
    // Show location picker modal
    // This would typically show a list of popular cities or airports
    // For now, we'll use a simple dialog
    showModalBottomSheet(
      context: ref.context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationPickerModal(isFrom: isFrom),
    );
  }

  void _showDatePicker(WidgetRef ref, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: ref.context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.travelAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = ref
          .read(travelProvider.notifier)
          .formatDate(picked);
      if (isDeparture) {
        ref.read(travelProvider.notifier).setDepartureDate(formattedDate);
      } else {
        ref.read(travelProvider.notifier).setReturnDate(formattedDate);
      }
    }
  }

  void _showPassengerSelector(WidgetRef ref) {
    showModalBottomSheet(
      context: ref.context,
      backgroundColor: Colors.transparent,
      builder: (context) => const _PassengerSelectorModal(),
    );
  }

  void _showClassSelector(WidgetRef ref) {
    showModalBottomSheet(
      context: ref.context,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ClassSelectorModal(),
    );
  }
}

class _LocationPickerModal extends ConsumerWidget {
  final bool isFrom;

  const _LocationPickerModal({required this.isFrom});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularCities = [
      {
        'name': 'Mumbai',
        'code': 'BOM',
        'airport': 'Chhatrapati Shivaji Maharaj International Airport',
      },
      {
        'name': 'Delhi',
        'code': 'DEL',
        'airport': 'Indira Gandhi International Airport',
      },
      {
        'name': 'Bangalore',
        'code': 'BLR',
        'airport': 'Kempegowda International Airport',
      },
      {
        'name': 'Chennai',
        'code': 'MAA',
        'airport': 'Chennai International Airport',
      },
      {
        'name': 'Kolkata',
        'code': 'CCU',
        'airport': 'Netaji Subhas Chandra Bose International Airport',
      },
      {
        'name': 'Hyderabad',
        'code': 'HYD',
        'airport': 'Rajiv Gandhi International Airport',
      },
      {'name': 'Pune', 'code': 'PNQ', 'airport': 'Pune Airport'},
      {
        'name': 'Ahmedabad',
        'code': 'AMD',
        'airport': 'Sardar Vallabhbhai Patel International Airport',
      },
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Column(
            children: [
              Container(
                padding: AppSizes.paddingAllMedium,
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(height: AppSizes.verticalSpaceMedium),
                    Text(
                      'Select ${isFrom ? 'Departure' : 'Destination'} City',
                      style: AppSizes.headingSmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: popularCities.length,
                  itemBuilder: (context, index) {
                    final city = popularCities[index];
                    return ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(AppSizes.paddingSmall),
                        decoration: BoxDecoration(
                          color: AppColors.travelAccent.withOpacity(0.1),
                          borderRadius: AppSizes.radiusSmall,
                        ),
                        child: Text(
                          city['code']!,
                          style: AppSizes.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.travelAccent,
                          ),
                        ),
                      ),
                      title: Text(city['name']!, style: AppSizes.bodyMedium),
                      subtitle: Text(
                        city['airport']!,
                        style: AppSizes.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      onTap: () {
                        if (isFrom) {
                          ref
                              .read(travelProvider.notifier)
                              .setFromLocation(city['name']!);
                        } else {
                          ref
                              .read(travelProvider.notifier)
                              .setToLocation(city['name']!);
                        }
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PassengerSelectorModal extends ConsumerWidget {
  const _PassengerSelectorModal();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelState = ref.watch(travelProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: AppSizes.paddingAllMedium,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: AppSizes.verticalSpaceMedium),
          Text('Select Passengers', style: AppSizes.headingSmall),
          SizedBox(height: AppSizes.verticalSpaceMedium),

          _buildPassengerCounter(ref, 'Adults', travelState.adults, 'adults'),
          _buildPassengerCounter(
            ref,
            'Children',
            travelState.children,
            'children',
          ),
          _buildPassengerCounter(
            ref,
            'Infants',
            travelState.infants,
            'infants',
          ),

          SizedBox(height: AppSizes.verticalSpaceMedium),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.travelAccent,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, AppSizes.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: AppSizes.radiusMedium,
              ),
            ),
            child: Text('Done', style: AppSizes.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerCounter(
    WidgetRef ref,
    String title,
    int count,
    String type,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.verticalSpaceSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppSizes.bodyMedium),
          Row(
            children: [
              IconButton(
                onPressed:
                    count > (type == 'adults' ? 1 : 0)
                        ? () {
                          ref
                              .read(travelProvider.notifier)
                              .updatePassengerCount(type, count - 1);
                        }
                        : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color:
                      count > (type == 'adults' ? 1 : 0)
                          ? AppColors.travelAccent
                          : Colors.grey,
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: AppSizes.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed:
                    count < 9
                        ? () {
                          ref
                              .read(travelProvider.notifier)
                              .updatePassengerCount(type, count + 1);
                        }
                        : null,
                icon: Icon(
                  Icons.add_circle_outline,
                  color: count < 9 ? AppColors.travelAccent : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClassSelectorModal extends ConsumerWidget {
  const _ClassSelectorModal();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelState = ref.watch(travelProvider);
    final classes = ['Economy', 'Premium Economy', 'Business', 'First Class'];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: AppSizes.paddingAllMedium,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: AppSizes.verticalSpaceMedium),
          Text('Select Class', style: AppSizes.headingSmall),
          SizedBox(height: AppSizes.verticalSpaceMedium),

          ...classes
              .map(
                (className) => ListTile(
                  title: Text(className, style: AppSizes.bodyMedium),
                  trailing:
                      travelState.travelClass == className
                          ? const Icon(
                            Icons.check,
                            color: AppColors.travelAccent,
                          )
                          : null,
                  onTap: () {
                    ref.read(travelProvider.notifier).setTravelClass(className);
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
