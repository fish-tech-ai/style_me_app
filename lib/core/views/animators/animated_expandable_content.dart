import 'package:flutter/material.dart';

class AnimatedExpandableContent extends StatefulWidget {
  final bool isExpanded;
  final List<Widget> children;
  final Widget header;
  final double spacing;
  final Duration duration;

  const AnimatedExpandableContent({
    super.key,
    required this.isExpanded,
    required this.children,
    required this.header,
    this.spacing = 0,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedExpandableContent> createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<AnimatedExpandableContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedExpandableContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpanded != widget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: widget.spacing,
      children: [
        widget.header,
        SizeTransition(
          sizeFactor: _heightFactor,
          axisAlignment: -1.0,
          child: Column(
            spacing: widget.spacing,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
