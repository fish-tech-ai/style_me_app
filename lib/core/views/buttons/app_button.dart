import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/views/default_loading_page.dart';
import 'package:style_me/core/views/ui_models/app_button_icon.dart';
import 'package:style_me/core/views/ui_models/icon_position.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function()? onClick;
  final bool enabled;
  final bool isLoading;
  final AppButtonIcon? icon;
  final double height;
  final EdgeInsets padding;

  ///Replaces current [style] merging default
  ///
  /// default is:
  ///```dart
  ///ElevatedButton.styleFrom(
  /// backgroundColor: enabled
  ///     ? backgroundColorLocal
  ///     : context.theme.disabledColor)
  ///```
  final ButtonStyle? style;

  ///Changes the background colour without changing the colour for the button in the inactive state
  final Color? backgroundColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onClick,
    this.style,
    this.icon,
    this.enabled = true,
    this.isLoading = false,
    this.backgroundColor,
    this.height = 48,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColorLocal = backgroundColor ?? context.colorScheme.primary;
    final defaultStyle = ElevatedButton.styleFrom(
        padding: padding,
        backgroundColor:
            enabled ? backgroundColorLocal : context.theme.disabledColor);
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onClick,
        style: style?.merge(defaultStyle) ?? defaultStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 2,
          children: [
            _buildIcon(context, icon?.icon ?? Icons.do_not_disturb_alt_rounded)
                .orEmpty(
                    icon == null || icon?.position != IconPosition.leading),
            Text(
              text,
              style: TextStyle(
                color: enabled
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSecondary,
              ),
            ),
            _buildIcon(context, icon?.icon ?? Icons.do_not_disturb_alt_rounded)
                .orEmpty(
                    icon == null || icon?.position != IconPosition.trailing),
          ],
        ).or(
            DefaultLoading(
              color: context.colorScheme.onPrimary,
              size: Size.square(24),
            ),
            isLoading),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, IconData icon) {
    return Icon(icon,
        color: enabled
            ? context.colorScheme.onPrimary
            : context.colorScheme.onSecondary,
        size: 24);
  }
}
