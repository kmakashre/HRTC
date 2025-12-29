import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/travel/flight/provider/flight_provider.dart';

class FlightCard extends StatefulWidget {
  final Flight flight;
  final VoidCallback? onBook;

  const FlightCard({super.key, required this.flight, this.onBook});

  @override
  State<FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: AppSizes.paddingVerticalSmall,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: AppSizes.radiusMedium,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMainContent(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _isExpanded ? null : 0,
                child:
                    _isExpanded
                        ? _buildExpandedContent()
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.3, end: 0, duration: 400.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: 300.ms,
        );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: AppSizes.paddingAllMedium,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(widget.flight.airlineLogo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.flight.airline,
                        style: AppSizes.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        widget.flight.segments.first.flightNumber,
                        style: AppSizes.bodySmall.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  if (widget.flight.isCheapest)
                    _buildTag('Cheapest', Colors.green),
                  if (widget.flight.isFastest)
                    _buildTag('Fastest', Colors.blue),
                  if (widget.flight.isPopular)
                    _buildTag('Popular', Colors.orange),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.flight.departureTime,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.flight.segments.first.departure.code,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      widget.flight.segments.first.departure.city,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      children: List.generate(
                        widget.flight.segments.length * 2 - 1,
                        (index) {
                          if (index % 2 == 0) {
                            return Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: index == 0 ? Colors.green : Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            );
                          } else {
                            return Expanded(
                              child: Container(
                                height: 2,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.green, Colors.blue],
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.flight,
                                      color: Colors.grey[600],
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDuration(widget.flight.totalDuration),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (widget.flight.flightType != FlightType.direct)
                      Text(
                        _getStopsText(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange[600],
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.flight.arrivalTime,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.flight.segments.last.arrival.code,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      widget.flight.segments.last.arrival.city,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.flight.rating}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        ' (${widget.flight.reviewCount})',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildAmenityIcons(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.flight.basePrice != widget.flight.totalPrice)
                    Text(
                      '₹${widget.flight.basePrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey[500],
                      ),
                    ),
                  Text(
                    '₹${widget.flight.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.travelAccent,
                    ),
                  ),
                  Text(
                    'per person',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                  ),
                  label: Text(_isExpanded ? 'Less Details' : 'More Details'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.travelAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 16),
          _buildDetailSection('Flight Details', [
            _buildDetailRow(
              'Aircraft',
              widget.flight.segments.first.aircraftType,
            ),
            _buildDetailRow('Class', _getFlightClassText()),
            _buildDetailRow(
              'Seats Available',
              '${widget.flight.seatsAvailable}',
            ),
            _buildDetailRow('Airline Type', _getAirlineTypeText()),
          ]),
          const SizedBox(height: 16),
          _buildDetailSection('Inclusions', [
            _buildDetailRow(
              'Check-in Baggage',
              '${widget.flight.amenities.baggageKg} kg',
            ),
            _buildDetailRow(
              'Cabin Baggage',
              '${widget.flight.amenities.handBaggageKg} kg',
            ),
            _buildDetailRow(
              'Meals',
              widget.flight.amenities.meals ? 'Included' : 'Not Included',
            ),
            _buildDetailRow(
              'WiFi',
              widget.flight.amenities.wifi ? 'Available' : 'Not Available',
            ),
          ]),
          const SizedBox(height: 16),
          _buildDetailSection('Policies', [
            _buildDetailRow('Cancellation', widget.flight.cancellationPolicy),
            _buildDetailRow(
              'Refundable',
              widget.flight.isRefundable ? 'Yes' : 'No',
            ),
            _buildDetailRow(
              'Reschedulable',
              widget.flight.isReschedulable ? 'Yes' : 'No',
            ),
          ]),
          if (widget.flight.segments.length > 1) ...[
            const SizedBox(height: 16),
            _buildSegmentDetails(),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...details,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Flight Segments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.flight.segments.asMap().entries.map((entry) {
          final index = entry.key;
          final segment = entry.value;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${segment.departure.code} → ${segment.arrival.code}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      segment.flightNumber,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_formatTime(segment.departureTime)} - ${_formatTime(segment.arrivalTime)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      _formatDuration(segment.duration),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAmenityIcons() {
    return Row(
      children: [
        if (widget.flight.amenities.wifi) _buildAmenityIcon(Icons.wifi, 'WiFi'),
        if (widget.flight.amenities.meals)
          _buildAmenityIcon(Icons.restaurant, 'Meals'),
        if (widget.flight.amenities.entertainment)
          _buildAmenityIcon(Icons.tv, 'Entertainment'),
        if (widget.flight.amenities.powerOutlet)
          _buildAmenityIcon(Icons.power, 'Power'),
      ],
    );
  }

  Widget _buildAmenityIcon(IconData icon, String tooltip) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Tooltip(
        message: tooltip,
        child: Icon(icon, size: 16, color: Colors.green[600]),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getStopsText() {
    switch (widget.flight.flightType) {
      case FlightType.oneStop:
        return '1 Stop';
      case FlightType.multipleStops:
        return 'Multi Stop';
      default:
        return 'Direct';
    }
  }

  String _getFlightClassText() {
    switch (widget.flight.flightClass) {
      case FlightClass.economy:
        return 'Economy';
      case FlightClass.premiumEconomy:
        return 'Premium Economy';
      case FlightClass.business:
        return 'Business';
      case FlightClass.first:
        return 'First';
    }
  }

  String _getAirlineTypeText() {
    switch (widget.flight.airlineType) {
      case AirlineType.fullService:
        return 'Full Service';
      case AirlineType.lowCost:
        return 'Low Cost';
    }
  }
}
