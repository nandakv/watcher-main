import 'package:flutter/material.dart';

class SliderRectThumbShape extends SliderComponentShape {
  final double thumbWidth;
  final double thumbHeight;
  final Color borderColor;
  final Color fillColor;
  final double strokeWidth;
  final double borderRadius;

  const SliderRectThumbShape({
    this.thumbWidth = 12.0,
    this.thumbHeight = 6.0,
    this.borderColor = Colors.white,
    required this.fillColor,
    this.strokeWidth = 1,
    this.borderRadius = 4.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbWidth, thumbHeight);
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
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Define the bounds for the rectangle
    final Rect thumbRect = Rect.fromCenter(
      center: center,
      width: thumbWidth,
      height: thumbHeight,
    );

    // Define the rounded rectangle with border radius
    final RRect thumbRRect = RRect.fromRectAndRadius(
      thumbRect,
      Radius.circular(borderRadius),
    );

    // Draw the fill of the rectangle with rounded corners
    canvas.drawRRect(thumbRRect, fillPaint);
    // Draw the border of the rectangle with rounded corners
    canvas.drawRRect(thumbRRect, borderPaint);
  }
}
