import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/views/buttons/floating/add_photo_menu_button.dart';

class PageWithFloatingAddButton extends StatefulWidget {
  final Function() addClothingClicked;
  final Function() addUserPhotoClicked;
  final EdgeInsets margin;
  final Widget child;

  const PageWithFloatingAddButton({
    super.key,
    required this.child,
    required this.addClothingClicked,
    required this.addUserPhotoClicked,
    this.margin = const EdgeInsets.all(24),
  });

  @override
  State<PageWithFloatingAddButton> createState() =>
      _PageWithFloatingAddButtonState();
}

class _PageWithFloatingAddButtonState extends State<PageWithFloatingAddButton> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        if (isExpanded)
          Positioned.fill(
            child: Container(
              color: context.customColors.backgroundA85,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: hideButtons,
              ),
            ),
          ),
        Builder(builder: (context) {
          return Positioned(
            right: widget.margin.right,
            bottom: widget.margin.bottom,
            child: AddPhotoMenuButton(
              isExpanded: isExpanded,
              onClicked: toggleButtons,
              addClothingClicked: widget.addClothingClicked,
              addUserPhotoClicked: widget.addUserPhotoClicked,
            ),
          );
        }),
      ],
    );
  }

  void hideButtons() {
    setState(() {
      isExpanded = false;
    });
  }

  void toggleButtons() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }
}
