import 'package:flutter/material.dart';
import 'package:style_me/core/views/containers/bottom_sheet_container.dart';
import 'package:style_me/core/views/ui_models/limit.dart';

class AppPersistentBottomSheet extends StatefulWidget {
  final Function(ScrollController scrollController) builder;
  final Function()? onCollapse;
  final Function()? onExpand;

  const AppPersistentBottomSheet(
      {super.key, required this.builder, this.onCollapse, this.onExpand});

  @override
  State<AppPersistentBottomSheet> createState() =>
      AppPersistentBottomSheetState();
}

class AppPersistentBottomSheetState extends State<AppPersistentBottomSheet> {
  late final DraggableScrollableController draggableController;
  final double minChildSize = 0.11;
  final double maxChildSize = 1.0;
  double? initHeight;

  @override
  void initState() {
    super.initState();
    draggableController = DraggableScrollableController();
    draggableController.addListener(() {
      const double tolerance = 0.001;
      final bool isCollapsed = (draggableController.size - minChildSize).abs() < tolerance;
      if (isCollapsed) {
        widget.onCollapse?.call();
      } else {
        widget.onExpand?.call();
      }
    });
  }

  void animateTo(Limit limit) {
    draggableController.animateTo(
      limit == Limit.min ? minChildSize : maxChildSize,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

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
                if (draggableController.isAttached) {
                  draggableController.jumpTo(
                      draggableController.size - (details.delta.dy / 800));
                }
              },
              onVerticalDragEnd: (details) {
                if (draggableController.isAttached) {
                  continueExpandCollapseToLimit(details);
                }
              },
              child: BottomSheetContainer(
                shouldAlignBottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: constraints.maxHeight - 20,
                    child: widget.builder(scrollController),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  void continueExpandCollapseToLimit(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;

    final targetSize = velocity > 0 ? minChildSize : maxChildSize;

    draggableController.animateTo(
      targetSize,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }
}
