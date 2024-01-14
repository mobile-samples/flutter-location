import 'package:flutter/material.dart';

import 'dot_painter.dart';

class DotLoadingIndicator extends StatefulWidget {
  final Color color;

  const DotLoadingIndicator({super.key, required this.color});

  @override
  State<DotLoadingIndicator> createState() => _DotLoadingIndicatorState();
}

class _DotLoadingIndicatorState extends State<DotLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  static const double _minRadius = 10;
  static const double _maxRadius = 20;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..repeat(reverse: true);
    animation =
        Tween<double>(begin: _minRadius, end: _maxRadius).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          size: const Size(2 * _maxRadius, 2 * _maxRadius),
          painter: DotPainter(radius: animation.value, color: widget.color),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
