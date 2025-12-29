import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/travel/Bus/provider/bus_provider.dart';
import 'package:hrtc/user/travel/Travel/screens/booking_screen.dart';

class BusBookingScreen extends ConsumerStatefulWidget {
  final Bus bus;
  final List<String> selectedSeats;
  final double totalPrice;

  const BusBookingScreen({
    super.key,
    required this.bus,
    required this.selectedSeats,
    required this.totalPrice,
  });

  @override
  ConsumerState<BusBookingScreen> createState() => _BusBookingScreenState();
}

class _BusBookingScreenState extends ConsumerState<BusBookingScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();

  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  final int _currentStep = 0;
  String _selectedGender = 'Male';
  bool _acceptTerms = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppSizes.longAnimationDuration,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: AppSizes.appBarHeight * 0.95,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade600, Colors.blue.shade800],
                ),
              ),
              child: FlexibleSpaceBar(
                title: Text(
                  'Complete Booking',
                  style: AppSizes.headingSmall.copyWith(
                    color: Colors.white,
                    fontSize: AppSizes.headingSmallSize * 0.95,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue.shade600, Colors.blue.shade800],
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: AppSizes.iconMedium * 0.95,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: AppSizes.paddingAllMedium * 0.95,
                  child: Column(
                    children: [
                      // Trip Summary Card
                      _buildTripSummaryCard(),
                      AppSizes.verticalSpaceMediumBox,

                      // Passenger Details Form
                      _buildPassengerDetailsCard(),
                      AppSizes.verticalSpaceMediumBox,

                      // Price Breakdown
                      _buildPriceBreakdownCard(),
                      AppSizes.verticalSpaceMediumBox,

                      // Terms and Conditions
                      _buildTermsCard(),
                      SizedBox(height: AppSizes.verticalSpaceExtraLarge * 0.95),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Enhanced Bottom Sheet
      bottomNavigationBar: Container(
        padding: AppSizes.paddingAllMedium * 0.95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSizes.radiusLarge * 0.95,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: AppSizes.elevationHigh * 2.5 * 0.95,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Total Amount Display
              Container(
                padding: AppSizes.paddingAllSmall * 0.95,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade50, Colors.green.shade100],
                  ),
                  borderRadius: AppSizes.radiusMedium * 0.95,
                  border: Border.all(
                    color: Colors.green.shade200,
                    width: AppSizes.borderThin * 0.95,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: AppSizes.caption.copyWith(
                            fontSize: AppSizes.captionSize * 0.95,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '₹${widget.totalPrice.toInt()}',
                          style: AppSizes.headingMedium.copyWith(
                            fontSize: AppSizes.headingMediumSize * 0.95,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingSmall * 0.95,
                        vertical: AppSizes.paddingTiny * 0.95,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: AppSizes.radiusSmall * 0.95,
                      ),
                      child: Text(
                        '${widget.selectedSeats.length} Seat${widget.selectedSeats.length > 1 ? 's' : ''}',
                        style: AppSizes.caption.copyWith(
                          color: Colors.white,
                          fontSize: AppSizes.captionSize * 0.95,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSizes.verticalSpaceSmallBox,

              // Book Button
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isProcessing ? _pulseAnimation.value : 1.0,
                    child: Container(
                      width: double.infinity,
                      height: AppSizes.buttonHeight * 0.95,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              _acceptTerms
                                  ? [Colors.blue.shade500, Colors.blue.shade700]
                                  : [
                                    Colors.grey.shade300,
                                    Colors.grey.shade400,
                                  ],
                        ),
                        borderRadius: AppSizes.radiusMedium * 0.95,
                        boxShadow:
                            _acceptTerms
                                ? [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.4),
                                    blurRadius:
                                        AppSizes.elevationHigh * 1.875 * 0.95,
                                    offset: Offset(
                                      0,
                                      AppSizes.paddingTiny * 0.95,
                                    ),
                                  ),
                                ]
                                : [],
                      ),
                      child: ElevatedButton(
                        onPressed:
                            _acceptTerms && !_isProcessing
                                ? _processBooking
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppSizes.radiusMedium * 0.95,
                          ),
                        ),
                        child:
                            _isProcessing
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: AppSizes.iconSmall * 0.95,
                                      height: AppSizes.iconSmall * 0.95,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: AppSizes.borderThin * 0.95,
                                      ),
                                    ),
                                    AppSizes.horizontalSpaceSmallBox,
                                    Text(
                                      'Processing...',
                                      style: AppSizes.bodyLarge.copyWith(
                                        color: Colors.white,
                                        fontSize: AppSizes.bodyLargeSize * 0.95,
                                      ),
                                    ),
                                  ],
                                )
                                : Text(
                                  'Confirm Booking',
                                  style: AppSizes.bodyLarge.copyWith(
                                    color: Colors.white,
                                    fontSize: AppSizes.bodyLargeSize * 0.95,
                                  ),
                                ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    return Container(
      padding: AppSizes.paddingAllMedium * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSizes.radiusMedium * 0.95,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppSizes.elevationHigh * 2.5 * 0.95,
            offset: Offset(0, AppSizes.paddingTiny * 0.95),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSizes.paddingAllSmall * 0.95,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: AppSizes.radiusSmall * 0.95,
                ),
                child: Icon(
                  Icons.directions_bus,
                  color: Colors.blue.shade600,
                  size: AppSizes.iconMedium * 0.95,
                ),
              ),
              AppSizes.horizontalSpaceSmallBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.bus.operator,
                      style: AppSizes.headingSmall.copyWith(
                        fontSize: AppSizes.headingSmallSize * 0.95,
                      ),
                    ),
                    Text(
                      widget.bus.route ?? 'Route Information',
                      style: AppSizes.bodySmall.copyWith(
                        fontSize: AppSizes.bodySmallSize * 0.95,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSizes.verticalSpaceSmallBox,

          // Journey Details
          Container(
            padding: AppSizes.paddingAllSmall * 0.95,
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: AppSizes.radiusSmall * 0.95,
              border: Border.all(
                color: Colors.blue.shade100,
                width: AppSizes.borderThin * 0.95,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: AppSizes.iconSmall * 0.95,
                      color: Colors.blue.shade600,
                    ),
                    AppSizes.horizontalSpaceTinyBox,
                    Text(
                      'Duration: ${widget.bus.duration ?? 'N/A'}',
                      style: AppSizes.bodySmall.copyWith(
                        fontSize: AppSizes.bodySmallSize * 0.95,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                AppSizes.verticalSpaceTinyBox,
                Row(
                  children: [
                    Icon(
                      Icons.event_seat,
                      size: AppSizes.iconSmall * 0.95,
                      color: Colors.blue.shade600,
                    ),
                    AppSizes.horizontalSpaceTinyBox,
                    Text(
                      'Selected Seats: ${widget.selectedSeats.join(", ")}',
                      style: AppSizes.bodySmall.copyWith(
                        fontSize: AppSizes.bodySmallSize * 0.95,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
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

  Widget _buildPassengerDetailsCard() {
    return Container(
      padding: AppSizes.paddingAllMedium * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSizes.radiusMedium * 0.95,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppSizes.elevationHigh * 2.5 * 0.95,
            offset: Offset(0, AppSizes.paddingTiny * 0.95),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: AppSizes.paddingAllSmall * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: AppSizes.radiusSmall * 0.95,
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.green.shade600,
                    size: AppSizes.iconMedium * 0.95,
                  ),
                ),
                AppSizes.horizontalSpaceSmallBox,
                Text(
                  'Passenger Details',
                  style: AppSizes.headingSmall.copyWith(
                    fontSize: AppSizes.headingSmallSize * 0.95,
                  ),
                ),
              ],
            ),
            AppSizes.verticalSpaceSmallBox,

            // Name Field
            _buildAnimatedTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
              validator:
                  (value) => value!.isEmpty ? 'Please enter your name' : null,
            ),
            AppSizes.verticalSpaceSmallBox,

            // Email Field
            _buildAnimatedTextField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter your email';
                if (!value.contains('@')) return 'Please enter a valid email';
                return null;
              },
            ),
            AppSizes.verticalSpaceSmallBox,

            // Phone Field
            _buildAnimatedTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter your phone number';
                if (value.length < 10) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            AppSizes.verticalSpaceSmallBox,

            // Age and Gender Row
            Row(
              children: [
                Expanded(
                  child: _buildAnimatedTextField(
                    controller: _ageController,
                    label: 'Age',
                    icon: Icons.cake,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter age';
                      int? age = int.tryParse(value);
                      if (age == null || age < 1 || age > 120) {
                        return 'Please enter valid age';
                      }
                      return null;
                    },
                  ),
                ),
                AppSizes.horizontalSpaceSmallBox,
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingSmall * 0.95,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: AppSizes.borderThin * 0.95,
                      ),
                      borderRadius: AppSizes.radiusSmall * 0.95,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGender,
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade600,
                          size: AppSizes.iconMedium * 0.95,
                        ),
                        items:
                            ['Male', 'Female', 'Other'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: AppSizes.bodyMedium.copyWith(
                                    fontSize: AppSizes.bodyMediumSize * 0.95,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return AnimatedContainer(
      duration: AppSizes.mediumAnimationDuration,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppSizes.label.copyWith(
            fontSize: AppSizes.labelSize * 0.95,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.blue.shade600,
            size: AppSizes.iconMedium * 0.95,
          ),
          border: OutlineInputBorder(
            borderRadius: AppSizes.radiusSmall * 0.95,
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: AppSizes.borderThin * 0.95,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSizes.radiusSmall * 0.95,
            borderSide: BorderSide(
              color: Colors.blue.shade600,
              width: AppSizes.borderMedium * 0.95,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSizes.radiusSmall * 0.95,
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: AppSizes.borderThin * 0.95,
            ),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        style: AppSizes.bodyMedium.copyWith(
          fontSize: AppSizes.bodyMediumSize * 0.95,
        ),
      ),
    );
  }

  Widget _buildPriceBreakdownCard() {
    double basePrice = widget.totalPrice / widget.selectedSeats.length;
    double taxes = widget.totalPrice * 0.05; // Assuming 5% tax
    double convenience = AppSizes.paddingMedium * 0.95; // Convenience fee

    return Container(
      padding: AppSizes.paddingAllMedium * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSizes.radiusMedium * 0.95,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppSizes.elevationHigh * 2.5 * 0.95,
            offset: Offset(0, AppSizes.paddingTiny * 0.95),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSizes.paddingAllSmall * 0.95,
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: AppSizes.radiusSmall * 0.95,
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: Colors.purple.shade600,
                  size: AppSizes.iconMedium * 0.95,
                ),
              ),
              AppSizes.horizontalSpaceSmallBox,
              Text(
                'Price Breakdown',
                style: AppSizes.headingSmall.copyWith(
                  fontSize: AppSizes.headingSmallSize * 0.95,
                ),
              ),
            ],
          ),
          AppSizes.verticalSpaceSmallBox,

          _buildPriceRow(
            'Base Price (${widget.selectedSeats.length} seats)',
            '₹${(basePrice * widget.selectedSeats.length).toInt()}',
          ),
          _buildPriceRow('Taxes & Fees', '₹${taxes.toInt()}'),
          _buildPriceRow('Convenience Fee', '₹${convenience.toInt()}'),

          Divider(height: AppSizes.verticalSpaceMedium * 0.95),

          _buildPriceRow(
            'Total Amount',
            '₹${(widget.totalPrice + taxes + convenience).toInt()}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.paddingTiny * 0.95),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppSizes.bodyMedium.copyWith(
              fontSize:
                  isTotal
                      ? AppSizes.bodyLargeSize * 0.95
                      : AppSizes.bodyMediumSize * 0.95,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black87 : Colors.grey.shade700,
            ),
          ),
          Text(
            amount,
            style: AppSizes.bodyMedium.copyWith(
              fontSize:
                  isTotal
                      ? AppSizes.headingSmallSize * 0.95
                      : AppSizes.bodyMediumSize * 0.95,
              fontWeight: FontWeight.bold,
              color: isTotal ? Colors.green.shade600 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return Container(
      padding: AppSizes.paddingAllMedium * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSizes.radiusMedium * 0.95,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: AppSizes.elevationHigh * 2.5 * 0.95,
            offset: Offset(0, AppSizes.paddingTiny * 0.95),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSizes.paddingAllSmall * 0.95,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: AppSizes.radiusSmall * 0.95,
                ),
                child: Icon(
                  Icons.gavel,
                  color: Colors.orange.shade600,
                  size: AppSizes.iconMedium * 0.95,
                ),
              ),
              AppSizes.horizontalSpaceSmallBox,
              Text(
                'Terms & Conditions',
                style: AppSizes.headingSmall.copyWith(
                  fontSize: AppSizes.headingSmallSize * 0.95,
                ),
              ),
            ],
          ),
          AppSizes.verticalSpaceSmallBox,

          Container(
            padding: AppSizes.paddingAllSmall * 0.95,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: AppSizes.radiusSmall * 0.95,
              border: Border.all(
                color: Colors.grey.shade200,
                width: AppSizes.borderThin * 0.95,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Cancellation allowed up to 2 hours before departure',
                  style: AppSizes.caption.copyWith(
                    fontSize: AppSizes.captionSize * 0.95,
                    color: Colors.grey.shade700,
                  ),
                ),
                AppSizes.verticalSpaceTinyBox,
                Text(
                  '• Please carry a valid ID proof during travel',
                  style: AppSizes.caption.copyWith(
                    fontSize: AppSizes.captionSize * 0.95,
                    color: Colors.grey.shade700,
                  ),
                ),
                AppSizes.verticalSpaceTinyBox,
                Text(
                  '• Arrive at pickup point 15 minutes before departure',
                  style: AppSizes.caption.copyWith(
                    fontSize: AppSizes.captionSize * 0.95,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          AppSizes.verticalSpaceSmallBox,

          Row(
            children: [
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: _acceptTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                  activeColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSizes.radiusTiny * 0.95,
                  ),
                ),
              ),
              AppSizes.horizontalSpaceTinyBox,
              Expanded(
                child: Text(
                  'I accept the terms and conditions and privacy policy',
                  style: AppSizes.bodySmall.copyWith(
                    fontSize: AppSizes.bodySmallSize * 0.95,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _processBooking() async {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      setState(() {
        _isProcessing = true;
      });

      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (
                  context,
                  animation,
                  secondaryAnimation,
                ) => BookingConfirmationScreen(
                  serviceType: 'Bus',
                  details:
                      '${widget.bus.operator} - ${widget.bus.route}\nSeats: ${widget.selectedSeats.join(", ")}\nPassenger: ${_nameController.text}',
                  price:
                      widget.totalPrice +
                      (widget.totalPrice * 0.05) +
                      (AppSizes.paddingMedium * 0.95),
                ),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      }

      setState(() {
        _isProcessing = false;
      });
    }
  }
}
