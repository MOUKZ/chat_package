import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Styling configuration for [WaveAnimation].
class WaveAnimationStyle {
  /// How many bars to draw.
  final int barCount;

  /// Color of each bar.
  final Color barColor;

  /// Width of each bar.
  final double barWidth;

  /// Spacing between bars.
  final double barSpacing;

  /// Minimum bar height.
  final double minBarHeight;

  /// Maximum bar height.
  final double maxBarHeight;

  /// Border radius for each bar.
  final BorderRadius barBorderRadius;

  const WaveAnimationStyle({
    this.barCount = 5,
    this.barColor = const Color(0xFF075E54),
    this.barWidth = 4.0,
    this.barSpacing = 2.0,
    this.minBarHeight = 8.0,
    this.maxBarHeight = 24.0,
    this.barBorderRadius = const BorderRadius.all(Radius.circular(2)),
  });
}

/// A bar‑wave animation driven by the given [controller].
///
/// The bars oscillate vertically between [style.minBarHeight] and
/// [style.maxBarHeight], phased evenly across [style.barCount].
class WaveAnimation extends StatelessWidget {
  /// The animation controller (from 0.0–1.0) that drives the wave.
  final Animation<double> controller;

  /// Visual styling for the wave.
  final WaveAnimationStyle style;

  const WaveAnimation({
    Key? key,
    required this.controller,
    this.style = const WaveAnimationStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = controller.value * 2 * pi;
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(style.barCount, (i) {
            final phase = t + i * (2 * pi / style.barCount);
            final height = lerpDouble(
              style.minBarHeight,
              style.maxBarHeight,
              (sin(phase) + 1) / 2,
            )!;
            return Container(
              width: style.barWidth,
              height: height,
              margin: EdgeInsets.symmetric(horizontal: style.barSpacing),
              decoration: BoxDecoration(
                color: style.barColor,
                borderRadius: style.barBorderRadius,
              ),
            );
          }),
        );
      },
    );
  }
}
