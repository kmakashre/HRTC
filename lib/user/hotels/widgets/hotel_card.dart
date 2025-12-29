import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hrtc/core/utils/sizes.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/user/hotels/provider/hotel_provider.dart';

class HotelCard extends StatefulWidget {
  final Hotel hotel;
  final double width;
  final VoidCallback onTap;

  const HotelCard({
    super.key,
    required this.hotel,
    required this.width,
    required this.onTap,
  });

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  final bool _isFavorite = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Widget _buildRatingStars() {
    final fullStars = widget.hotel.rating.floor();
    final hasHalfStar = widget.hotel.rating - fullStars >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          fullStars,
          (index) => Icon(
            Icons.star,
            size: AppSizes.iconTiny,
            color: Colors.amber[600],
          ),
        ),
        if (hasHalfStar)
          Icon(
            Icons.star_half,
            size: AppSizes.iconTiny,
            color: Colors.amber[600],
          ),
        ...List.generate(
          5 - fullStars - (hasHalfStar ? 1 : 0),
          (index) => Icon(
            Icons.star_border,
            size: AppSizes.iconTiny,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Stack(
      alignment:
          Alignment.center, // Ensure all non-positioned children are centered
      children: [
        // Main image with gradient overlay
        Container(
          height: AppSizes.appBarHeight * 4.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: AppSizes.radiusLarge.topLeft,
              topRight: AppSizes.radiusLarge.topRight,
            ),
            image:
                widget.hotel.imageUrl.isNotEmpty
                    ? DecorationImage(
                      image: NetworkImage(widget.hotel.imageUrl),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) => const SizedBox(),
                    )
                    : null,
            color:
                widget.hotel.imageUrl.isEmpty
                    ? AppColors.hotelsAccent.withOpacity(0.1)
                    : null,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.3),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.hotelsAccent.withOpacity(0.0),
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child:
              widget.hotel.imageUrl == null && widget.hotel.imageUrl.isEmpty
                  ? null
                  : Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: AppSizes.iconLarge,
                      color: AppColors.hotelsAccent.withOpacity(0.5),
                    ),
                  ),
        ),
        // Hotel icon with animated background
        Positioned.fill(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.85),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.hotelsAccent.withOpacity(0.0),
                    blurRadius: 3,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                    Icons.hotel_rounded,
                    size: AppSizes.iconLarge, // Slightly smaller for balance
                    color: AppColors.hotelsAccent,
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .shimmer(
                    duration: const Duration(milliseconds: 2000),
                    color: Colors.white.withOpacity(0.5),
                  ),
            ),
          ),
        ),
        // Premium badge
        Positioned(
          top: 10,
          right: 15,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'Premium',
              style: AppSizes.bodySmall.copyWith(
                color: AppColors.hotelsAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hotel.name,
            style: AppSizes.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSizes.paddingTiny),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: AppSizes.iconTiny,
                color: Colors.grey[600],
              ),
              SizedBox(width: AppSizes.paddingTiny / 2),
              Expanded(
                child: Text(
                  widget.hotel.city,
                  style: AppSizes.bodySmall.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber[200]!, width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRatingStars(),
                SizedBox(width: AppSizes.paddingTiny),
                Text(
                  '${widget.hotel.rating}',
                  style: AppSizes.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.amber[800],
                  ),
                ),
                SizedBox(width: AppSizes.paddingTiny / 2),
                Text(
                  '(${widget.hotel.reviews})',
                  style: AppSizes.bodySmall.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Starting from',
                    style: AppSizes.bodySmall.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.hotel.pricePerNight,
                        style: AppSizes.headingSmall.copyWith(
                          color: AppColors.hotelsAccent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '/night',
                        style: AppSizes.bodySmall.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.hotelsAccent,
                          AppColors.hotelsAccent.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.hotelsAccent.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Book Now',
                      style: AppSizes.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  .animate()
                  .shimmer(delay: 1000.ms, duration: 1500.ms)
                  .then()
                  .shake(hz: 2, curve: Curves.easeInOut),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return MouseRegion(
          onEnter: (_) => _onHover(true),
          onExit: (_) => _onHover(false),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    width: widget.width,
                    margin: EdgeInsets.symmetric(
                      vertical: AppSizes.verticalSpaceSmall,
                    ),
                    child: Card(
                      elevation: _isHovered ? 12 : 8,
                      shadowColor: AppColors.hotelsAccent.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSizes.radiusMedium,
                        side: BorderSide(
                          color:
                              _isHovered
                                  ? AppColors.hotelsAccent.withOpacity(0.3)
                                  : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      margin: EdgeInsets.zero,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: AppSizes.radiusMedium,
                          gradient:
                              _isHovered
                                  ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white,
                                      AppColors.hotelsAccent.withOpacity(0.02),
                                    ],
                                  )
                                  : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildImageSection(),
                            _buildContentSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut);
  }
}
