import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/travel/Bus/provider/bus_provider.dart';
import 'package:hrtc/user/travel/Bus/widgets/book_card.dart';

import 'package:hrtc/user/travel/Travel/provider/travel_Provider.dart';

class BusSearchScreen extends ConsumerWidget {
  const BusSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppSizes.init(context);
    final travelState = ref.watch(travelProvider);
    final buses = ref.watch(filteredBusProvider);
    final filter = ref.watch(busFilterProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buses to ${travelState.toLocation}',
              style: AppSizes.headingSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              '${buses.length} buses found',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: Colors.blue.shade600),
            onPressed: () => _showFilterBottomSheet(context, ref),
          ),
          IconButton(
            icon: Icon(Icons.sort, color: Colors.blue.shade600),
            onPressed: () => _showSortBottomSheet(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          if (_hasActiveFilters(filter))
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _buildFilterChips(context, ref, filter),
              ),
            ),

          // Bus list
          Expanded(
            child:
                // buses.isEmpty
                //     ? _buildEmptyState()
                     AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: buses.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 50,
                              child: FadeInAnimation(
                                child: EnhancedBusCard(bus: buses[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters(BusFilter filter) {
    return filter.minPrice != null ||
        filter.maxPrice != null ||
        filter.minRating != null ||
        filter.isAC != null ||
        filter.isWiFi != null ||
        filter.busType != null;
  }

  List<Widget> _buildFilterChips(
    BuildContext context,
    WidgetRef ref,
    BusFilter filter,
  ) {
    List<Widget> chips = [];

    if (filter.minPrice != null || filter.maxPrice != null) {
      chips.add(
        _buildFilterChip(
          'Price: ₹${filter.minPrice?.toInt() ?? 0} - ₹${filter.maxPrice?.toInt() ?? 2000}',
          () =>
              ref.read(busFilterProvider.notifier).state = filter.copyWith(
                minPrice: null,
                maxPrice: null,
              ),
        ),
      );
    }

    if (filter.minRating != null) {
      chips.add(
        _buildFilterChip(
          'Rating: ${filter.minRating}+',
          () =>
              ref.read(busFilterProvider.notifier).state = filter.copyWith(
                minRating: null,
              ),
        ),
      );
    }

    if (filter.isAC == true) {
      chips.add(
        _buildFilterChip(
          'AC',
          () =>
              ref.read(busFilterProvider.notifier).state = filter.copyWith(
                isAC: null,
              ),
        ),
      );
    }

    if (filter.isWiFi == true) {
      chips.add(
        _buildFilterChip(
          'WiFi',
          () =>
              ref.read(busFilterProvider.notifier).state = filter.copyWith(
                isWiFi: null,
              ),
        ),
      );
    }

    if (filter.busType != null) {
      chips.add(
        _buildFilterChip(
          filter.busType!,
          () =>
              ref.read(busFilterProvider.notifier).state = filter.copyWith(
                busType: null,
              ),
        ),
      );
    }

    return chips;
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onDeleted,
        backgroundColor: Colors.blue.shade50,
        deleteIconColor: Colors.blue.shade600,
      ),
    );
  }

  // Widget _buildEmptyState() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(
  //           Icons.directions_bus_outlined,
  //           size: 80,
  //           color: Colors.grey.shade400,
  //         ),
  //         const SizedBox(height: 16),
  //         Text(
  //           'No buses found',
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.grey.shade600,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           'Try adjusting your filters',
  //           style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showFilterBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheet(),
    );
  }

  void _showSortBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SortBottomSheet(),
    );
  }
}

class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(busFilterProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  ref.read(busFilterProvider.notifier).state = BusFilter();
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Price Range
          const Text(
            'Price Range',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          RangeSlider(
            values: RangeValues(
              filter.minPrice ?? 500,
              filter.maxPrice ?? 1200,
            ),
            min: 500,
            max: 1200,
            divisions: 14,
            labels: RangeLabels(
              '₹${(filter.minPrice ?? 500).toInt()}',
              '₹${(filter.maxPrice ?? 1200).toInt()}',
            ),
            onChanged: (values) {
              ref.read(busFilterProvider.notifier).state = filter.copyWith(
                minPrice: values.start,
                maxPrice: values.end,
              );
            },
          ),

          // Rating
          const Text(
            'Minimum Rating',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Slider(
            value: filter.minRating ?? 3.0,
            min: 3.0,
            max: 5.0,
            divisions: 8,
            label: '${filter.minRating ?? 3.0}',
            onChanged: (value) {
              ref.read(busFilterProvider.notifier).state = filter.copyWith(
                minRating: value,
              );
            },
          ),

          // Amenities
          const Text(
            'Amenities',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          CheckboxListTile(
            title: const Text('AC'),
            value: filter.isAC ?? false,
            onChanged: (value) {
              ref.read(busFilterProvider.notifier).state = filter.copyWith(
                isAC: value,
              );
            },
          ),
          CheckboxListTile(
            title: const Text('WiFi'),
            value: filter.isWiFi ?? false,
            onChanged: (value) {
              ref.read(busFilterProvider.notifier).state = filter.copyWith(
                isWiFi: value,
              );
            },
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SortBottomSheet extends ConsumerWidget {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(busFilterProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sort By',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          RadioListTile<String>(
            title: const Text('Price (Low to High)'),
            value: 'price',
            groupValue: filter.sortBy,
            onChanged: (value) {
              ref.read(busFilterProvider.notifier).state = filter.copyWith(
                sortBy: value,
              );
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Rating (High to Low)'),
            value: 'rating',
            groupValue: filter.sortBy,
            onChanged: (value) {
              ref.read(busFilterProvider.notifier).state = filter.copyWith(
                sortBy: value,
              );
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Departure Time'),
            value: 'departure',
            groupValue: filter.sortBy,
            onChanged: (value) {
              ref.read(busFilterProvider.notifier).state = filter.copyWith(
                sortBy: value,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
