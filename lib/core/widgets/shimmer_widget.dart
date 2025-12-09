import 'package:flutter/material.dart';

/// A lightweight, dependency-free shimmer/skeleton placeholder used across the app.
class ShimmerPlaceholder extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerPlaceholder({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  _ShimmerPlaceholderState createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade300
        : Colors.grey.shade700;
    final highlightColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade100
        : Colors.grey.shade600;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            child: ShaderMask(
              shaderCallback: (rect) {
                final shimmerWidth = rect.width / 2;
                final dx =
                    (rect.width + shimmerWidth) * _controller.value -
                    shimmerWidth;
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [baseColor, highlightColor, baseColor],
                  stops: const [0.0, 0.5, 1.0],
                  transform: _SlidingGradientTransform(dx: dx),
                ).createShader(rect);
              },
              blendMode: BlendMode.srcATop,
              child: Container(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer skeleton that resembles the product card in the UI.
class ShimmerProductCard extends StatelessWidget {
  final double height;

  const ShimmerProductCard({Key? key, this.height = 110}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ShimmerPlaceholder(
            width: 72,
            height: 72,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 12),
          // Middle content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: title + actions + stock badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Expanded(
                      child: ShimmerPlaceholder(
                        width: double.infinity,
                        height: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Edit/Delete action icons
                    Column(
                      children: [
                        ShimmerPlaceholder(
                          width: 20,
                          height: 20,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        const SizedBox(height: 6),
                        ShimmerPlaceholder(
                          width: 20,
                          height: 20,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // Stock badge (e.g., "Low Stock")
                    ShimmerPlaceholder(
                      width: 66,
                      height: 20,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // rating and weight
                Row(
                  children: [
                    ShimmerPlaceholder(width: 60, height: 12),
                    const SizedBox(width: 12),
                    ShimmerPlaceholder(width: 48, height: 12),
                  ],
                ),
                const Spacer(),
                // Bottom row: price (left) and units + quantity bar (right)
                Row(
                  children: [
                    // Price column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerPlaceholder(
                          width: 120,
                          height: 20,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        const SizedBox(height: 8),
                        ShimmerPlaceholder(
                          width: 80,
                          height: 12,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Units + quantity bar block (separated)
          ShimmerUnitsProgress(width: 140),
        ],
      ),
    );
  }
}

/// Shimmer block for units/count + quantity/progress bar (right side of card).
class ShimmerUnitsProgress extends StatelessWidget {
  final double width;

  const ShimmerUnitsProgress({Key? key, this.width = 140}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShimmerPlaceholder(
                width: 18,
                height: 18,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(width: 6),
              ShimmerPlaceholder(width: 72, height: 14),
            ],
          ),
          const SizedBox(height: 8),
          // Quantity/progress bar placeholder (full width of this block)
          ShimmerPlaceholder(
            width: width,
            height: 10,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double dx;

  _SlidingGradientTransform({required this.dx});

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(dx, 0.0, 0.0);
  }
}

/// A simple vertical list skeleton composed of a few placeholders.
class ListShimmerSkeleton extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final bool shrinkWrap;

  const ListShimmerSkeleton({
    Key? key,
    this.itemCount = 3,
    this.itemHeight = 84,
    this.shrinkWrap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If shrinkWrap is true, return a non-scrollable Column so this skeleton
    // can be embedded inside another scrollable (e.g. list footer). Otherwise
    // return a ListView so the skeleton can scroll independently when used
    // as a full-screen loading placeholder.
    if (shrinkWrap) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Row(
              children: [
                ShimmerPlaceholder(
                  width: 84,
                  height: itemHeight,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerPlaceholder(width: double.infinity, height: 16),
                      const SizedBox(height: 8),
                      ShimmerPlaceholder(width: double.infinity, height: 12),
                      const SizedBox(height: 8),
                      ShimmerPlaceholder(width: 100, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            children: [
              Column(
                children: [
                  ShimmerPlaceholder(
                    width: 84,
                    height: itemHeight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder(width: double.infinity, height: 16),
                    const SizedBox(height: 8),
                    ShimmerPlaceholder(width: double.infinity, height: 12),
                    const SizedBox(height: 8),
                    ShimmerPlaceholder(width: 100, height: 12),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
