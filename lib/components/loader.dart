import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';

enum LoaderSize {
  xs(16.0, 1),
  s(24, 2),
  m(32.0, 3.0),
  l(40.0, 4.0),
  xl(48, 5);

  final double size;
  final double strokeWidth;

  const LoaderSize(this.size, this.strokeWidth);
}

class Loader extends StatefulWidget {
  final LoaderSize progressVariants;

  Loader({required this.progressVariants});

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duration for full rotation
      vsync: this,
    )..repeat(); // Repeats the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: SizedBox(
        width: widget.progressVariants.size,
        height: widget.progressVariants.size,
        child: RotationTransition(
          turns: _controller, // This drives the rotation
          child: CircularProgressIndicator(
            strokeWidth: widget.progressVariants.strokeWidth,
            valueColor: const AlwaysStoppedAnimation<Color>(darkBlueColor),
            backgroundColor: darkBlueColor.withOpacity(0.1),
            value: .75,
          ),
        ),
      ),
    );
  }
}
