import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';

class ArrowPainter extends CustomPainter {
  const ArrowPainter({
    this.color = const Color(0xFF161742),
    this.border,
  });

  final Color color;
  final BoxBorder? border;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color // Arrow color
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);

    if (border != null) {
      final borderPaint = Paint()
        ..color = border!.top.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = border!.top.width;

      // Draw the border on the left and right side
      canvas.drawLine(
          Offset(size.width / 2, 0), Offset(0, size.height - 1), borderPaint);
      canvas.drawLine(Offset(size.width / 2, 0),
          Offset(size.width, size.height - 1), borderPaint);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
