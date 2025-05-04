import 'package:flutter/material.dart';
import 'package:style_me/core/views/containers/bottom_sheet_container.dart';

class AppDraggableVerticalSheet extends StatefulWidget {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  const AppDraggableVerticalSheet({
    super.key,
    required this.child,
    this.minHeight = 100.0,
    this.maxHeight = 800.0,
  });

  @override
  State<AppDraggableVerticalSheet> createState() =>
      _AppDraggableHorizontalSheetState();
}

class _AppDraggableHorizontalSheetState
    extends State<AppDraggableVerticalSheet> {
  double sheetHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            sheetHeight = (sheetHeight - details.delta.dy)
                .clamp(widget.minHeight, widget.maxHeight);
          });
        },
        onVerticalDragEnd: (details) {
          final velocity = details.velocity.pixelsPerSecond.dy;
          final targetSize = velocity > 0 ? widget.minHeight : widget.maxHeight;
          setState(() {
            sheetHeight = targetSize;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut,
          height: sheetHeight,
          width: 500,
          child: BottomSheetContainer(child: widget.child),
        ),
      ),
    );
  }
}
