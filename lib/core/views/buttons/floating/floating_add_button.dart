import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/views/animators/animated_visibility.dart';
import 'package:style_me/core/views/buttons/app_icon_button.dart';
import 'package:style_me/core/views/buttons/floating/floating_add_clothing_button.dart';
import 'package:style_me/core/views/buttons/floating/floating_add_user_photo_button.dart';
import 'package:style_me/features/auth/presentation/ui_models/anim_direction_enum.dart';

class PageWithFloatingAddButton extends StatefulWidget {
  final Widget child;

  const PageWithFloatingAddButton({super.key, required this.child});

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
            right: 24,
            bottom: 24,
            child: Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedVisibility(
                  isVisible: isExpanded,
                  animDirection: AnimDirectionEnum.bottomToTop,
                  duration: Duration(milliseconds: 300),
                  child: _buildExpandableButtons(),
                ),
                AppIconButton(
                  onClick: toggleButtons,
                  padding: EdgeInsets.all(14),
                  icon: Icon(Icons.add_rounded),
                  elevation: 4,
                ),
              ],
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

  Widget _buildExpandableButtons() {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingAddClothingButton(onClick: () {}),
        FloatingAddUserPhotoButton(onClick: () {})
      ],
    );
  }
}
