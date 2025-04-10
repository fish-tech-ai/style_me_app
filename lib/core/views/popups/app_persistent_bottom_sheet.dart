import 'package:flutter/material.dart';
import 'package:style_me/core/views/containers/bottom_sheet_container.dart';

class AppPersistentBottomSheet extends StatefulWidget {
  final Function(ScrollController, DraggableScrollableController) builder;

  const AppPersistentBottomSheet({super.key, required this.builder});

  @override
  State<AppPersistentBottomSheet> createState() =>
      _AppPersistentBottomSheetState();
}

class _AppPersistentBottomSheetState extends State<AppPersistentBottomSheet> {
  final draggableController = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: draggableController,
      initialChildSize: 0.2,
      snap: true,
      minChildSize: 0.2,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            final controller = draggableController;
            controller.jumpTo(controller.size - (details.delta.dy / 800));
          },
          onVerticalDragEnd: (details) {
            final controller = draggableController;
            if (controller.isAttached) {
              final velocity = details.velocity.pixelsPerSecond.dy;

              final targetSize = velocity > 0 ? 0.2 : 1.0;

              controller.animateTo(
                targetSize,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              );
            }
          },
          child: BottomSheetContainer(
            child: widget.builder(scrollController, draggableController),
          ),
        );
      },
    );
  }
}
