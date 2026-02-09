import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLottieWidget extends StatefulWidget {
  const AppLottieWidget(
      {Key? key,
      required this.assetPath,
      this.repeatCount = 0,
      this.boxFit,
      this.height,
      this.width})
      : super(key: key);

  final String assetPath;
  final int repeatCount;
  final double? width;
  final double? height;
  final BoxFit? boxFit;

  @override
  State<AppLottieWidget> createState() => _AppLottieWidgetState();
}

class _AppLottieWidgetState extends State<AppLottieWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  int _count = 0;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    _animationController.addStatusListener(_statusListener);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.assetPath,
      fit: widget.boxFit,
      height: widget.height,
      width: widget.width,
      controller: _animationController,
      onLoaded: _onLoaded,
    );
  }

  void _onLoaded(LottieComposition composition) {
    _animationController.duration = composition.duration;
    _animationController.forward();
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (widget.repeatCount == 0) {
        _animationController.reset();
        _animationController.forward();
      } else {
        _count = _count + 1;
        if (_count < widget.repeatCount) {
          _animationController.reset();
          _animationController.forward();
        }
      }
    }
  }
}
