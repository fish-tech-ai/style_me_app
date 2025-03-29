import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/views/default_loading_page.dart';
import 'package:style_me/core/views/ui_models/app_button_icon_data.dart';
import 'package:style_me/core/views/ui_models/icon_position.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function()? onClick;
  final bool enabled;
  final bool isLoading;
  final AppButtonIconData? icon;
  final double height;
  final double? width;
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
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColorLocal = backgroundColor ?? context.colorScheme.primary;
    final appButtonIcon = icon ?? AppButtonIconData.empty();
    final defaultStyle = ElevatedButton.styleFrom(
        padding: padding,
        backgroundColor:
            enabled ? backgroundColorLocal : context.theme.disabledColor);
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onClick,
        style: style?.merge(defaultStyle) ?? defaultStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 2,
          children: [
            _buildIcon(context, appButtonIcon).orEmpty(
                icon == null || icon?.position != IconPosition.leading),
            Text(
              text,
              style: TextStyle(
                color: enabled
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSecondary,
              ),
            ),
            _buildIcon(context, appButtonIcon).orEmpty(
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

  Widget _buildIcon(BuildContext context, AppButtonIconData appButtonIcon) {
    final iconColor = enabled
        ? context.colorScheme.onPrimary
        : context.colorScheme.onSecondary;
    if (appButtonIcon.isFromAsset) {
      return SvgPicture.asset(
        height: 24,
        width: 24,
        appButtonIcon.svgAsset!,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    }
    return Icon(appButtonIcon.icon, color: iconColor, size: 24);
  }
}
