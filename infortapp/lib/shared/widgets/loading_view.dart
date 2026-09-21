import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// A simple shimmer-free skeleton block, used for list-loading placeholders.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, required this.height, this.width});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest
        .withValues(alpha: 0.6);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
