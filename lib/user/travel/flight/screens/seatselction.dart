import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/travel/Travel/provider/travel_Provider.dart';
import 'package:hrtc/user/travel/flight/provider/flight_provider.dart';
import 'package:hrtc/user/travel/flight/screens/flight_booking.dart';

enum SeatType { window, middle, aisle, emergency }

enum SeatFilter { all, window, aisle, available, premium }

class SeatSelectionScreen extends ConsumerStatefulWidget {
  final Flight flight;

  const SeatSelectionScreen({super.key, required this.flight});

  @override
  ConsumerState<SeatSelectionScreen> createState() =>
      _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends ConsumerState<SeatSelectionScreen>
    with TickerProviderStateMixin {
  List<String> selectedSeats = [];
  SeatFilter currentFilter = SeatFilter.all;
  bool showFilters = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFilters() {
    setState(() {
      showFilters = !showFilters;
      if (showFilters) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  bool _shouldShowSeat(String seat) {
    switch (currentFilter) {
      case SeatFilter.all:
        return true;
      case SeatFilter.window:
        return seat.endsWith('A') || seat.endsWith('F');
      case SeatFilter.aisle:
        return seat.endsWith('C') || seat.endsWith('D');
      case SeatFilter.available:
        return widget.flight.availableSeats.contains(seat);
      case SeatFilter.premium:
        return int.parse(seat.replaceAll(RegExp(r'[^0-9]'), '')) <= 3;
    }
  }

  SeatType _getSeatType(String seat) {
    if (seat.endsWith('A') || seat.endsWith('F')) return SeatType.window;
    if (seat.endsWith('B') || seat.endsWith('E')) return SeatType.middle;
    if (seat.endsWith('C') || seat.endsWith('D')) return SeatType.aisle;
    return SeatType.aisle;
  }

  bool _isEmergencyExit(String seat) {
    final row = int.parse(seat.replaceAll(RegExp(r'[^0-9]'), ''));
    return row == 12 || row == 13; // Emergency exit rows
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final travelState = ref.watch(travelProvider);
    final maxSeats = travelState.totalPassengers;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.travelAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Seats',
          style: AppSizes.headingSmall.copyWith(
            color: AppColors.travelAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              showFilters ? Icons.filter_list : Icons.filter_list_outlined,
              color: AppColors.travelAccent,
            ),
            onPressed: _toggleFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFlightInfo(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showFilters ? 80 : 0,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(_slideAnimation),
              child: _buildFilterBar(),
            ),
          ),
          _buildLegend(),
          Expanded(child: _buildAircraftLayout(maxSeats)),
          _buildBottomSection(maxSeats),
        ],
      ),
    );
  }

  Widget _buildFlightInfo() {
    return Container(
      margin: AppSizes.paddingAllMedium,
      padding: AppSizes.paddingAllMedium,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.travelAccent.withOpacity(0.1),
            AppColors.travelAccent.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSizes.radiusMedium,
        border: Border.all(color: AppColors.travelAccent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flight, color: AppColors.travelAccent, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${widget.flight.airline} - ${widget.flight.route}',
                  style: AppSizes.headingSmall.copyWith(
                    color: AppColors.travelAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoChip(
                'Class: ${widget.flight.flightClass.toString().split('.').last}',
                Icons.airline_seat_recline_extra,
              ),
              _buildInfoChip(
                'Selected: ${selectedSeats.length}',
                Icons.event_seat,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.travelAccent),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppSizes.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.travelAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              SeatFilter.values.map((filter) {
                final isSelected = currentFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(
                      filter.toString().split('.').last.capitalize(),
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.travelAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selectedColor: AppColors.travelAccent,
                    backgroundColor: Colors.white,
                    checkmarkColor: Colors.white,
                    onSelected: (selected) {
                      setState(() {
                        currentFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem('Available', Colors.white, Colors.grey[400]!),
          _buildLegendItem(
            'Selected',
            AppColors.travelAccent,
            AppColors.travelAccent,
          ),
          _buildLegendItem('Occupied', Colors.grey[300]!, Colors.grey[400]!),
          _buildLegendItem('Premium', Colors.amber[100]!, Colors.amber[400]!),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color fillColor, Color borderColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppSizes.bodySmall.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildAircraftLayout(int maxSeats) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildAircraftNose(),
            ..._buildSeatSections(maxSeats),
            _buildAircraftTail(),
          ],
        ),
      ),
    );
  }

  Widget _buildAircraftNose() {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(100),
          topRight: Radius.circular(100),
        ),
      ),
      child: const Center(
        child: Icon(Icons.flight, color: AppColors.travelAccent, size: 24),
      ),
    );
  }

  Widget _buildAircraftTail() {
    return Container(
      width: 200,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
    );
  }

  List<Widget> _buildSeatSections(int maxSeats) {
    final sections = <Widget>[];

    // Business/First Class (Rows 1-3)
    sections.add(_buildSectionHeader('Business Class', Icons.star));
    sections.addAll(
      _buildSeatRows(1, 3, isBusinessClass: true, maxSeats: maxSeats),
    );

    // Emergency Exit
    sections.add(_buildEmergencyExitRow());

    // Economy Class
    sections.add(
      _buildSectionHeader('Economy Class', Icons.airline_seat_recline_normal),
    );
    sections.addAll(
      _buildSeatRows(
        4,
        widget.flight.flightClass == FlightClass.economy ? 25 : 10,
        maxSeats: maxSeats,
      ),
    );

    return sections;
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.travelAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: AppColors.travelAccent),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppSizes.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.travelAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyExitRow() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emergency, color: Colors.orange[700], size: 18),
          const SizedBox(width: 8),
          Text(
            'Emergency Exit',
            style: AppSizes.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.orange[700],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSeatRows(
    int startRow,
    int endRow, {
    bool isBusinessClass = false,
    required int maxSeats,
  }) {
    final rows = <Widget>[];

    for (int row = startRow; row <= endRow; row++) {
      final seatConfiguration =
          isBusinessClass
              ? ['A', 'C', '  ', 'D', 'F']
              : ['A', 'B', 'C', '  ', 'D', 'E', 'F'];
      rows.add(
        _buildSeatRow(row, seatConfiguration, isBusinessClass, maxSeats),
      );
    }

    return rows;
  }

  Widget _buildSeatRow(
    int row,
    List<String> configuration,
    bool isBusinessClass,
    int maxSeats,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Row number
          SizedBox(
            width: 30,
            child: Text(
              '$row',
              textAlign: TextAlign.center,
              style: AppSizes.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          // Seats
          ...configuration.map((letter) {
            if (letter == '  ') {
              return const SizedBox(width: 24); // Aisle space
            }

            final seatId = '$row$letter';
            return _buildSeat(seatId, isBusinessClass, maxSeats);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSeat(String seatId, bool isBusinessClass, int maxSeats) {
    final isAvailable = widget.flight.availableSeats.contains(seatId);
    final isSelected = selectedSeats.contains(seatId);
    final isDisabled =
        !isAvailable || (selectedSeats.length >= maxSeats && !isSelected);
    final shouldShow = _shouldShowSeat(seatId);
    final isEmergencyExit = _isEmergencyExit(seatId);

    if (!shouldShow) {
      return Container(width: 32, height: 32, margin: const EdgeInsets.all(2));
    }

    Color seatColor;
    Color borderColor;

    if (isSelected) {
      seatColor = AppColors.travelAccent;
      borderColor = AppColors.travelAccent;
    } else if (!isAvailable) {
      seatColor = Colors.grey[300]!;
      borderColor = Colors.grey[400]!;
    } else if (isBusinessClass) {
      seatColor = Colors.amber[100]!;
      borderColor = Colors.amber[400]!;
    } else if (isEmergencyExit) {
      seatColor = Colors.orange[100]!;
      borderColor = Colors.orange[400]!;
    } else {
      seatColor = Colors.white;
      borderColor = Colors.grey[400]!;
    }

    return GestureDetector(
      onTap:
          isDisabled
              ? null
              : () {
                setState(() {
                  if (isSelected) {
                    selectedSeats.remove(seatId);
                  } else if (selectedSeats.length < maxSeats) {
                    selectedSeats.add(seatId);
                    // Add haptic feedback
                    // HapticFeedback.lightImpact();
                  }
                });
              },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColors.travelAccent.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Center(
          child: Text(
            seatId,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(int maxSeats) {
    return Container(
      padding: AppSizes.paddingAllMedium,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (selectedSeats.isNotEmpty) _buildSelectedSeatsInfo(),
          SizedBox(height: AppSizes.verticalSpaceMedium),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton(
              onPressed:
                  selectedSeats.length == maxSeats
                      ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => FlightBookingScreen(
                                  flight: widget.flight,
                                  selectedSeats: selectedSeats,
                                ),
                          ),
                        );
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.travelAccent,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, AppSizes.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: AppSizes.radiusMedium,
                ),
                disabledBackgroundColor: Colors.grey[400],
                elevation: selectedSeats.length == maxSeats ? 4 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_forward, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Proceed to Booking (${selectedSeats.length}/$maxSeats)',
                    style: AppSizes.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedSeatsInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.travelAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.travelAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_seat, color: AppColors.travelAccent, size: 20),
          const SizedBox(width: 8),
          Text(
            'Selected Seats: ',
            style: AppSizes.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.travelAccent,
            ),
          ),
          Expanded(
            child: Text(
              selectedSeats.join(', '),
              style: AppSizes.bodyMedium.copyWith(
                color: AppColors.travelAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
