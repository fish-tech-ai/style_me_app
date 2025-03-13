import 'package:flutter/material.dart';
import 'package:style_me/features/auth/presentation/ui_models/anim_direction_enum.dart';

///Widget allowing animated appearance and disappearance of [child], there are 3 animations on entry/exit:
/// - slide
/// - fade
/// - animated size change
///
/// - [isVisible] - controls visibility
/// - [animateAtFirstBuild] - specifies whether the widget should be animated on first widget build
/// - [padding] - inner animation padding
/// - [reversed] - specifies whether the animation should be reversed based on [animDirection]
/// - [animDirection] - where to where should the [child] be animated from, defaults to [AnimDirectionEnum.rightToLeft]
/// - [size] - it determines hardcoded size of whole [AnimatedVisibility], useful for smoother animations in Stack
class AnimatedVisibility extends StatefulWidget {
  final bool isVisible;
  final bool animateAtFirstBuild;
  final bool reversed;
  final AnimDirectionEnum animDirection;
  final EdgeInsets padding;
  final Duration duration;
  final Size? size;
  final Widget child;

  const AnimatedVisibility({
    super.key,
    required this.child,
    this.isVisible = true,
    this.animateAtFirstBuild = true,
    this.padding = EdgeInsets.zero,
    this.reversed = false,
    this.animDirection = AnimDirectionEnum.rightToLeft,
    this.duration = const Duration(milliseconds: 500),
    this.size,
  });

  @override
  State<AnimatedVisibility> createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _sizeAnimation;
  late bool _isFirstBuild;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.animDirection == AnimDirectionEnum.bottomToTop
          ? Offset(0, widget.reversed ? -1 : 1)
          : Offset(widget.reversed ? -1 : 1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _sizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _isFirstBuild = widget.animateAtFirstBuild;
  }

  @override
  void didUpdateWidget(covariant AnimatedVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isFirstBuild) {
      _isFirstBuild = false;
      _controller.value = widget.isVisible ? 1.0 : 0.0;
      return;
    }

    if (widget.isVisible && !_controller.isAnimating) {
      _controller.forward();
    } else if (!widget.isVisible && !_controller.isAnimating) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: widget.size,
      child: SizeTransition(
        sizeFactor: _sizeAnimation,
        axisAlignment: -1.0,
        child: ClipRect(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: widget.padding,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
