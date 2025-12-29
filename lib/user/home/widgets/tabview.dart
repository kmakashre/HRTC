import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrtc/core/utils/colors.dart';

// Lazy Loading Tab View Widget
class LazyTabView extends StatefulWidget {
  final List<Widget> children;
  final TabController controller;
  final bool keepAlive;

  const LazyTabView({
    Key? key,
    required this.children,
    required this.controller,
    this.keepAlive = true,
  }) : super(key: key);

  @override
  State<LazyTabView> createState() => _LazyTabViewState();
}

class _LazyTabViewState extends State<LazyTabView> {
  late List<bool> _loadedTabs;

  @override
  void initState() {
    super.initState();
    _loadedTabs = List.generate(widget.children.length, (index) => index == 0);
    widget.controller.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!widget.controller.indexIsChanging) {
      final index = widget.controller.index;
      if (index < _loadedTabs.length && !_loadedTabs[index]) {
        setState(() {
          _loadedTabs[index] = true;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.controller,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        widget.children.length,
        (index) =>
            _loadedTabs[index]
                ? (widget.keepAlive
                    ? _KeepAliveWrapper(child: widget.children[index])
                    : widget.children[index])
                : const _LoadingPlaceholder(),
      ),
    );
  }
}

// Keep Alive Wrapper for Tab Content
class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

// Loading Placeholder
class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.hrtcAccent),
    );
  }
}

// Optimized List Builder with caching
class OptimizedListBuilder extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;
  final bool shrinkWrap;

  const OptimizedListBuilder({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return RepaintBoundary(child: itemBuilder(context, index));
      },
      scrollDirection: scrollDirection,
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      cacheExtent: 250.0, // Optimize cache extent
    );
  }
}

// Debounced Gesture Detector
class DebouncedGestureDetector extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Duration debounceDuration;

  const DebouncedGestureDetector({
    Key? key,
    this.onTap,
    required this.child,
    this.debounceDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<DebouncedGestureDetector> createState() =>
      _DebouncedGestureDetectorState();
}

class _DebouncedGestureDetectorState extends State<DebouncedGestureDetector> {
  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final now = DateTime.now();
        if (_lastTapTime == null ||
            now.difference(_lastTapTime!) > widget.debounceDuration) {
          _lastTapTime = now;
          widget.onTap?.call();
        }
      },
      child: widget.child,
    );
  }
}

// Memory Efficient Image Widget
class MemoryEfficientImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const MemoryEfficientImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: width?.round(),
        cacheHeight: height?.round(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? const CircularProgressIndicator();
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? const Icon(Icons.error);
        },
      ),
    );
  }
}

// Performance monitoring provider
class PerformanceMonitor {
  static const String _tag = 'PerformanceMonitor';

  static void logBuildTime(String widgetName, VoidCallback buildFunction) {
    final stopwatch = Stopwatch()..start();
    buildFunction();
    stopwatch.stop();

    if (stopwatch.elapsedMilliseconds > 16) {
      // 16ms = 60 FPS
      debugPrint(
        '$_tag: $widgetName build took ${stopwatch.elapsedMilliseconds}ms',
      );
    }
  }

  static void logMemoryUsage(String location) {
    // This would require additional packages like flutter_memory_info
    // For now, just log the location
    debugPrint('$_tag: Memory check at $location');
  }
}

// Widget build time tracker
class BuildTimeTracker extends StatelessWidget {
  final String widgetName;
  final Widget child;

  const BuildTimeTracker({
    Key? key,
    required this.widgetName,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Builder(
        builder: (context) {
          final stopwatch = Stopwatch()..start();
          final result = child;
          stopwatch.stop();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (stopwatch.elapsedMilliseconds > 16) {
              debugPrint(
                'BuildTimeTracker: $widgetName took ${stopwatch.elapsedMilliseconds}ms',
              );
            }
          });

          return result;
        },
      ),
    );
  }
}

// Optimized Consumer Widget
class OptimizedConsumer<T> extends ConsumerWidget {
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final ProviderListenable<T> provider;
  final Widget? child;
  final bool Function(T previous, T current)? shouldRebuild;

  const OptimizedConsumer({
    Key? key,
    required this.builder,
    required this.provider,
    this.child,
    this.shouldRebuild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);

    return RepaintBoundary(child: builder(context, value, child));
  }
}
