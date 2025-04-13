import 'package:flutter/material.dart';
import 'package:style_me/core/views/containers/bottom_sheet_container.dart';

class AppPersistentBottomSheet extends StatefulWidget {
  final Function(
    ScrollController scrollController,
    DraggableScrollableController draggableController,
  ) builder;

  const AppPersistentBottomSheet({super.key, required this.builder});

  @override
  State<AppPersistentBottomSheet> createState() =>
      _AppPersistentBottomSheetState();
}

class _AppPersistentBottomSheetState extends State<AppPersistentBottomSheet> {
  final draggableController = DraggableScrollableController();
  final double minChildSize = 0.11;
  final double maxChildSize = 1.0;
  double? initHeight;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DraggableScrollableSheet(
        controller: draggableController,
        initialChildSize: minChildSize,
        snap: true,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: (context, scrollController) {
          return LayoutBuilder(builder: (context, constraints) {
            return GestureDetector(
              onVerticalDragUpdate: (details) {
                final controller = draggableController;
                controller.jumpTo(controller.size - (details.delta.dy / 800));
              },
              onVerticalDragEnd: (details) {
                final controller = draggableController;
                if (controller.isAttached) {
                  final velocity = details.velocity.pixelsPerSecond.dy;

                  final targetSize = velocity > 0 ? minChildSize : maxChildSize;

                  controller.animateTo(
                    targetSize,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );
                }
              },
              child: BottomSheetContainer(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: constraints.maxHeight - 20,
                    child: widget.builder(
                        scrollController, draggableController),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
