  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:hrtc/core/utils/colors.dart';
  import 'package:hrtc/core/utils/sizes.dart';

  class BookingConfirmationScreen extends StatefulWidget {
    final String serviceType;
    final String details;
    final double price;

    const BookingConfirmationScreen({
      super.key,
      required this.serviceType,
      required this.details,
      required this.price,
    });

    @override
    State<BookingConfirmationScreen> createState() =>
        _BookingConfirmationScreenState();
  }

  class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
      with TickerProviderStateMixin {
    late AnimationController _checkmarkController;
    late AnimationController _contentController;
    late AnimationController _pulseController;

    late Animation<double> _checkmarkAnimation;
    late Animation<double> _fadeAnimation;
    late Animation<Offset> _slideAnimation;
    late Animation<double> _pulseAnimation;

    String bookingId = '';

    @override
    void initState() {
      super.initState();

      // Generate booking ID
      bookingId = _generateBookingId();

      _checkmarkController = AnimationController(
        duration: const Duration(milliseconds: 1200),
        vsync: this,
      );

      _contentController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );

      _pulseController = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this,
      );

      _checkmarkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _checkmarkController, curve: Curves.elasticOut),
      );

      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _contentController, curve: Curves.easeInOut),
      );

      _slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
      );

      _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      );

      // Start animations
      _startAnimations();
    }

    void _startAnimations() async {
      await Future.delayed(const Duration(milliseconds: 300));
      _checkmarkController.forward();

      await Future.delayed(const Duration(milliseconds: 600));
      _contentController.forward();

      await Future.delayed(const Duration(milliseconds: 1000));
      _pulseController.repeat(reverse: true);
    }

    String _generateBookingId() {
      final now = DateTime.now();
      final letters = ['A', 'B', 'C', 'D', 'E', 'F'];
      final letter = letters[now.second % letters.length];
      return '$letter${now.millisecondsSinceEpoch.toString().substring(7)}';
    }

    @override
    void dispose() {
      _checkmarkController.dispose();
      _contentController.dispose();
      _pulseController.dispose();
      super.dispose();
    }

    Widget _buildSuccessIcon() {
      return AnimatedBuilder(
        animation: _checkmarkAnimation,
        builder: (context, child) {
          return AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.success,
                        AppColors.success.withOpacity(0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Transform.scale(
                      scale: _checkmarkAnimation.value,
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    Widget _buildBookingCard() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: AppSizes.verticalSpaceMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSizes.radiusLarge,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
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
                      color: AppColors.travelAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getServiceIcon(),
                      color: AppColors.travelAccent,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: AppSizes.bodyMediumSize),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Details',
                          style: AppSizes.headingSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.travelAccent,
                          ),
                        ),
                        Text(
                          'Confirmation ID: $bookingId',
                          style: AppSizes.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: bookingId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Booking ID copied to clipboard'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.copy, size: 18, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.verticalSpaceMedium),
              _buildDetailRow('Service Type', widget.serviceType, Icons.category),
              SizedBox(height: AppSizes.verticalSpaceSmall),
              _buildDetailRow(
                'Booking Details',
                widget.details,
                Icons.info_outline,
              ),
              SizedBox(height: AppSizes.verticalSpaceSmall),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.travelAccent.withOpacity(0.1),
                      AppColors.travelAccent.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: AppSizes.radiusMedium,
                  border: Border.all(
                    color: AppColors.travelAccent.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.payment,
                          color: AppColors.travelAccent,
                          size: 20,
                        ),
                        SizedBox(width: AppSizes.bodyMediumSize),
                        Text(
                          'Total Amount Paid',
                          style: AppSizes.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹${widget.price.toStringAsFixed(0)}',
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

    Widget _buildDetailRow(String label, String value, IconData icon) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          SizedBox(width: AppSizes.bodyMediumSize),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppSizes.bodySmall.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppSizes.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    IconData _getServiceIcon() {
      switch (widget.serviceType.toLowerCase()) {
        case 'flight':
          return Icons.flight;
        case 'hotel':
          return Icons.hotel;
        case 'train':
          return Icons.train;
        case 'bus':
          return Icons.directions_bus;
        default:
          return Icons.travel_explore;
      }
    }

    Widget _buildQuickActions() {
      return Container(
        margin: EdgeInsets.only(bottom: AppSizes.verticalSpaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: AppSizes.headingSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppSizes.verticalSpaceSmall),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Download Ticket',
                    Icons.download,
                    () => _showComingSoon('Download feature'),
                  ),
                ),
                SizedBox(width: AppSizes.bodyMediumSize),
                Expanded(
                  child: _buildActionButton(
                    'Share Booking',
                    Icons.share,
                    () => _showComingSoon('Share feature'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppSizes.radiusMedium,
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.travelAccent),
              SizedBox(width: AppSizes.bodyMediumSize),
              Text(
                label,
                style: AppSizes.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.travelAccent,
                ),
              ),
            ],
          ),
        ),
      );
    }

    void _showComingSoon(String feature) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$feature coming soon!'),
          backgroundColor: AppColors.travelAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      AppSizes.init(context);

      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'Booking Confirmation',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: AppSizes.verticalSpaceMedium),
                  _buildSuccessIcon(),
                  SizedBox(height: AppSizes.verticalSpaceMedium),
                  Text(
                    'Booking Confirmed!',
                    style: AppSizes.headingLarge.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSizes.verticalSpaceSmall),
                  Text(
                    'Your booking has been successfully confirmed.\nYou will receive a confirmation email shortly.',
                    textAlign: TextAlign.center,
                    style: AppSizes.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  _buildBookingCard(),
                  _buildQuickActions(),
                ],
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.travelAccent,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, AppSizes.buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSizes.radiusMedium,
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.home, size: 20),
                      SizedBox(width: AppSizes.bodyMediumSize),
                      Text(
                        'Back to Home',
                        style: AppSizes.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.verticalSpaceSmall),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Book Another ${widget.serviceType}',
                    style: AppSizes.bodyMedium.copyWith(
                      color: AppColors.travelAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
