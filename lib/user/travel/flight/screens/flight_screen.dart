import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/travel/Travel/provider/travel_Provider.dart';
import 'package:hrtc/user/travel/flight/provider/flight_provider.dart';
import 'package:hrtc/user/travel/flight/screens/seatselction.dart';
import 'package:hrtc/user/travel/flight/widgets/flight_card.dart';

class FlightSearchScreen extends ConsumerStatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  ConsumerState<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends ConsumerState<FlightSearchScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final travelState = ref.watch(travelProvider);
    final flights = ref.watch(filteredFlightsProvider);
    final stats = ref.watch(flightStatsProvider);
    final filters = ref.watch(flightFiltersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(travelState),
          SliverToBoxAdapter(child: _buildQuickStatsAndFilters(stats, ref)),
          if (_showFilters)
            SliverToBoxAdapter(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: _buildFilterPanel(ref),
              ),
            ),
          SliverToBoxAdapter(child: _buildSortOptions(ref, filters)),
          SliverToBoxAdapter(child: _buildFlightResults(flights, travelState)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(TravelState travelState) {
    return SliverAppBar(
      expandedHeight: 220,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.travelAccent,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '${travelState.fromLocation} → ${travelState.toLocation}',
          style: AppSizes.headingSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.travelAccent,
                AppColors.travelAccent.withOpacity(0.8),
                AppColors.travelAccent.withGreen(150),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 60,
                right: 20,
                child: Icon(
                  Icons.airplanemode_active,
                  size: 80,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      travelState.formattedDateRange,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        travelState.passengerSummary,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsAndFilters(Map<String, dynamic> stats, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatCard(
                  'Best Price',
                  stats.isNotEmpty
                      ? '₹${stats['minPrice']?.toStringAsFixed(0) ?? 'N/A'}'
                      : 'N/A',
                  Icons.currency_rupee,
                  AppColors.travelAccent,
                ),
                const VerticalDivider(
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.grey,
                ),
                _buildStatCard(
                  'Fastest',
                  stats.isNotEmpty ? '${stats['minDuration'] ?? 0}m' : 'N/A',
                  Icons.schedule,
                  AppColors.travelAccent,
                ),
                const VerticalDivider(
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.grey,
                ),
                _buildStatCard(
                  'Airlines',
                  stats.isNotEmpty
                      ? '${stats['airlines']?.length ?? 0}'
                      : 'N/A',
                  Icons.airlines,
                  AppColors.travelAccent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
              icon: Icon(
                _showFilters ? Icons.expand_less : Icons.filter_alt,
                size: 20,
              ),
              label: Text(
                _showFilters ? 'Hide Filters' : 'Filter Flights',
                style: const TextStyle(fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.travelAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(WidgetRef ref) {
    final filters = ref.watch(flightFiltersProvider);
    final stats = ref.watch(flightStatsProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterSection(
            'Price Range',
            Column(
              children: [
                RangeSlider(
                  values:
                      filters.priceRange ??
                      RangeValues(
                        stats.isNotEmpty
                            ? stats['minPrice']?.toDouble() ?? 0
                            : 0,
                        stats.isNotEmpty
                            ? stats['maxPrice']?.toDouble() ?? 20000
                            : 20000,
                      ),
                  min:
                      stats.isNotEmpty ? stats['minPrice']?.toDouble() ?? 0 : 0,
                  max:
                      stats.isNotEmpty
                          ? stats['maxPrice']?.toDouble() ?? 20000
                          : 20000,
                  divisions: 20,
                  activeColor: AppColors.travelAccent,
                  inactiveColor: AppColors.travelAccent.withOpacity(0.2),
                  labels: RangeLabels(
                    '₹${filters.priceRange?.start.round() ?? (stats.isNotEmpty ? stats['minPrice']?.round() ?? 0 : 0)}',
                    '₹${filters.priceRange?.end.round() ?? (stats.isNotEmpty ? stats['maxPrice']?.round() ?? 20000 : 20000)}',
                  ),
                  onChanged: (values) {
                    ref
                        .read(flightFiltersProvider.notifier)
                        .updateFilters(filters.copyWith(priceRange: values));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Min: ₹${stats.isNotEmpty ? stats['minPrice']?.round() ?? 0 : 0}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      'Max: ₹${stats.isNotEmpty ? stats['maxPrice']?.round() ?? 20000 : 20000}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildFilterSection(
            'Airlines',
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  ((stats.isNotEmpty
                              ? stats['airlines'] as List<String>?
                              : []) ??
                          [])
                      .map((airline) {
                        final isSelected = filters.selectedAirlines.contains(
                          airline,
                        );
                        return FilterChip(
                          label: Text(
                            airline,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.grey[800],
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            final newAirlines = List<String>.from(
                              filters.selectedAirlines,
                            );
                            if (selected) {
                              newAirlines.add(airline);
                            } else {
                              newAirlines.remove(airline);
                            }
                            ref
                                .read(flightFiltersProvider.notifier)
                                .updateFilters(
                                  filters.copyWith(
                                    selectedAirlines: newAirlines,
                                  ),
                                );
                          },
                          backgroundColor: Colors.grey[100],
                          selectedColor: AppColors.travelAccent,
                          checkmarkColor: Colors.white,
                          showCheckmark: true,
                        );
                      })
                      .toList(),
            ),
          ),
          const SizedBox(height: 20),
          _buildFilterSection(
            'Flight Type',
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  FlightType.values.map((type) {
                    final isSelected = filters.selectedFlightTypes.contains(
                      type,
                    );
                    return FilterChip(
                      label: Text(
                        _getFlightTypeLabel(type),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[800],
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        final newTypes = List<FlightType>.from(
                          filters.selectedFlightTypes,
                        );
                        if (selected) {
                          newTypes.add(type);
                        } else {
                          newTypes.remove(type);
                        }
                        ref
                            .read(flightFiltersProvider.notifier)
                            .updateFilters(
                              filters.copyWith(selectedFlightTypes: newTypes),
                            );
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: AppColors.travelAccent,
                      checkmarkColor: Colors.white,
                      showCheckmark: true,
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          _buildFilterSection(
            'Amenities',
            Column(
              children: [
                _buildAmenitySwitch(
                  'WiFi',
                  'In-flight internet',
                  Icons.wifi,
                  filters.wifiRequired ?? false,
                  (value) {
                    ref
                        .read(flightFiltersProvider.notifier)
                        .updateFilters(filters.copyWith(wifiRequired: value));
                  },
                ),
                _buildAmenitySwitch(
                  'Meals',
                  'In-flight dining',
                  Icons.restaurant,
                  filters.mealsRequired ?? false,
                  (value) {
                    ref
                        .read(flightFiltersProvider.notifier)
                        .updateFilters(filters.copyWith(mealsRequired: value));
                  },
                ),
                _buildAmenitySwitch(
                  'Refundable',
                  'Flexible tickets',
                  Icons.assignment_return,
                  filters.refundableOnly ?? false,
                  (value) {
                    ref
                        .read(flightFiltersProvider.notifier)
                        .updateFilters(filters.copyWith(refundableOnly: value));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(flightFiltersProvider.notifier).resetFilters();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.travelAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Reset Filters',
                    style: TextStyle(color: AppColors.travelAccent),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFilters = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.travelAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitySwitch(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.travelAccent),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.travelAccent,
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildSortOptions(WidgetRef ref, FlightFilters filters) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSortChip('Price', 'price', filters.sortBy, ref),
            const SizedBox(width: 8),
            _buildSortChip('Duration', 'duration', filters.sortBy, ref),
            const SizedBox(width: 8),
            _buildSortChip('Departure', 'departure', filters.sortBy, ref),
            const SizedBox(width: 8),
            _buildSortChip('Rating', 'rating', filters.sortBy, ref),
            const SizedBox(width: 8),
            _buildSortChip('Popularity', 'popularity', filters.sortBy, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(
    String label,
    String value,
    String currentSort,
    WidgetRef ref,
  ) {
    final isSelected = currentSort == value;
    return GestureDetector(
      onTap: () {
        ref.read(flightFiltersProvider.notifier).updateSortBy(value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.travelAccent : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.travelAccent : Colors.grey[300]!,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFlightResults(List<Flight> flights, TravelState travelState) {
    if (flights.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.airplanemode_active_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No flights found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No flights available for ${travelState.fromLocation} to ${travelState.toLocation}. Try different cities or reset filters.',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(flightFiltersProvider.notifier).resetFilters();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.travelAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset Filters'),
            ),
          ],
        ),
      );
    }

    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: flights.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: FlightCard(
                    flight: flights[index],
                    onBook: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SeatSelectionScreen(flight: flights[index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getFlightTypeLabel(FlightType type) {
    switch (type) {
      case FlightType.direct:
        return 'Direct';
      case FlightType.oneStop:
        return '1 Stop';
      case FlightType.multipleStops:
        return 'Multi Stop';
    }
  }
}
