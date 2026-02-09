import 'dart:async';
import 'package:flutter/material.dart';
import 'package:privo/components/svg_icon.dart';
import '../../res.dart';
import '../theme/app_colors.dart';
import '../utils/app_text_styles.dart';

enum SlideStatus {
  initial,
  sliding,
  loading,
  completed,
  viewInsights,
}

// Controller for the SlidingButton
class SlidingButtonController {
  VoidCallback? _markAsCompletedAction;
  VoidCallback? _resetAction;

  void _attachActions({
    required VoidCallback markAsCompleted,
    required VoidCallback reset,
  }) {
    _markAsCompletedAction = markAsCompleted;
    _resetAction = reset;
  }

  void _detachActions() {
    _markAsCompletedAction = null;
    _resetAction = null;
  }

  void markAsCompleted() {
    _markAsCompletedAction?.call();
  }

  void reset() {
    _resetAction?.call();
  }
}

// The main SlidingButton widget
class SlidingButton extends StatefulWidget {
  final double height;
  final double width;
  final VoidCallback onSlideToLoadTriggered;
  final Color initialColor;
  final Color slidingColorStart;
  final Color slidingColorEnd;
  final Color loadingColor;
  final Color completedColor;
  final Color viewInsightsBackgroundColor;
  final Duration animationDuration;
  final Duration textAnimationDuration;
  final SlidingButtonController? controller;
  final double textTransitionThreshold;
  final VoidCallback onTapViewInsights;
  final Duration viewInsightsDelay;
  final SlideStatus? status;

  const SlidingButton({
    super.key,
    this.height = 60.0,
    required this.width,
    required this.onSlideToLoadTriggered,
    this.controller,
    this.initialColor = blue1600,
    this.slidingColorStart = blue1600,
    this.slidingColorEnd = green100,
    this.loadingColor = green100,
    this.completedColor = green600,
    this.viewInsightsBackgroundColor = blue1600,
    this.animationDuration = const Duration(milliseconds: 300),
    this.textAnimationDuration = const Duration(milliseconds: 300),
    this.textTransitionThreshold = 0.50,
    required this.onTapViewInsights,
    this.viewInsightsDelay = const Duration(seconds: 3),
    this.status,
  });

  @override
  State<SlidingButton> createState() => _SlidingButtonState();
}

class _SlidingButtonState extends State<SlidingButton>
    with SingleTickerProviderStateMixin {
  // Changed back to SingleTickerProviderStateMixin
  late AnimationController _animationController;

  double _slidePercent = 0.0;
  SlideStatus _status = SlideStatus.initial;
  String _text = "Slide to refresh";
  bool _isIconOnLeft = true;
  bool _isLocked = false;
  Timer? _viewInsightsTimer;

  @override
  void initState() {
    super.initState();
    if (widget.status != null) {
      _status = widget.status!;
    }
    _initializeControllers();
  }

  _initializeControllers() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animationController.addListener(() {
      if (_animationController.isAnimating) {
        if (mounted) {
          setState(() {
            _slidePercent = _animationController.value;
          });
        }
      }
    });

    widget.controller?._attachActions(
      markAsCompleted: _markAsCompletedInternal,
      reset: _resetInternal,
    );
  }

  Color get _backgroundColor {
    switch (_status) {
      case SlideStatus.initial:
        return widget.initialColor;
      case SlideStatus.sliding:
        return Color.lerp(widget.slidingColorStart, widget.slidingColorEnd,
            _slidePercent.clamp(0.0, 1.0))!;
      case SlideStatus.loading:
        return widget.loadingColor;
      case SlideStatus.completed:
        return widget.completedColor;
      case SlideStatus.viewInsights:
        return widget.viewInsightsBackgroundColor;
      default:
        return widget.initialColor;
    }
  }

  Widget get _currentIconWidget {
    String svgIcon = "";
    if (_status == SlideStatus.completed) {
      svgIcon = Res.creditScoreSlideRefreshedThumbSVG;
    } else if (_status == SlideStatus.loading) {
      svgIcon = Res.creditScoreSlideRefreshingThumbSVG;
    } else {
      svgIcon = Res.creditScoreSlideInitialThumbSVG;
    }
    return SVGIcon(size: SVGIconSize.large, icon: svgIcon);
  }

  Color get _textColor {
    String currentTextForColorLogic = _text;

    if (_status == SlideStatus.sliding) {
      if (_slidePercent >= widget.textTransitionThreshold) {
        currentTextForColorLogic = "Refreshing...";
      } else {
        currentTextForColorLogic = "Slide to refresh";
      }
    } else if (_status == SlideStatus.viewInsights) {
      currentTextForColorLogic = "View Insights";
    }

    if (currentTextForColorLogic == "Slide to refresh" ||
        currentTextForColorLogic == "Refreshed" ||
        currentTextForColorLogic == "View Insights") {
      return Colors.white;
    } else if (currentTextForColorLogic == "Refreshing...") {
      return green400;
    }
    return Colors.white;
  }

  void _onDragStart(DragStartDetails details) {
    if (_isLocked ||
        (_status != SlideStatus.initial && _status != SlideStatus.sliding)) {
      return;
    }
    _animationController.stop();
    if (mounted) {
      setState(() {
        _status = SlideStatus.sliding;
      });
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isLocked || _status != SlideStatus.sliding) return;
    if (mounted) {
      setState(() {
        final thumbEffectiveSize = widget.height;
        final draggableWidth = widget.width - thumbEffectiveSize;
        if (draggableWidth <= 0) return;
        _slidePercent += details.delta.dx / draggableWidth;
        _slidePercent = _slidePercent.clamp(0.0, 1.0);
        _animationController.value = _slidePercent;
      });
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isLocked || _status != SlideStatus.sliding) return;

    final slideThreshold = 0.75;
    if (_slidePercent >= slideThreshold) {
      _animationController.animateTo(1.0, curve: Curves.easeOut).then((_) {
        if (mounted) {
          _startLoadingInternal();
        }
      });
    } else {
      _animationController.animateTo(0.0, curve: Curves.easeOut).then((_) {
        if (mounted) {
          setState(() {
            _status = SlideStatus.initial;
            _text = "Slide to refresh";
            _isIconOnLeft = true;
          });
        }
      });
    }
  }

  void _startLoadingInternal() {
    if (!mounted) return;
    setState(() {
      _status = SlideStatus.loading;
      _text = "Refreshing...";
      _isIconOnLeft = false;
      _slidePercent = 1.0;
      _animationController.value = 1.0;
      _isLocked = true;
    });
    widget.onSlideToLoadTriggered();
  }

  void _markAsCompletedInternal() {
    if (!mounted || _status != SlideStatus.loading) return;
    setState(() {
      _status = SlideStatus.completed;
      _text = "Refreshed";
    });

    _viewInsightsTimer?.cancel();
    _viewInsightsTimer = Timer(widget.viewInsightsDelay, () {
      if (mounted && _status == SlideStatus.completed) {
        setState(() {
          _status = SlideStatus.viewInsights;
          _text = "View Insights";
        });
      }
    });
  }

  void _resetInternal() {
    if (!mounted) return;
    _viewInsightsTimer?.cancel();
    _animationController.reset();
    setState(() {
      _slidePercent = 0.0;
      _status = SlideStatus.initial;
      _text = "Slide to refresh";
      _isIconOnLeft = true;
      _isLocked = false;
    });
  }

  @override
  void dispose() {
    _viewInsightsTimer?.cancel();
    widget.controller?._detachActions();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumbSize = widget.height * 0.75;
    final thumbPadding = (widget.height - thumbSize) / 2;
    final maxSlideDistance = widget.width - thumbSize - (thumbPadding * 2);

    String animatedSwitcherText = _text;
    if (_status == SlideStatus.sliding) {
      if (_slidePercent >= widget.textTransitionThreshold) {
        animatedSwitcherText = "Refreshing...";
      } else {
        animatedSwitcherText = "Slide to refresh";
      }
    } else if (_status == SlideStatus.viewInsights) {
      animatedSwitcherText = "View Insights";
    } else {
      animatedSwitcherText = _text;
    }

    return GestureDetector(
      onHorizontalDragStart: _isLocked && _status != SlideStatus.viewInsights
          ? null
          : _onDragStart,
      onHorizontalDragUpdate: _isLocked && _status != SlideStatus.viewInsights
          ? null
          : _onDragUpdate,
      onHorizontalDragEnd:
          _isLocked && _status != SlideStatus.viewInsights ? null : _onDragEnd,
      onTap: _status == SlideStatus.viewInsights
          ? () {
              widget.onTapViewInsights();
            }
          : null,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final currentSlidePx = _slidePercent * maxSlideDistance;
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: widget.textAnimationDuration,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Text(
                        animatedSwitcherText,
                        key: ValueKey<String>(animatedSwitcherText),
                        style: AppTextStyles.bodyLSemiBold(color: _textColor),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                if (_status != SlideStatus.viewInsights)
                  Positioned(
                    left:
                        _isIconOnLeft ? (thumbPadding + currentSlidePx) : null,
                    right: !_isIconOnLeft
                        ? (thumbPadding +
                            (maxSlideDistance - currentSlidePx)
                                .clamp(0.0, maxSlideDistance))
                        : null,
                    top: thumbPadding,
                    bottom: thumbPadding,
                    child: SizedBox(
                      width: thumbSize,
                      height: thumbSize,
                      child: Center(child: _currentIconWidget),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
