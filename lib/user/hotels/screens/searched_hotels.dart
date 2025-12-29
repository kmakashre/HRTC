import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/user/hotels/provider/hotel_provider.dart';
import 'package:hrtc/user/hotels/widgets/hotel_card.dart';
import 'package:intl/intl.dart';

class SearchedHotelsScreen extends ConsumerStatefulWidget {
  const SearchedHotelsScreen({super.key});

  @override
  ConsumerState<SearchedHotelsScreen> createState() =>
      _SearchedHotelsScreenState();
}

class _SearchedHotelsScreenState extends ConsumerState<SearchedHotelsScreen>
    with TickerProviderStateMixin {
  late AnimationController _filterAnimationController;
  late AnimationController _listAnimationController;
  bool _isFilterVisible = false;

  @override
  void initState() {
    super.initState();
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _filterAnimationController.dispose();
    _listAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final screenWidth = AppSizes.screenWidth;
    final screenHeight = AppSizes.screenHeight;
    final hotelState = ref.watch(hotelStateProvider);
    final hotels = ref.watch(hotelStateProvider.notifier).getFilteredHotels();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(hotelState),
          SliverToBoxAdapter(
            child: _buildSearchHeader(screenWidth, screenHeight, hotels.length),
          ),
          SliverToBoxAdapter(
            child: _buildFilterSection(screenWidth, screenHeight),
          ),
          if (_isFilterVisible)
            SliverToBoxAdapter(
              child: _buildAdvancedFilters(screenWidth, screenHeight),
            ),
          SliverToBoxAdapter(child: _buildViewToggle(hotelState)),
          _buildHotelsList(hotels, screenWidth),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar(hotelState) {
    return SliverAppBar(
      expandedHeight: AppSizes.appBarHeight - 10,
      scrolledUnderElevation: 0,
      floating: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      pinned: true,
      title: Text(
        'Searched Hotels',
        style: TextStyle(
          color: Colors.white,
          fontSize: AppSizes.bodyLargeSize + 5,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.hotelsAccent,
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildSearchHeader(
    double screenWidth,
    double screenHeight,
    int hotelCount,
  ) {
    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMedium),
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSizes.radiusMedium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$hotelCount hotels found',
                  style: AppSizes.headingSmall.copyWith(
                    color: AppColors.hotelsAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Best deals for your stay',
                  style: AppSizes.bodySmall.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.hotelsAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: AppColors.hotelsAccent),
                const SizedBox(width: 4),
                Text(
                  'Verified',
                  style: AppSizes.bodySmall.copyWith(
                    color: AppColors.hotelsAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildFilterSection(double screenWidth, double screenHeight) {
    final filter = ref.watch(hotelStateProvider).filter;
    final activeFiltersCount = _getActiveFiltersCount(filter);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.paddingSmall),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppSizes.radiusMedium,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildEnhancedFilterChip(
                    'Price',
                    _getPriceRangeText(filter),
                    Icons.attach_money,
                    () => _showPriceFilter(screenWidth, screenHeight),
                    isActive: filter.minPrice > 0 || filter.maxPrice < 20000,
                  ),
                  _buildEnhancedFilterChip(
                    'Rating',
                    filter.minRating > 0 ? '${filter.minRating}+ ⭐' : 'Any',
                    Icons.star_border,
                    () => _showRatingFilter(screenWidth, screenHeight),
                    isActive: filter.minRating > 0,
                  ),
                  _buildEnhancedFilterChip(
                    'Amenities',
                    filter.amenities.isEmpty
                        ? 'Any'
                        : '${filter.amenities.length} selected',
                    Icons.local_offer,
                    () => _showAmenitiesFilter(screenWidth, screenHeight),
                    isActive: filter.amenities.isNotEmpty,
                  ),
                  _buildEnhancedFilterChip(
                    'Sort',
                    filter.sortBy,
                    Icons.sort,
                    () => _showSortFilter(screenWidth, screenHeight),
                    isActive: filter.sortBy != 'Popular',
                  ),
                  _buildEnhancedFilterChip(
                    'More',
                    _isFilterVisible ? 'Less' : 'Filters',
                    _isFilterVisible ? Icons.expand_less : Icons.expand_more,
                    () => _toggleAdvancedFilters(),
                    isActive: activeFiltersCount > 0,
                    badge:
                        activeFiltersCount > 0
                            ? activeFiltersCount.toString()
                            : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildEnhancedFilterChip(
    String label,
    String value,
    IconData icon,
    VoidCallback onTap, {
    bool isActive = false,
    String? badge,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall / 2),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(25),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isActive ? AppColors.hotelsAccent : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color:
                        isActive
                            ? AppColors.hotelsAccent
                            : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: isActive ? Colors.white : AppColors.hotelsAccent,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:
                                isActive ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                isActive
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters(double screenWidth, double screenHeight) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSizes.radiusMedium,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Advanced Filters',
                  style: AppSizes.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: AppColors.hotelsAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFilterRow('Property Type', [
              'Hotel',
              'Resort',
              'Apartment',
              'Villa',
            ]),
            const SizedBox(height: 12),
            _buildFilterRow('Distance', ['< 1km', '1-5km', '5-10km', '> 10km']),
            const SizedBox(height: 12),
            _buildFilterRow('Meal Plan', [
              'Room Only',
              'Breakfast',
              'Half Board',
              'Full Board',
            ]),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.3, end: 0);
  }

  Widget _buildFilterRow(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppSizes.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children:
              options.map((option) => _buildSmallFilterChip(option)).toList(),
        ),
      ],
    );
  }

  Widget _buildSmallFilterChip(String label) {
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: false,
      onSelected: (selected) {
        // Handle filter selection
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: AppColors.hotelsAccent.withOpacity(0.2),
      checkmarkColor: AppColors.hotelsAccent,
      side: BorderSide(color: Colors.grey.shade300),
    );
  }

  Widget _buildViewToggle(hotelState) {
    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMedium),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.hotelsAccent),
          Expanded(
            child: Text(
              hotelState.search?.city ?? 'Search Results',
              style: AppSizes.headingSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelsList(List hotels, double screenWidth) {
    if (hotels.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState());
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 12.0),
            child: HotelCard(
                  hotel: hotels[index],
                  width: double.infinity,
                  // Use safe width
                  onTap: () => _navigateToHotelDetails(hotels[index]),
                )
                .animate(delay: (100 * index).ms)
                .fadeIn()
                .slideX(begin: 0.3, end: 0),
          ),
        ),
        childCount: hotels.length,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.all(AppSizes.paddingLarge),
      padding: EdgeInsets.all(AppSizes.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hotel_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hotels found',
            style: AppSizes.headingMedium.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search criteria',
            style: AppSizes.bodyMedium.copyWith(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _clearAllFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.hotelsAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showFilterSummary(),
      backgroundColor: AppColors.hotelsAccent,
      child: const Icon(Icons.tune, color: Colors.white),
    ).animate().scale(delay: 500.ms);
  }

  String _getPriceRangeText(filter) {
    if (filter.minPrice > 0 || filter.maxPrice < 20000) {
      return '₹${filter.minPrice.round()}-₹${filter.maxPrice.round()}';
    }
    return 'Any';
  }

  int _getActiveFiltersCount(filter) {
    int count = 0;
    if (filter.minPrice > 0 || filter.maxPrice < 20000) count++;
    if (filter.minRating > 0) count++;
    if (filter.amenities.isNotEmpty) count++;
    if (filter.sortBy != 'Popular') count++;
    return count;
  }

  void _toggleAdvancedFilters() {
    setState(() {
      _isFilterVisible = !_isFilterVisible;
    });
    if (_isFilterVisible) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }
  }

  void _clearAllFilters() {
    ref.read(hotelStateProvider.notifier).clearFilters();
    setState(() {
      _isFilterVisible = false;
    });
  }

  void _navigateToHotelDetails(hotel) {
    ref.read(hotelStateProvider.notifier).selectHotel(hotel);
    context.push('/hotels/details');
  }

  void _showSearchDialog() {
    // Implement search dialog
  }

  void _showMapView() {
    // Implement map view
  }

  void _showFilterSummary() {
    // Implement filter summary dialog
  }

  void _showPriceFilter(double screenWidth, double screenHeight) {
    double minPrice = ref.read(hotelStateProvider).filter.minPrice;
    double maxPrice = ref.read(hotelStateProvider).filter.maxPrice;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Container(
                  padding: EdgeInsets.all(AppSizes.paddingMedium),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price Range',
                            style: AppSizes.headingMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(AppSizes.paddingMedium),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: AppSizes.radiusMedium,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Min: ₹${minPrice.round()}',
                                  style: AppSizes.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.hotelsAccent,
                                  ),
                                ),
                                Text(
                                  'Max: ₹${maxPrice.round()}',
                                  style: AppSizes.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.hotelsAccent,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            RangeSlider(
                              values: RangeValues(minPrice, maxPrice),
                              min: 0,
                              max: 20000,
                              divisions: 40,
                              activeColor: AppColors.hotelsAccent,
                              inactiveColor: Colors.grey.shade300,
                              labels: RangeLabels(
                                '₹${minPrice.round()}',
                                '₹${maxPrice.round()}',
                              ),
                              onChanged: (values) {
                                setModalState(() {
                                  minPrice = values.start;
                                  maxPrice = values.end;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setModalState(() {
                                  minPrice = 0;
                                  maxPrice = 20000;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.hotelsAccent,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(color: AppColors.hotelsAccent),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(hotelStateProvider.notifier)
                                    .updateFilter(
                                      ref
                                          .read(hotelStateProvider)
                                          .filter
                                          .copyWith(
                                            minPrice: minPrice,
                                            maxPrice: maxPrice,
                                          ),
                                    );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.hotelsAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                minimumSize: Size(
                                  double.infinity,
                                  AppSizes.buttonHeight,
                                ),
                              ),
                              child: Text(
                                'Apply Filter',
                                style: AppSizes.bodyLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
          ),
    );
  }

  void _showAmenitiesFilter(double screenWidth, double screenHeight) {
    final amenities = [
      {'name': 'WiFi', 'icon': Icons.wifi},
      {'name': 'Pool', 'icon': Icons.pool},
      {'name': 'Spa', 'icon': Icons.spa},
      {'name': 'Gym', 'icon': Icons.fitness_center},
      {'name': 'Restaurant', 'icon': Icons.restaurant},
      {'name': 'Bar', 'icon': Icons.local_bar},
      {'name': 'Beach', 'icon': Icons.beach_access},
      {'name': 'Garden', 'icon': Icons.nature},
      {'name': 'Parking', 'icon': Icons.local_parking},
      {'name': 'Pet Friendly', 'icon': Icons.pets},
      {'name': 'Room Service', 'icon': Icons.room_service},
      {'name': 'Laundry', 'icon': Icons.local_laundry_service},
    ];

    List<String> selected = List.from(
      ref.read(hotelStateProvider).filter.amenities,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Container(
                  height: screenHeight * 0.8,
                  padding: EdgeInsets.all(AppSizes.paddingMedium),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amenities',
                            style: AppSizes.headingMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      if (selected.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.hotelsAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${selected.length} amenities selected',
                            style: const TextStyle(
                              color: AppColors.hotelsAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 3,
                              ),
                          itemCount: amenities.length,
                          itemBuilder: (context, index) {
                            final amenity = amenities[index];
                            final isSelected = selected.contains(
                              amenity['name'],
                            );

                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  if (isSelected) {
                                    selected.remove(amenity['name']);
                                  } else {
                                    selected.add(amenity['name'] as String);
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.hotelsAccent
                                          : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? AppColors.hotelsAccent
                                            : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      amenity['icon'] as IconData,
                                      size: 20,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : AppColors.hotelsAccent,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        amenity['name'] as String,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.grey.shade700,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setModalState(() => selected.clear());
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.hotelsAccent,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Clear All',
                                style: TextStyle(color: AppColors.hotelsAccent),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(hotelStateProvider.notifier)
                                    .updateFilter(
                                      ref
                                          .read(hotelStateProvider)
                                          .filter
                                          .copyWith(amenities: selected),
                                    );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.hotelsAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                minimumSize: Size(
                                  double.infinity,
                                  AppSizes.buttonHeight,
                                ),
                              ),
                              child: Text(
                                'Apply (${selected.length})',
                                style: AppSizes.bodyLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
          ),
    );
  }

  void _showSortFilter(double screenWidth, double screenHeight) {
    final sortOptions = [
      {'name': 'Popular', 'icon': Icons.trending_up, 'desc': 'Most booked'},
      {
        'name': 'Price: Low to High',
        'icon': Icons.arrow_upward,
        'desc': 'Budget friendly',
      },
      {
        'name': 'Price: High to Low',
        'icon': Icons.arrow_downward,
        'desc': 'Premium first',
      },
      {'name': 'Rating: High to Low', 'icon': Icons.star, 'desc': 'Best rated'},
      {'name': 'Distance', 'icon': Icons.location_on, 'desc': 'Nearest first'},
      {'name': 'Newest', 'icon': Icons.new_releases, 'desc': 'Recently added'},
    ];

    String selected = ref.read(hotelStateProvider).filter.sortBy;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sort By',
                      style: AppSizes.headingMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...sortOptions.map(
                  (option) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color:
                          selected == option['name']
                              ? AppColors.hotelsAccent.withOpacity(0.1)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            selected == option['name']
                                ? AppColors.hotelsAccent
                                : Colors.grey.shade200,
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              selected == option['name']
                                  ? AppColors.hotelsAccent
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          option['icon'] as IconData,
                          color:
                              selected == option['name']
                                  ? Colors.white
                                  : Colors.grey.shade600,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        option['name'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              selected == option['name']
                                  ? AppColors.hotelsAccent
                                  : Colors.grey.shade800,
                        ),
                      ),
                      subtitle: Text(
                        option['desc'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      trailing:
                          selected == option['name']
                              ? const Icon(
                                Icons.check_circle,
                                color: AppColors.hotelsAccent,
                              )
                              : null,
                      onTap: () {
                        ref
                            .read(hotelStateProvider.notifier)
                            .updateFilter(
                              ref
                                  .read(hotelStateProvider)
                                  .filter
                                  .copyWith(sortBy: option['name'] as String),
                            );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  void _showRatingFilter(double screenWidth, double screenHeight) {
    double minRating = ref.read(hotelStateProvider).filter.minRating;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Container(
                  padding: EdgeInsets.all(AppSizes.paddingMedium),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Minimum Rating',
                            style: AppSizes.headingMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(AppSizes.paddingMedium),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: AppSizes.radiusMedium,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < minRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 32,
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${minRating.toStringAsFixed(1)} stars and above',
                              style: AppSizes.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.hotelsAccent,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Slider(
                              value: minRating,
                              min: 0,
                              max: 5,
                              divisions: 10,
                              activeColor: AppColors.hotelsAccent,
                              inactiveColor: Colors.grey.shade300,
                              onChanged:
                                  (value) =>
                                      setModalState(() => minRating = value),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setModalState(() => minRating = 0);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.hotelsAccent,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(color: AppColors.hotelsAccent),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(hotelStateProvider.notifier)
                                    .updateFilter(
                                      ref
                                          .read(hotelStateProvider)
                                          .filter
                                          .copyWith(minRating: minRating),
                                    );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.hotelsAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                minimumSize: Size(
                                  double.infinity,
                                  AppSizes.buttonHeight,
                                ),
                              ),
                              child: Text(
                                'Apply Filter',
                                style: AppSizes.bodyLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
          ),
    );
  }
}
