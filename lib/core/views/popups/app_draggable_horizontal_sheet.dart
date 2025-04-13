import 'package:flutter/material.dart';
import 'package:style_me/core/views/containers/bottom_sheet_container_horizontal.dart';
//TODO should replace app_persistent_bottom_sheet
class AppDraggableHorizontalSheet extends StatefulWidget {
  final Widget child;
  final double minWidth;
  final double maxWidth;

  const AppDraggableHorizontalSheet({
    super.key,
    required this.child,
    this.minWidth = 50.0,
    this.maxWidth = 200.0,
  });

  @override
  State<AppDraggableHorizontalSheet> createState() =>
      _AppDraggableHorizontalSheetState();
}

class _AppDraggableHorizontalSheetState
    extends State<AppDraggableHorizontalSheet> {
  double sheetWidth = 50.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            sheetWidth = (sheetWidth + details.delta.dx)
                .clamp(widget.minWidth, widget.maxWidth);
          });
        },
        onHorizontalDragEnd: (details) {
          final velocity = details.velocity.pixelsPerSecond.dx;
          final targetSize = velocity > 0 ? widget.maxWidth : widget.minWidth;
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
}
