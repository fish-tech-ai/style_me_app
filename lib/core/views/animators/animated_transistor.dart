import 'package:flutter/material.dart';
import 'package:style_me/core/utils/show_enum.dart';

class AnimatedTransistor extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final Duration duration;
  final Show show;

  const AnimatedTransistor({
    super.key,
    required this.firstChild,
    required this.secondChild,
    required this.show,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedTransistor> createState() => _AnimatedTransistorState();
}

class _AnimatedTransistorState extends State<AnimatedTransistor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideOutAnimation;
  late Animation<double> _fadeOutAnimation;
  late Animation<Offset> _slideInAnimation;
  late Animation<double> _fadeInAnimation;

  Show _previousShow = Show.first;

  @override
  void initState() {
    super.initState();
    _previousShow = widget.show;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _setupAnimations();
  }

  void _setupAnimations() {
    _slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideInAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(AnimatedTransistor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != _previousShow) {
      widget.show == Show.second ? _controller.forward() : _controller.reverse();
      _previousShow = widget.show;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeOutAnimation,
              child: SlideTransition(
                position: _slideOutAnimation,
                child: child,
              ),
            );
          },
          child: widget.firstChild,
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeInAnimation,
              child: SlideTransition(
                position: _slideInAnimation,
                child: child,
              ),
            );
          },
          child: widget.secondChild,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
