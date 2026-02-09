import 'package:flutter/material.dart';

class SliderCircleThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final Color borderColor;
  final Color fillColor;
  final double strokeWidth;

  const SliderCircleThumbShape({
    this.thumbRadius = 6.0,
    this.borderColor = Colors.white,
    required this.fillColor,
    this.strokeWidth = 1,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;

    final fillPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = fillColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius, fillPaint);
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}