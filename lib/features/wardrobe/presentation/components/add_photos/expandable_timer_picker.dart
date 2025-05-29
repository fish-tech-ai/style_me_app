import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/core/views/animators/animated_expandable_content.dart';
import 'package:style_me/core/views/buttons/app_icon_button.dart';
import 'package:style_me/core/views/ui_models/countdown_option_enum.dart';

class ExpandableTimerPicker extends StatefulWidget {
  final Function(CountdownOptionEnum?) onOptionSelected;

  const ExpandableTimerPicker({super.key, required this.onOptionSelected});

  @override
  State<ExpandableTimerPicker> createState() => _ExpandableTimerPickerState();
}

class _ExpandableTimerPickerState extends State<ExpandableTimerPicker> {
  bool isExpanded = false;
  CountdownOptionEnum? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: GlobalUiConst.borderRadiusLarge),
      child: AnimatedExpandableContent(
          isExpanded: isExpanded,
          spacing: 2,
          header: AppIconButton(
            icon: _getCurrentIcon(),
            onClick: () {
              setState(() {
                if (isExpanded) {
                  selectedOption = null;
                  widget.onOptionSelected(null);
                }
                isExpanded = !isExpanded;
              });
            },
            backgroundColor: context.colorScheme.primaryContainer,
          ),
          children: CountdownOptionEnum.values.map((option) {
            return AppIconButton(
              icon: SvgPicture.asset(
                option.svgAssetPath,
                width: 24,
                colorFilter: ColorFilter.mode(
                    context.colorScheme.primary, BlendMode.srcIn),
              ),
              onClick: () {
                setState(() {
                  isExpanded = false;
                  selectedOption = option;
                });
                return widget.onOptionSelected(option);
              },
              backgroundColor: selectedOption == option
                  ? context.colorScheme.primaryContainer
                  : Colors.transparent,
            );
          }).toList()),
    );
  }

  Widget _getCurrentIcon() {
    if (selectedOption == null) {
      return Icon(
        Icons.timer,
        color: context.colorScheme.primary,
      );
    } else if (isExpanded) {
      return Icon(
        Icons.close_rounded,
        color: context.colorScheme.primary,
      );
    } else {
      return SvgPicture.asset(
        selectedOption!.svgAssetPath,
        width: 24,
        colorFilter:
            ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
      );
    }
  }
}
