import 'package:flutter/material.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/user/travel/Bus/provider/bus_provider.dart';
import 'package:hrtc/user/travel/Bus/screens/seat_selection.dart';
import 'dart:ui';

class BusDetailsScreen extends StatefulWidget {
  final Bus bus;

  const BusDetailsScreen({super.key, required this.bus});

  @override
  State<BusDetailsScreen> createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppSizes.longAnimationDuration,
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Parallax Effect
          SliverAppBar(
            expandedHeight: AppSizes.cardHeightLarge * 0.95,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              child: ClipRRect(
                borderRadius: AppSizes.radiusSmall * 0.95,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: AppSizes.elevationMedium * 2.5 * 0.95,
                    sigmaY: AppSizes.elevationMedium * 2.5 * 0.95,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: AppSizes.radiusSmall * 0.95,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: AppSizes.iconMedium * 0.95,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                margin: AppSizes.paddingAllTiny * 0.95,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: AppSizes.radiusSmall * 0.95,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: AppSizes.iconMedium * 0.95,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero Image with Parallax
                  Hero(
                    tag: 'bus-${widget.bus.busNumber}',
                    child: Image.network(
                      widget.bus.busImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue.shade400,
                                Colors.blue.shade600,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.directions_bus,
                              size: AppSizes.iconExtraLarge * 0.95,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Bus Info Overlay
                  Positioned(
                    bottom: AppSizes.paddingMedium * 0.95,
                    left: AppSizes.paddingMedium * 0.95,
                    right: AppSizes.paddingMedium * 0.95,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingSmall * 0.95,
                            vertical: AppSizes.paddingTiny * 0.95,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade500,
                            borderRadius: AppSizes.radiusSmall * 0.95,
                          ),
                          child: Text(
                            '${widget.bus.seatLayout.availableSeats} seats left',
                            style: AppSizes.caption.copyWith(
                              color: Colors.white,
                              fontSize: AppSizes.captionSize * 0.95,
                            ),
                          ),
                        ),
                        AppSizes.verticalSpaceTinyBox,
                        Text(
                          widget.bus.operator,
                          style: AppSizes.headingMedium.copyWith(
                            color: Colors.white,
                            fontSize: AppSizes.headingMediumSize * 0.95,
                          ),
                        ),
                        Text(
                          widget.bus.route ?? 'Route Information',
                          style: AppSizes.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: AppSizes.bodyMediumSize * 0.95,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.paddingMedium * 0.95,
                    AppSizes.paddingMedium * 0.95,
                    AppSizes.paddingMedium * 0.95,
                    AppSizes.bottomNavHeight * 0.95,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Stats Cards
                      _buildQuickStatsRow(),
                      AppSizes.verticalSpaceMediumBox,

                      // Bus Details Card
                      _buildDetailsCard(),
                      AppSizes.verticalSpaceSmallBox,

                      // Amenities Section
                      _buildAmenitiesSection(),
                      AppSizes.verticalSpaceSmallBox,

                      // Route Information
                      _buildRouteSection(),
                      AppSizes.verticalSpaceSmallBox,

                      // Pricing Card
                      _buildPricingCard(),
                      AppSizes.verticalSpaceSmallBox,

                      // Reviews Section
                      _buildReviewsSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Enhanced Bottom Navigation
      bottomNavigationBar: Container(
        padding: AppSizes.paddingAllMedium * 0.95,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: AppSizes.elevationHigh * 2.5 * 0.95,
              offset: Offset(0, -AppSizes.paddingTiny * 0.95),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Price Display
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Starting from',
                      style: AppSizes.caption.copyWith(
                        fontSize: AppSizes.captionSize * 0.95,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '₹${widget.bus.price.toInt()}',
                          style: AppSizes.headingMedium.copyWith(
                            fontSize: AppSizes.headingMediumSize * 0.95,
                            color: Colors.black87,
                          ),
                        ),
                        if (widget.bus.discountPercent > 0) ...[
                          AppSizes.horizontalSpaceTinyBox,
                          Text(
                            '₹${widget.bus.originalPrice.toInt()}',
                            style: AppSizes.bodySmall.copyWith(
                              fontSize: AppSizes.bodySmallSize * 0.95,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Book Button
              Expanded(
                child: Container(
                  height: AppSizes.buttonHeight * 0.95,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade500, Colors.blue.shade700],
                    ),
                    borderRadius: AppSizes.radiusMedium * 0.95,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: AppSizes.elevationMedium * 3 * 0.95,
                        offset: Offset(0, AppSizes.paddingTiny * 0.95),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SeatSelectionScreen(bus: widget.bus),
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSizes.radiusMedium * 0.95,
                      ),
                    ),
                    child: Text(
                      'Select Seats',
                      style: AppSizes.bodyLarge.copyWith(
                        color: Colors.white,
                        fontSize: AppSizes.bodyLargeSize * 0.95,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            Icons.event_seat,
            '${widget.bus.seatLayout.totalSeats}',
            'Total Seats',
            Colors.blue,
          ),
        ),
        AppSizes.horizontalSpaceSmallBox,
        Expanded(
          child: _buildStatCard(
            Icons.access_time,
            widget.bus.duration ?? 'N/A',
            'Duration',
            Colors.orange,
          ),
        ),
        AppSizes.horizontalSpaceSmallBox,
        Expanded(
          child: _buildStatCard(
            Icons.star,
            '${widget.bus.rating ?? 4.5}',
            'Rating',
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: AppSizes.paddingAllSmall * 0.95,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppSizes.radiusMedium * 0.95,
        border: Border.all(
          color: color.withOpacity(0.2),
          width: AppSizes.borderThin * 0.95,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSizes.iconMedium * 0.95),
          AppSizes.verticalSpaceTinyBox,
          Text(
            value,
            style: AppSizes.bodyMedium.copyWith(
              fontSize: AppSizes.bodyMediumSize * 0.95,
              color: color,
            ),
          ),
          Text(
            label,
            style: AppSizes.caption.copyWith(
              fontSize: AppSizes.captionSize * 0.95,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
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
                  Icons.info_outline,
                  color: Colors.blue.shade600,
                  size: AppSizes.iconMedium * 0.95,
                ),
              ),
              AppSizes.horizontalSpaceSmallBox,
              Text(
                'Bus Details',
                style: AppSizes.headingSmall.copyWith(
                  fontSize: AppSizes.headingSmallSize * 0.95,
                ),
              ),
            ],
          ),
          AppSizes.verticalSpaceSmallBox,
          _buildDetailRow('Bus Number', widget.bus.busNumber),
          _buildDetailRow('Owner', widget.bus.busOwner),
          _buildDetailRow('Bus Type', widget.bus.seatLayout.busType),
          _buildDetailRow(
            'Available Seats',
            '${widget.bus.seatLayout.availableSeats}',
            valueColor:
                widget.bus.seatLayout.availableSeats < 10
                    ? Colors.red.shade600
                    : Colors.green.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection() {
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
                  color: Colors.green.shade50,
                  borderRadius: AppSizes.radiusSmall * 0.95,
                ),
                child: Icon(
                  Icons.star_outline,
                  color: Colors.green.shade600,
                  size: AppSizes.iconMedium * 0.95,
                ),
              ),
              AppSizes.horizontalSpaceSmallBox,
              Text(
                'Amenities',
                style: AppSizes.headingSmall.copyWith(
                  fontSize: AppSizes.headingSmallSize * 0.95,
                ),
              ),
            ],
          ),
          AppSizes.verticalSpaceSmallBox,
          Wrap(
            spacing: AppSizes.gridSpacing * 0.95,
            runSpacing: AppSizes.gridSpacing * 0.95,
            children:
                widget.bus.amenities.map((amenity) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingSmall * 0.95,
                      vertical: AppSizes.paddingTiny * 0.95,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                      ),
                      borderRadius: AppSizes.radiusLarge * 0.95,
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: AppSizes.borderThin * 0.95,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          amenity.icon,
                          style: TextStyle(
                            fontSize: AppSizes.bodyMediumSize * 0.95,
                          ),
                        ),
                        AppSizes.horizontalSpaceTinyBox,
                        Text(
                          amenity.name,
                          style: AppSizes.bodyMedium.copyWith(
                            fontSize: AppSizes.bodyMediumSize * 0.95,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSection() {
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
                  Icons.route,
                  color: Colors.orange.shade600,
                  size: AppSizes.iconMedium * 0.95,
                ),
              ),
              AppSizes.horizontalSpaceSmallBox,
              Text(
                'Route Information',
                style: AppSizes.headingSmall.copyWith(
                  fontSize: AppSizes.headingSmallSize * 0.95,
                ),
              ),
            ],
          ),
          AppSizes.verticalSpaceSmallBox,
          _buildRoutePoints(
            'Pickup Points',
            widget.bus.pickupPoints,
            Colors.green,
          ),
          AppSizes.verticalSpaceSmallBox,
          _buildRoutePoints(
            'Drop-off Points',
            widget.bus.dropoffPoints,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildRoutePoints(String title, List<String> points, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppSizes.bodyMedium.copyWith(
            fontSize: AppSizes.bodyMediumSize * 0.95,
            color: Colors.grey.shade700,
          ),
        ),
        AppSizes.verticalSpaceTinyBox,
        ...points.map(
          (point) => Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSizes.paddingTiny * 0.95,
            ),
            child: Row(
              children: [
                Container(
                  width: AppSizes.paddingTiny * 0.95,
                  height: AppSizes.paddingTiny * 0.95,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                AppSizes.horizontalSpaceSmallBox,
                Expanded(
                  child: Text(
                    point,
                    style: AppSizes.bodyMedium.copyWith(
                      fontSize: AppSizes.bodyMediumSize * 0.95,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCard() {
    return Container(
      padding: AppSizes.paddingAllMedium * 0.95,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.blue.shade50],
        ),
        borderRadius: AppSizes.radiusMedium * 0.95,
        border: Border.all(
          color: Colors.blue.shade200,
          width: AppSizes.borderThin * 0.95,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSizes.paddingAllSmall * 0.95,
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: AppSizes.radiusSmall * 0.95,
                ),
                child: Icon(
                  Icons.attach_money,
                  color: Colors.purple.shade600,
                  size: AppSizes.iconMedium * 0.95,
                ),
              ),
              AppSizes.horizontalSpaceSmallBox,
              Text(
                'Pricing Details',
                style: AppSizes.headingSmall.copyWith(
                  fontSize: AppSizes.headingSmallSize * 0.95,
                ),
              ),
            ],
          ),
          AppSizes.verticalSpaceSmallBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price per seat',
                style: AppSizes.bodyMedium.copyWith(
                  fontSize: AppSizes.bodyMediumSize * 0.95,
                ),
              ),
              Text(
                '₹${widget.bus.price.toInt()}',
                style: AppSizes.headingSmall.copyWith(
                  fontSize: AppSizes.headingSmallSize * 0.95,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (widget.bus.discountPercent > 0) ...[
            AppSizes.verticalSpaceTinyBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'You Save',
                  style: AppSizes.bodyMedium.copyWith(
                    fontSize: AppSizes.bodyMediumSize * 0.95,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmall * 0.95,
                    vertical: AppSizes.paddingTiny * 0.95,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: AppSizes.radiusSmall * 0.95,
                  ),
                  child: Text(
                    '₹${widget.bus.discountAmount.toInt()}',
                    style: AppSizes.bodyMedium.copyWith(
                      fontSize: AppSizes.bodyMediumSize * 0.95,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
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
                  color: Colors.amber.shade50,
                  borderRadius: AppSizes.radiusSmall * 0.95,
                ),
                child: Icon(
                  Icons.reviews_outlined,
                  color: Colors.amber.shade600,
                  size: AppSizes.iconMedium * 0.95,
                ),
              ),
              AppSizes.horizontalSpaceSmallBox,
              Text(
                'Recent Reviews',
                style: AppSizes.headingSmall.copyWith(
                  fontSize: AppSizes.headingSmallSize * 0.95,
                ),
              ),
            ],
          ),
          AppSizes.verticalSpaceSmallBox,
          ...widget.bus.reviews.map(
            (review) => Container(
              margin: EdgeInsets.only(bottom: AppSizes.paddingSmall * 0.95),
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
                  Row(
                    children: [
                      CircleAvatar(
                        radius: AppSizes.avatarSmall * 0.475,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          review.userName[0].toUpperCase(),
                          style: AppSizes.bodyMedium.copyWith(
                            color: Colors.blue.shade700,
                            fontSize: AppSizes.bodyMediumSize * 0.95,
                          ),
                        ),
                      ),
                      AppSizes.horizontalSpaceSmallBox,
                      Text(
                        review.userName,
                        style: AppSizes.bodyMedium.copyWith(
                          fontSize: AppSizes.bodyMediumSize * 0.95,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < review.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            size: AppSizes.iconSmall * 0.95,
                            color: Colors.amber.shade400,
                          );
                        }),
                      ),
                    ],
                  ),
                  AppSizes.verticalSpaceTinyBox,
                  Text(
                    review.comment,
                    style: AppSizes.bodySmall.copyWith(
                      fontSize: AppSizes.bodySmallSize * 0.95,
                      color: Colors.grey.shade700,
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

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.paddingTiny * 0.95),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppSizes.bodySmall.copyWith(
              fontSize: AppSizes.bodySmallSize * 0.95,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: AppSizes.bodyMedium.copyWith(
              fontSize: AppSizes.bodyMediumSize * 0.95,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
