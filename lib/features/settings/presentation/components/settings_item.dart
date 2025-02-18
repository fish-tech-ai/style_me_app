import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/features/settings/presentation/ui_models/setting.dart';

class SettingsItem extends StatelessWidget {
  final Setting setting;
  final Function(Setting) onItemClicked;

  const SettingsItem({
    super.key,
    required this.setting,
    required this.onItemClicked,
  });

  @override
  Widget build(BuildContext context) {
    final forcedColor = setting.forceForegroundColor?.call(context);
    return SizedBox(
      child: InkWell(
        onTap: () {
          if (setting.path != null) {
            context.push(setting.path!);
            return;
          }
          onItemClicked(setting);
        },
        child: Column(
          children: [
            Divider(height: 1, color: context.theme.hintColor),
            Container(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: BoxConstraints(maxHeight: 37),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          setting.label,
                          style: TextStyle(
                            color: forcedColor,
                          ),
                        ),
                        Text(
                          setting.subLabel ?? "",
                          style: TextStyle(
                              color: context.theme.hintColor, fontSize: 12),
                        ).orEmpty(setting.subLabel == null)
                      ],
                    ),
                  ),
                  setting.actionText == null
                      ? Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: forcedColor ?? context.colorScheme.primary,
                        )
                      : Text(
                          setting.actionText!,
                          style: TextStyle(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
