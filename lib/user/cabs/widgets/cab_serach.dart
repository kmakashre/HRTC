import 'package:flutter/material.dart';
import 'package:hrtc/core/utils/colors.dart';
import 'package:hrtc/core/utils/sizes.dart';

class CabSearchBar extends StatefulWidget {
  final String hintText;
  final String initialValue;
  final Function(String) onChanged;
  final Function()? onSearch;
  final Function()? onClear;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool showClearButton;
  final bool enabled;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const CabSearchBar({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.initialValue = '',
    this.onSearch,
    this.onClear,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = true,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.autofocus = false,
    this.focusNode,
    this.controller,
    required IconData icon,
  }) : super(key: key);

  @override
  State<CabSearchBar> createState() => _CabSearchBarState();
}

class _CabSearchBarState extends State<CabSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _hasText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    // Initialize controller
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _hasText = _controller.text.isNotEmpty;

    // Initialize focus node
    _focusNode = widget.focusNode ?? FocusNode();

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Add listeners
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);

    // Only dispose if we created them
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    _animationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged(_controller.text);
  }

  void _onFocusChanged() {
    final isFocused = _focusNode.hasFocus;
    if (isFocused != _isFocused) {
      setState(() {
        _isFocused = isFocused;
      });

      if (isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _onClearPressed() {
    _controller.clear();
    widget.onChanged('');
    if (widget.onClear != null) {
      widget.onClear!();
    }
    _focusNode.requestFocus();
  }

  void _onSearchPressed() {
    if (widget.onSearch != null) {
      widget.onSearch!();
    }
    _focusNode.unfocus();
  }

  Widget _buildPrefixIcon() {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 8),
      child: Icon(
        widget.prefixIcon ?? Icons.search,
        color:
            _isFocused
                ? AppColors.CabsAccent
                : AppColors.CabsAccent.withOpacity(0.6),
        size: AppSizes.iconMedium,
      ),
    );
  }

  Widget _buildSuffixActions() {
    List<Widget> actions = [];

    // Clear button
    if (widget.showClearButton && _hasText) {
      actions.add(
        GestureDetector(
          onTap: _onClearPressed,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.CabsAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.CabsAccent,
              size: 16,
            ),
          ),
        ),
      );
    }

    // Search button or custom suffix icon
    if (widget.onSearch != null || widget.suffixIcon != null) {
      if (actions.isNotEmpty) {
        actions.add(const SizedBox(width: 8));
      }

      actions.add(
        GestureDetector(
          onTap: widget.onSearch ?? () {},
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  _hasText
                      ? AppColors.CabsAccent
                      : AppColors.CabsAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.suffixIcon ?? Icons.search,
              color:
                  _hasText
                      ? Colors.white
                      : AppColors.CabsAccent.withOpacity(0.7),
              size: 18,
            ),
          ),
        ),
      );
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Row(mainAxisSize: MainAxisSize.min, children: actions),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppSizes.radiusMedium,
              boxShadow:
                  _isFocused
                      ? [
                        BoxShadow(
                          color: AppColors.CabsAccent.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
            ),
            child: TextField(
              cursorColor: AppColors.CabsAccent,
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              keyboardType: widget.keyboardType,
              textCapitalization: widget.textCapitalization,
              maxLength: widget.maxLength,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _onSearchPressed(),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppSizes.bodyMedium.copyWith(
                  color: AppColors.textLight,
                ),
                filled: true,
                fillColor:
                    widget.enabled
                        ? AppColors.cardBackground
                        : AppColors.cardBackground.withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: AppSizes.radiusMedium,
                  borderSide: BorderSide(
                    color: AppColors.CabsAccent.withOpacity(0.3),
                    width: AppSizes.borderThin,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppSizes.radiusMedium,
                  borderSide: BorderSide(
                    color: AppColors.CabsAccent.withOpacity(0.3),
                    width: AppSizes.borderThin,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppSizes.radiusMedium,
                  borderSide: BorderSide(
                    color: AppColors.CabsAccent,
                    width: AppSizes.borderMedium,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: AppSizes.radiusMedium,
                  borderSide: BorderSide(
                    color: AppColors.CabsAccent.withOpacity(0.1),
                    width: AppSizes.borderThin,
                  ),
                ),
                prefixIcon: _buildPrefixIcon(),
                suffixIcon: _buildSuffixActions(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                counterText: '', // Hide character counter
              ),
              style: AppSizes.bodyMedium.copyWith(
                color:
                    widget.enabled
                        ? AppColors.textPrimary
                        : AppColors.textLight,
              ),
            ),
          ),
        );
      },
    );
  }
}
