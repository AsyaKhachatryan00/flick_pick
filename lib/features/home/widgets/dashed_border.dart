import 'package:flutter/material.dart';

class DashedGradientBorder extends StatelessWidget {
  const DashedGradientBorder({
    super.key,
    required this.child,
    required this.gradient,
    this.radius = 24.0,
    this.strokeWidth = 2.0,
    this.dash = 10.0,
    this.gap = 6.0,
  });

  final Widget child;
  final Gradient gradient;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final rect = Offset.zero & Size(c.maxWidth, c.maxHeight);
        return CustomPaint(
          painter: _DashedGradientBorderPainter(
            shader: gradient.createShader(rect),
            radius: radius,
            strokeWidth: strokeWidth,
            dash: dash,
            gap: gap,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: child,
          ),
        );
      },
    );
  }
}

class _DashedGradientBorderPainter extends CustomPainter {
  _DashedGradientBorderPainter({
    required this.shader,
    required this.radius,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
  });

  final Shader shader;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double d = 0.0;
      while (d < metric.length) {
        final next = (d + dash).clamp(0.0, metric.length);
        final segment = metric.extractPath(d, next);
        canvas.drawPath(segment, paint);
        d = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedGradientBorderPainter old) =>
      old.shader != shader ||
      old.radius != radius ||
      old.strokeWidth != strokeWidth ||
      old.dash != dash ||
      old.gap != gap;
}
