import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/travel/Travel/provider/travel_Provider.dart';
import 'package:hrtc/user/travel/Travel/screens/booking_screen.dart';
import 'package:hrtc/user/travel/flight/provider/flight_provider.dart';

class FlightBookingScreen extends ConsumerStatefulWidget {
  final Flight flight;
  final List<String> selectedSeats;

  const FlightBookingScreen({
    super.key,
    required this.flight,
    required this.selectedSeats,
  });

  @override
  ConsumerState<FlightBookingScreen> createState() =>
      _FlightBookingScreenState();
}

class _FlightBookingScreenState extends ConsumerState<FlightBookingScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildFlightInfoCard() {
    final travelState = ref.watch(travelProvider);
    final totalPrice = widget.flight.totalPrice * travelState.totalPassengers;

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.verticalSpaceMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.travelAccent.withOpacity(0.1),
            AppColors.travelAccent.withOpacity(0.05),
          ],
        ),
        borderRadius: AppSizes.radiusLarge,
        border: Border.all(
          color: AppColors.travelAccent.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.travelAccent.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: AppSizes.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.travelAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.flight,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: AppSizes.bodyMediumSize),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.flight.airline,
                        style: AppSizes.headingMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.travelAccent,
                        ),
                      ),
                      Text(
                        widget.flight.route,
                        style: AppSizes.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.verticalSpaceSmall),
            Divider(color: AppColors.travelAccent.withOpacity(0.2)),
            SizedBox(height: AppSizes.verticalSpaceSmall),
            _buildInfoRow(Icons.access_time, 'Time', widget.flight.timeRange),
            SizedBox(height: AppSizes.bodyMediumSize),
            _buildInfoRow(
              Icons.airline_seat_recline_normal,
              'Seats',
              widget.selectedSeats.join(", "),
            ),
            SizedBox(height: AppSizes.bodyMediumSize),
            _buildInfoRow(
              Icons.people,
              'Passengers',
              travelState.passengerSummary,
            ),
            SizedBox(height: AppSizes.verticalSpaceSmall),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.travelAccent.withOpacity(0.1),
                borderRadius: AppSizes.radiusMedium,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: AppSizes.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '₹${totalPrice.toStringAsFixed(0)}',
                    style: AppSizes.headingMedium.copyWith(
                      color: AppColors.travelAccent,
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.travelAccent),
        SizedBox(width: AppSizes.bodyMediumSize),
        Text(
          '$label: ',
          style: AppSizes.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppSizes.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.verticalSpaceSmall),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.travelAccent),
          border: OutlineInputBorder(
            borderRadius: AppSizes.radiusMedium,
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSizes.radiusMedium,
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSizes.radiusMedium,
            borderSide: const BorderSide(
              color: AppColors.travelAccent,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppSizes.radiusMedium,
            borderSide: const BorderSide(color: Colors.red),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPassengerDetailsSection() {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.verticalSpaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.travelAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.travelAccent,
                  size: 18,
                ),
              ),
              SizedBox(width: AppSizes.bodyMediumSize),
              Text(
                'Passenger Details',
                style: AppSizes.headingSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.travelAccent,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.verticalSpaceSmall),
          Text(
            'Please provide passenger information for booking confirmation',
            style: AppSizes.bodySmall.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: AppSizes.verticalSpaceMedium),
          _buildFormField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name as per ID',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              if (value.length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          _buildFormField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'Enter your email address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          _buildFormField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: 'Enter your phone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  void _handleBooking() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      final travelState = ref.watch(travelProvider);
      final totalPrice = widget.flight.totalPrice * travelState.totalPassengers;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => BookingConfirmationScreen(
                serviceType: 'Flight',
                details:
                    '${widget.flight.airline} - ${widget.flight.route} (${widget.selectedSeats.join(", ")})',
                price: totalPrice,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Book Flight',
          style: AppSizes.headingSmall.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.travelAccent),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey[200]),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: AppSizes.paddingAllMedium,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFlightInfoCard(),
                  _buildPassengerDetailsSection(),
                  SizedBox(height: AppSizes.verticalSpaceLarge),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: AppSizes.paddingAllMedium,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.travelAccent,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, AppSizes.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: AppSizes.radiusMedium,
              ),
              elevation: 0,
            ),
            child:
                _isLoading
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.bodyMediumSize),
                        Text(
                          'Processing...',
                          style: AppSizes.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.flight_takeoff, size: 20),
                        SizedBox(width: AppSizes.bodyMediumSize),
                        Text(
                          'Confirm Booking',
                          style: AppSizes.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
