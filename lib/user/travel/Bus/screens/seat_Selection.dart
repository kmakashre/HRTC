import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/travel/Bus/provider/bus_provider.dart';
import 'package:hrtc/user/travel/Bus/screens/bus_booking.dart';
import 'package:animate_do/animate_do.dart' show FadeIn, SlideInUp;

class SeatSelectionScreen extends ConsumerStatefulWidget {
  final Bus bus;

  const SeatSelectionScreen({super.key, required this.bus});

  @override
  ConsumerState<SeatSelectionScreen> createState() =>
      _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends ConsumerState<SeatSelectionScreen> {
  final List<String> selectedSeats = [];
  final ScrollController _scrollController = ScrollController();

  // Bus layout configuration
  final int seatsPerRow = 4;
  final int rows = 12;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final availableSeats = widget.bus.seatLayout.availableSeats;
    final totalSeats = widget.bus.seatLayout.totalSeats;
    final bookedSeats = List.generate(
      totalSeats - availableSeats,
      (index) => 'S${index + 1}',
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildBusInfo(),
          _buildSeatLegend(),
          Expanded(child: _buildSeatLayout(bookedSeats, totalSeats)),
          if (selectedSeats.isNotEmpty) _buildSelectedSeatsInfo(),
          _buildProceedButton(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.textPrimary,
          size: AppSizes.iconMedium,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Seats',
            style: AppSizes.headingSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            widget.bus.operator,
            style: AppSizes.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.close,
            color: AppColors.textSecondary,
            size: AppSizes.iconMedium,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(width: AppSizes.paddingSmall),
      ],
    );
  }

  Widget _buildBusInfo() {
    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMedium),
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSizes.radiusMedium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.paddingSmall),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: AppSizes.radiusSmall,
            ),
            child: Icon(
              Icons.directions_bus,
              color: Colors.blue.shade600,
              size: AppSizes.iconMedium,
            ),
          ),
          SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bus.operator,
                  style: AppSizes.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.verticalSpaceTiny),
                Row(
                  children: [
                    Icon(
                      Icons.event_seat,
                      size: AppSizes.iconSmall,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: AppSizes.paddingTiny),
                    Text(
                      '${widget.bus.seatLayout.totalSeats} seats',
                      style: AppSizes.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: AppSizes.paddingMedium),
                    Icon(
                      Icons.currency_rupee,
                      size: AppSizes.iconSmall,
                      color: AppColors.travelAccent,
                    ),
                    Text(
                      '${widget.bus.price.toInt()} per seat',
                      style: AppSizes.bodySmall.copyWith(
                        color: AppColors.travelAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSizes.radiusMedium,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSeatIndicator(
            Colors.green.shade100,
            Colors.green.shade600,
            'Available',
            Icons.event_seat_outlined,
          ),
          _buildSeatIndicator(
            Colors.grey.shade200,
            Colors.grey.shade600,
            'Booked',
            Icons.event_seat,
          ),
          _buildSeatIndicator(
            Colors.blue.shade100,
            Colors.blue.shade600,
            'Selected',
            Icons.event_seat,
          ),
        ],
      ),
    );
  }

  Widget _buildSeatIndicator(
    Color bgColor,
    Color iconColor,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          width: AppSizes.iconLarge,
          height: AppSizes.iconLarge * 0.8,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: iconColor.withOpacity(0.3)),
          ),
          child: Icon(icon, color: iconColor, size: AppSizes.iconMedium),
        ),
        SizedBox(height: AppSizes.verticalSpaceTiny),
        Text(
          label,
          style: AppSizes.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSeatLayout(List<String> bookedSeats, int totalSeats) {
    return Container(
      margin: EdgeInsets.all(AppSizes.paddingMedium),
      padding: EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSizes.radiusMedium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Driver section
            _buildDriverSection(),
            SizedBox(height: AppSizes.verticalSpaceLarge),

            // Seat grid
            _buildSeatGrid(bookedSeats, totalSeats),

            SizedBox(height: AppSizes.verticalSpaceMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.paddingMedium,
        horizontal: AppSizes.paddingLarge,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: AppSizes.radiusMedium,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.airline_seat_recline_normal,
            color: AppColors.textSecondary,
            size: AppSizes.iconMedium,
          ),
          SizedBox(width: AppSizes.paddingSmall),
          Text(
            'Driver',
            style: AppSizes.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatGrid(List<String> bookedSeats, int totalSeats) {
    return Column(
      children: List.generate(rows, (rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSizes.paddingMedium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left side seats (2 seats)
              _buildSeat(rowIndex * 4 + 1, bookedSeats, totalSeats),
              SizedBox(width: AppSizes.paddingSmall),
              _buildSeat(rowIndex * 4 + 2, bookedSeats, totalSeats),

              // Aisle space
              SizedBox(width: AppSizes.paddingExtraLarge),

              // Right side seats (2 seats)
              _buildSeat(rowIndex * 4 + 3, bookedSeats, totalSeats),
              SizedBox(width: AppSizes.paddingSmall),
              _buildSeat(rowIndex * 4 + 4, bookedSeats, totalSeats),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSeat(int seatNumber, List<String> bookedSeats, int totalSeats) {
    if (seatNumber > totalSeats) {
      return SizedBox(
        width: AppSizes.iconLarge,
        height: AppSizes.iconLarge * 0.9,
      );
    }

    final seatId = 'S$seatNumber';
    final isBooked = bookedSeats.contains(seatId);
    final isSelected = selectedSeats.contains(seatId);

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData seatIcon;

    if (isBooked) {
      backgroundColor = Colors.grey.shade200;
      borderColor = Colors.grey.shade400;
      textColor = Colors.grey.shade600;
      seatIcon = Icons.event_seat;
    } else if (isSelected) {
      backgroundColor = Colors.blue.shade50;
      borderColor = Colors.blue.shade600;
      textColor = Colors.blue.shade700;
      seatIcon = Icons.event_seat;
    } else {
      backgroundColor = Colors.green.shade50;
      borderColor = Colors.green.shade400;
      textColor = Colors.green.shade700;
      seatIcon = Icons.event_seat_outlined;
    }

    return FadeIn(
      duration: Duration(milliseconds: 300 + (seatNumber * 50)),
      child: GestureDetector(
        onTap: isBooked ? null : () => _onSeatTap(seatId),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: AppSizes.iconLarge * 1.5,
          height: AppSizes.iconLarge * 1.4,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                    : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(seatIcon, color: textColor, size: AppSizes.iconMedium * 0.8),
              SizedBox(height: AppSizes.verticalSpaceTiny * 0.5),
              Text(
                seatNumber.toString(),
                style: AppSizes.caption.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSizes.captionSize * 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSeatTap(String seatId) {
    setState(() {
      if (selectedSeats.contains(seatId)) {
        selectedSeats.remove(seatId);
      } else if (selectedSeats.length < 6) {
        // Max 6 seats selection
        selectedSeats.add(seatId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You can select maximum 6 seats at a time',
              style: AppSizes.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.orange.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: AppSizes.radiusSmall),
          ),
        );
      }
    });
  }

  Widget _buildSelectedSeatsInfo() {
    return SlideInUp(
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: EdgeInsets.all(AppSizes.paddingMedium),
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSizes.radiusMedium,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: AppSizes.iconMedium,
                ),
                SizedBox(width: AppSizes.paddingSmall),
                Text(
                  'Selected Seats',
                  style: AppSizes.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.verticalSpaceSmall),
            Wrap(
              spacing: AppSizes.paddingSmall,
              runSpacing: AppSizes.paddingSmall,
              children:
                  selectedSeats.map((seat) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMedium,
                        vertical: AppSizes.paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: AppSizes.radiusSmall,
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        seat,
                        style: AppSizes.bodyMedium.copyWith(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(height: AppSizes.verticalSpaceSmall),
            Container(
              padding: EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: AppSizes.radiusSmall,
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: AppSizes.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '₹${(selectedSeats.length * widget.bus.price).toInt()}',
                    style: AppSizes.headingSmall.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
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

  Widget _buildProceedButton() {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
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
      child: SafeArea(
        child: ElevatedButton(
          onPressed: selectedSeats.isEmpty ? null : _proceedToBooking,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedSeats.isEmpty
                    ? Colors.grey.shade300
                    : AppColors.travelAccent,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, AppSizes.buttonHeight),
            shape: RoundedRectangleBorder(borderRadius: AppSizes.radiusMedium),
            elevation: selectedSeats.isEmpty ? 0 : 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                selectedSeats.isEmpty
                    ? 'Select Seats to Continue'
                    : 'Proceed to Booking (${selectedSeats.length} seat${selectedSeats.length > 1 ? 's' : ''})',
                style: AppSizes.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color:
                      selectedSeats.isEmpty
                          ? Colors.grey.shade600
                          : Colors.white,
                ),
              ),
              if (selectedSeats.isNotEmpty) ...[
                SizedBox(width: AppSizes.paddingSmall),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: AppSizes.iconMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _proceedToBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BusBookingScreen(
              bus: widget.bus,
              selectedSeats: selectedSeats,
              totalPrice: selectedSeats.length * widget.bus.price,
            ),
      ),
    );
  }
}
