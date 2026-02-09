import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../common_widgets/gradient_button.dart';

enum LoadingState { bottomLoader, progressLoader }

class RotationTransitionWidget extends StatefulWidget {
  final LoadingState loadingState;
  final AppButtonTheme buttonTheme;
  final Alignment alignment;

  const RotationTransitionWidget({
    Key? key,
    required this.loadingState,
    this.buttonTheme = AppButtonTheme.dark,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  State<RotationTransitionWidget> createState() =>
      _RotationTransitionWidgetState(
          loadingState: loadingState, buttonTheme: buttonTheme);
}

class _RotationTransitionWidgetState extends State<RotationTransitionWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat();
  final LoadingState loadingState;
  final AppButtonTheme buttonTheme;

  final Tween<double> turnsTween = Tween<double>(
    begin: 0,
    end: 1,
  );

  _RotationTransitionWidgetState({
    required this.loadingState,
    this.buttonTheme = AppButtonTheme.dark,
  });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: RotationTransition(
        turns: turnsTween.animate(_controller),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: loaderState(loadingState, buttonTheme: buttonTheme)),
      ),
    );
  }

  loaderState(LoadingState loadingState,
      {required AppButtonTheme buttonTheme}) {
    switch (loadingState) {
      case LoadingState.bottomLoader:
        return const CircularProgressIndicator(
          color: darkBlueColor,
          strokeWidth: 3,
          backgroundColor: Color(0xFFe8edf4),
        );
      case LoadingState.progressLoader:
        return _GradientCircularProgressIndicator(
          radius: 50,
          gradientColors: buttonTheme == AppButtonTheme.dark
              ? gradientColors()
              : bottomLightColors(),
          strokeWidth: 10,
          buttonTheme: buttonTheme,
        );
    }
  }

  List<Color> gradientColors() {
    return const [
      Color(0xff149B3B),
      Color(0xff004097),
      Color(0xff149B3B),
    ];
  }

  List<Color> bottomLightColors() {
    return const [
      Color(0xffffffff),
      Color(0xffffffff),
    ];
  }
}

class _GradientCircularProgressIndicator extends StatelessWidget {
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;
  final AppButtonTheme buttonTheme;

  const _GradientCircularProgressIndicator({
    Key? key,
    required this.radius,
    required this.gradientColors,
    this.strokeWidth = 10.0,
    this.buttonTheme = AppButtonTheme.dark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius),
      painter: _GradientCircularProgressPainter(
        radius: radius,
        gradientColors: gradientColors,
        strokeWidth: strokeWidth,
        buttonTheme: buttonTheme,
      ),
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  _GradientCircularProgressPainter({
    required this.radius,
    required this.gradientColors,
    required this.strokeWidth,
    this.buttonTheme,
  });

  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;
  AppButtonTheme? buttonTheme;

  @override
  void paint(Canvas canvas, Size size) {
    size = Size.fromRadius(radius);
    double offset = strokeWidth / 2;
    Rect rect = Offset(offset, offset) &
        Size(size.width - strokeWidth, size.height - strokeWidth);
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    paint.shader = SweepGradient(
            colors: buttonTheme == AppButtonTheme.dark
                ? [const Color(0xffE7F4EC), const Color(0xffE7F4EC)]
                : [const Color(0xFF35599a), const Color(0xFF35599a)],
            startAngle: pollingDefaultAngle(),
            endAngle: sweepFullAngle())
        .createShader(rect);
    canvas.drawArc(rect, pollingDefaultAngle(), sweepFullAngle(), false, paint);
    paint.shader = SweepGradient(
            colors: gradientColors,
            startAngle: 0.0,
            endAngle: pollingDefaultAngle())
        .createShader(rect);
    canvas.drawArc(rect, 0.0, pollingDefaultAngle(), false, paint);
  }

  double sweepFullAngle() => 2 * pi;

  double pollingDefaultAngle() => 1.8 * pi;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
