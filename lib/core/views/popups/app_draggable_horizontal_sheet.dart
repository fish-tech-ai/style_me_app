import 'package:flutter/material.dart';
import 'package:style_me/core/views/containers/bottom_sheet_container_horizontal.dart';
import 'package:style_me/core/views/ui_models/limit.dart';

class AppDraggableHorizontalSheet extends StatefulWidget {
  final Widget child;
  final double minWidth;
  final double maxWidth;

  const AppDraggableHorizontalSheet({
    super.key,
    required this.child,
    this.minWidth = 30.0,
    this.maxWidth = 200.0,
  });

  @override
  State<AppDraggableHorizontalSheet> createState() =>
      AppDraggableHorizontalSheetState();
}

class AppDraggableHorizontalSheetState
    extends State<AppDraggableHorizontalSheet> {
  late double sheetWidth;

  @override
  void initState() {
    super.initState();
    sheetWidth = widget.minWidth;
  }

  void animateTo(Limit limit) {
    setState(() {
      sheetWidth = limit == Limit.min ? widget.minWidth : widget.maxWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            sheetWidth = (sheetWidth - details.delta.dx)
                .clamp(widget.minWidth, widget.maxWidth);
          });
        },
        onHorizontalDragEnd: (details) {
          final velocity = details.velocity.pixelsPerSecond.dx;
          final targetSize = velocity == 0 ? getClosestMinMaxWidth() : velocity < 0
              ? widget.maxWidth
              : widget.minWidth;
          setState(() {
            sheetWidth = targetSize;
          });
        },
        child: Center(
          child: IntrinsicHeight(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              curve: Curves.easeOut,
              width: sheetWidth,
              child: BottomSheetContainerHorizontal(
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double getClosestMinMaxWidth() {
    final midpoint = (widget.minWidth + widget.maxWidth) / 2;
    return (sheetWidth < midpoint) ? widget.minWidth : widget.maxWidth;
  }
}