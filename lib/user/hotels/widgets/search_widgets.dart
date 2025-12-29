import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/user/hotels/provider/hotel_provider.dart';
import 'package:intl/intl.dart';

class SearchWidget extends ConsumerStatefulWidget {
  final Function(HotelSearch) onSearch;

  const SearchWidget({super.key, required this.onSearch});

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _suggestionAnimationController;
  late Animation<double> _suggestionAnimation;

  // Controllers
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _cityFocusNode = FocusNode();
  final ScrollController _suggestionScrollController = ScrollController();

  // State variables
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _adults = 2;
  int _children = 0;
  int _rooms = 1;
  String _selectedCity = '';
  bool _showCitySuggestions = false;
  bool _showGuestSelector = false;
  List<CityData> _filteredCities = [];

  // Enhanced cities data with more information
  final List<CityData> _availableCities = [
    CityData(
      name: 'Mumbai',
      state: 'Maharashtra',
      popularAreas: ['Bandra', 'Juhu', 'Andheri', 'Powai'],
      icon: Icons.business,
      description: 'Financial capital of India',
    ),
    CityData(
      name: 'Delhi',
      state: 'Delhi',
      popularAreas: ['Connaught Place', 'Karol Bagh', 'Paharganj', 'Aerocity'],
      icon: Icons.account_balance,
      description: 'Capital city with rich history',
    ),
    CityData(
      name: 'Goa',
      state: 'Goa',
      popularAreas: ['Baga', 'Calangute', 'Anjuna', 'Palolem'],
      icon: Icons.beach_access,
      description: 'Beach paradise destination',
    ),
    CityData(
      name: 'Bangalore',
      state: 'Karnataka',
      popularAreas: [
        'Koramangala',
        'Indiranagar',
        'Whitefield',
        'Electronic City',
      ],
      icon: Icons.computer,
      description: 'Silicon Valley of India',
    ),
    CityData(
      name: 'Jaipur',
      state: 'Rajasthan',
      popularAreas: ['City Palace', 'Hawa Mahal', 'Amer', 'Johari Bazaar'],
      icon: Icons.castle,
      description: 'Pink City with royal heritage',
    ),
    CityData(
      name: 'Hyderabad',
      state: 'Telangana',
      popularAreas: [
        'Banjara Hills',
        'Jubilee Hills',
        'Secunderabad',
        'Gachibowli',
      ],
      icon: Icons.location_city,
      description: 'City of Nizams and IT hub',
    ),
    CityData(
      name: 'Chennai',
      state: 'Tamil Nadu',
      popularAreas: ['Marina Beach', 'T. Nagar', 'Adyar', 'Mylapore'],
      icon: Icons.waves,
      description: 'Gateway to South India',
    ),
    CityData(
      name: 'Kolkata',
      state: 'West Bengal',
      popularAreas: ['Park Street', 'New Market', 'Salt Lake', 'Howrah'],
      icon: Icons.theater_comedy,
      description: 'Cultural capital of India',
    ),
    CityData(
      name: 'Pune',
      state: 'Maharashtra',
      popularAreas: ['Koregaon Park', 'Hinjewadi', 'Viman Nagar', 'Baner'],
      icon: Icons.school,
      description: 'Oxford of the East',
    ),
    CityData(
      name: 'Ahmedabad',
      state: 'Gujarat',
      popularAreas: ['Sabarmati', 'Vastrapur', 'Maninagar', 'Navrangpura'],
      icon: Icons.business_center,
      description: 'Commercial capital of Gujarat',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _suggestionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _suggestionAnimation = CurvedAnimation(
      parent: _suggestionAnimationController,
      curve: Curves.easeInOut,
    );

    _checkInDate = DateTime.now().add(const Duration(days: 1));
    _checkOutDate = DateTime.now().add(const Duration(days: 2));
    _filteredCities = _availableCities;

    _cityController.addListener(_onCityTextChanged);
    _cityFocusNode.addListener(_onCityFocusChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _suggestionAnimationController.dispose();
    _cityController.dispose();
    _cityFocusNode.dispose();
    _suggestionScrollController.dispose();
    super.dispose();
  }

  void _onCityTextChanged() {
    final query = _cityController.text.toLowerCase();
    setState(() {
      _selectedCity = _cityController.text;
      if (query.isEmpty) {
        _filteredCities =
            _availableCities.take(5).toList(); // Limit to 5 for performance
      } else {
        _filteredCities =
            _availableCities
                .where((city) {
                  return city.name.toLowerCase().contains(query) ||
                      city.state.toLowerCase().contains(query) ||
                      city.popularAreas.any(
                        (area) => area.toLowerCase().contains(query),
                      );
                })
                .take(5)
                .toList();
      }
    });
  }

  void _onCityFocusChanged() {
    if (_cityFocusNode.hasFocus) {
      _showSuggestions();
    }
  }

  void _showSuggestions() {
    setState(() {
      _showCitySuggestions = true;
    });
    _suggestionAnimationController.forward().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          context,
          alignment: 0.5,
          duration: const Duration(milliseconds: 300),
        );
      });
    });
  }

  void _hideSuggestions() {
    _suggestionAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showCitySuggestions = false;
        });
      }
    });
  }

  void _selectCity(CityData city) {
    setState(() {
      _selectedCity = city.name;
      _cityController.text = city.name;
    });
    _cityFocusNode.unfocus();
    _hideSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final screenHeight = AppSizes.screenHeight;

    return GestureDetector(
      onTap: () {
        _cityFocusNode.unfocus();
        _hideSuggestions();
        setState(() {
          _showGuestSelector = false;
        });
      },
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingMedium),

        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.verticalSpaceLarge),
              Expanded(child: _buildSearchForm()),
              SizedBox(height: AppSizes.verticalSpaceSmall),
              _buildSearchButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchForm() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (_showCitySuggestions) {
          // Prevent parent scroll when suggestions are visible
          return true;
        }
        return false;
      },
      child: Stack(
        clipBehavior: Clip.none, // Allow suggestions to overflow
        children: [
          Container(
                padding: EdgeInsets.all(AppSizes.paddingMedium + 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.paddingMedium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCityTextField(),
                      SizedBox(height: AppSizes.verticalSpaceLarge),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateSelector(
                              'Check-in',
                              _checkInDate,
                              true,
                            ),
                          ),
                          SizedBox(width: AppSizes.paddingSmall),
                          Expanded(
                            child: _buildDateSelector(
                              'Check-out',
                              _checkOutDate,
                              false,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.verticalSpaceLarge),
                      _buildGuestRoomSelector(),
                      SizedBox(height: AppSizes.verticalSpaceMedium),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 600.ms)
              .slideY(begin: 0.3, end: 0),
          if (_showCitySuggestions) _buildCitySuggestions(),
        ],
      ),
    );
  }

  Widget _buildCityTextField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color:
              _cityFocusNode.hasFocus
                  ? AppColors.hotelsAccent
                  : Colors.grey[300]!,
          width: _cityFocusNode.hasFocus ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.paddingSmall),
      ),
      child: TextField(
        controller: _cityController,
        focusNode: _cityFocusNode,
        onTap: _showSuggestions,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.location_city,
            color:
                _cityFocusNode.hasFocus
                    ? AppColors.hotelsAccent
                    : Colors.grey[600],
            size: AppSizes.iconMedium,
          ),
          suffixIcon:
              _cityController.text.isNotEmpty
                  ? IconButton(
                    onPressed: () {
                      _cityController.clear();
                      setState(() {
                        _selectedCity = '';
                        _filteredCities = _availableCities.take(5).toList();
                      });
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey[600],
                      size: AppSizes.iconSmall,
                    ),
                  )
                  : Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: AppSizes.iconSmall,
                  ),
          labelText: 'City, hotel, or area',
          labelStyle: AppSizes.bodyMedium.copyWith(
            color:
                _cityFocusNode.hasFocus
                    ? AppColors.hotelsAccent
                    : Colors.grey[600],
            fontSize: AppSizes.bodyMediumSize * 0.85,
          ),
          hintText: 'Where do you want to stay?',
          hintStyle: AppSizes.bodyMedium.copyWith(
            color: Colors.grey[500],
            fontSize: AppSizes.bodyMediumSize * 0.85,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(AppSizes.paddingMedium),
        ),
        style: AppSizes.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: AppSizes.bodyMediumSize * 0.85,
        ),
      ),
    );
  }

  Widget _buildCitySuggestions() {
    const double itemHeight = 60.0;
    const double headerHeight = 40.0;
    const double maxHeight = 220.0;
    final itemCount = _filteredCities.isEmpty ? 1 : _filteredCities.length;
    final calculatedHeight =
        _filteredCities.isEmpty
            ? 150.0
            : (itemCount * itemHeight + headerHeight).clamp(100.0, maxHeight);

    return Positioned(
      left: AppSizes.paddingMedium,
      right: AppSizes.paddingMedium,
      top: 80.0, // Adjust based on _buildCityTextField height
      child: FadeTransition(
        opacity: _suggestionAnimation,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(AppSizes.paddingSmall),
          child: Container(
            padding: EdgeInsets.all(AppSizes.paddingSmall),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.paddingSmall),
              border: Border.all(color: Colors.grey[200]!),
            ),
            height: calculatedHeight,
            child:
                _filteredCities.isNotEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingSmall,
                            vertical: AppSizes.paddingTiny,
                          ),
                          child: Text(
                            _cityController.text.isEmpty
                                ? 'Popular Destinations'
                                : 'Search Results',
                            style: AppSizes.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              fontSize: AppSizes.bodySmallSize * 0.85,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.verticalSpaceTiny),
                        Expanded(
                          child: ListView.builder(
                            controller: _suggestionScrollController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _filteredCities.length,
                            itemBuilder: (context, index) {
                              final city = _filteredCities[index];
                              return _buildCitySuggestionItem(city);
                            },
                          ),
                        ),
                      ],
                    )
                    : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.paddingMedium),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: AppSizes.verticalSpaceSmall),
                            Text(
                              'No cities found',
                              style: AppSizes.bodyMedium.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                                fontSize: AppSizes.bodyMediumSize * 0.85,
                              ),
                            ),
                            SizedBox(height: AppSizes.verticalSpaceTiny),
                            Text(
                              'Try searching for a different city',
                              style: AppSizes.bodySmall.copyWith(
                                color: Colors.grey[500],
                                fontSize: AppSizes.bodySmallSize * 0.85,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildCitySuggestionItem(CityData city) {
    final query = _cityController.text.toLowerCase();

    return InkWell(
      onTap: () => _selectCity(city),
      borderRadius: BorderRadius.circular(AppSizes.paddingSmall),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.hotelsAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(city.icon, color: AppColors.hotelsAccent, size: 20),
            ),
            SizedBox(width: AppSizes.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        city.name,
                        style: AppSizes.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: AppSizes.bodyMediumSize * 0.85,
                        ),
                      ),
                      SizedBox(width: AppSizes.paddingSmall),
                      Text(
                        city.state,
                        style: AppSizes.bodySmall.copyWith(
                          color: Colors.grey[600],
                          fontSize: AppSizes.bodySmallSize * 0.85,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    city.description,
                    style: AppSizes.bodySmall.copyWith(
                      color: Colors.grey[600],
                      fontSize: AppSizes.bodySmallSize * 0.85,
                    ),
                  ),
                  if (query.isNotEmpty &&
                      city.popularAreas.any(
                        (area) => area.toLowerCase().contains(query),
                      )) ...[
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children:
                          city.popularAreas
                              .where(
                                (area) => area.toLowerCase().contains(query),
                              )
                              .take(2)
                              .map(
                                (area) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.hotelsAccent.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    area,
                                    style: AppSizes.bodySmall.copyWith(
                                      color: AppColors.hotelsAccent,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, bool isCheckIn) {
    return GestureDetector(
      onTap: () => _selectDate(isCheckIn),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(AppSizes.paddingSmall),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: AppColors.hotelsAccent,
              size: AppSizes.iconSmall,
            ),
            SizedBox(width: AppSizes.paddingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppSizes.bodySmall.copyWith(
                      color: Colors.grey[600],
                      fontSize: AppSizes.bodySmallSize * 0.85,
                    ),
                  ),
                  Text(
                    date != null
                        ? DateFormat('dd MMM').format(date)
                        : 'Select date',
                    style: AppSizes.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: AppSizes.bodyMediumSize * 0.85,
                    ),
                  ),
                  if (date != null)
                    Text(
                      DateFormat('EEEE').format(date),
                      style: AppSizes.bodySmall.copyWith(
                        color: Colors.grey[500],
                        fontSize: AppSizes.bodySmallSize * 0.85,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestRoomSelector() {
    return GestureDetector(
      onTap: () => setState(() => _showGuestSelector = !_showGuestSelector),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(AppSizes.paddingSmall),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.people,
                  color: AppColors.hotelsAccent,
                  size: AppSizes.iconMedium,
                ),
                SizedBox(width: AppSizes.paddingSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guests & Rooms',
                        style: AppSizes.bodySmall.copyWith(
                          color: Colors.grey[600],
                          fontSize: AppSizes.bodySmallSize * 0.85,
                        ),
                      ),
                      Text(
                        '$_adults Adults${_children > 0 ? ', $_children Children' : ''} • $_rooms Room${_rooms > 1 ? 's' : ''}',
                        style: AppSizes.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: AppSizes.bodyMediumSize * 0.85,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _showGuestSelector
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
          if (_showGuestSelector) ...[
            SizedBox(height: AppSizes.verticalSpaceTiny),
            Container(
              padding: EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(AppSizes.paddingSmall),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildCounterRow(
                    'Adults',
                    'Age 12+',
                    _adults,
                    (value) {
                      setState(() => _adults = value);
                    },
                    1,
                    10,
                  ),
                  SizedBox(height: AppSizes.verticalSpaceSmall),
                  _buildCounterRow(
                    'Children',
                    'Age 0-11',
                    _children,
                    (value) {
                      setState(() => _children = value);
                    },
                    0,
                    6,
                  ),
                  SizedBox(height: AppSizes.verticalSpaceSmall),
                  _buildCounterRow(
                    'Rooms',
                    '',
                    _rooms,
                    (value) {
                      setState(() => _rooms = value);
                    },
                    1,
                    4,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCounterRow(
    String title,
    String subtitle,
    int value,
    Function(int) onChanged,
    int minValue,
    int maxValue,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppSizes.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: AppSizes.bodyMediumSize * 0.85,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: AppSizes.bodySmall.copyWith(
                  color: Colors.grey[600],
                  fontSize: AppSizes.bodySmallSize * 0.85,
                ),
              ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: value > minValue ? () => onChanged(value - 1) : null,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color:
                      value > minValue
                          ? AppColors.hotelsAccent
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.remove,
                  size: 16,
                  color: value > minValue ? Colors.white : Colors.grey[500],
                ),
              ),
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                value.toString(),
                style: AppSizes.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: AppSizes.bodyLargeSize * 0.85,
                ),
              ),
            ),
            GestureDetector(
              onTap: value < maxValue ? () => onChanged(value + 1) : null,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color:
                      value < maxValue
                          ? AppColors.hotelsAccent
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.add,
                  size: 16,
                  color: value < maxValue ? Colors.white : Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _canSearch() ? _performSearch : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.hotelsAccent,
          padding: EdgeInsets.symmetric(vertical: AppSizes.paddingMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.paddingSmall),
          ),
          elevation: 7,
        ),
        child: Text(
          'Search Hotels',
          style: AppSizes.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.bodyLargeSize * 0.9,
          ),
        ),
      ),
    );
  }

  bool _canSearch() {
    return _selectedCity.isNotEmpty &&
        _checkInDate != null &&
        _checkOutDate != null;
  }

  void _performSearch() {
    if (!_canSearch()) return;

    final search = HotelSearch(
      city: _selectedCity,
      checkIn: _checkInDate!,
      checkOut: _checkOutDate!,
      adults: _adults,
      children: _children,
      rooms: _rooms,
    );

    widget.onSearch(search);
  }

  Future<void> _selectDate(bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isCheckIn
              ? (_checkInDate ?? DateTime.now().add(const Duration(days: 1)))
              : (_checkOutDate ?? DateTime.now().add(const Duration(days: 2))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.hotelsAccent,
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
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate != null &&
              _checkOutDate!.isBefore(picked.add(const Duration(days: 1)))) {
            _checkOutDate = picked.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }
}

class CityData {
  final String name;
  final String state;
  final List<String> popularAreas;
  final IconData icon;
  final String description;

  CityData({
    required this.name,
    required this.state,
    required this.popularAreas,
    required this.icon,
    required this.description,
  });
}
