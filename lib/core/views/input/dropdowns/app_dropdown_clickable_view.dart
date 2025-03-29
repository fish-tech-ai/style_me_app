import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/core/views/input/dropdowns/label_clipper.dart';

class AppDropdownClickableView<T> extends StatelessWidget {
  final LayerLink layerLink;
  final Function() onClick;
  final T selectedItem;
  final EdgeInsets iconPadding;
  final Function(T) itemBuilder;
  final bool isDropdownOpen;
  final String? labelText;

  const AppDropdownClickableView({
    super.key,
    required this.layerLink,
    required this.onClick,
    required this.selectedItem,
    required this.iconPadding,
    required this.itemBuilder,
    required this.isDropdownOpen,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    final labelWidth = _calculateTextWidth(labelText ?? "", context);
    final withLabel = labelText != null;

    return CompositedTransformTarget(
      link: layerLink,
      child: GestureDetector(
        onTap: onClick,
        child: Stack(
          children: [
            ClipPath(
              clipper: withLabel ? LabelClipper(labelWidth) : null,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.primary),
                  borderRadius: GlobalUiConst.borderRadiusNormal,
                ),
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: itemBuilder(selectedItem),
                    ),
                    Container(
                      padding: iconPadding,
                      decoration: BoxDecoration(
                          color: context.colorScheme.primary,
                          borderRadius: BorderRadius.circular(11)),
                      child: Icon(
                        isDropdownOpen //TODO dropdown not updated after first time change
                            ? Icons.expand_more_rounded
                            : Icons.expand_less_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  labelText ?? "",
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ).orEmpty(!withLabel),
          ],
        ),
      ),
    );
  }

  double _calculateTextWidth(String text, BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 12,
      color: context.colorScheme.primary,
      fontWeight: FontWeight.w500,
    );

    final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: textStyle.copyWith(
              fontSize:
              MediaQuery.textScalerOf(context).scale(textStyle.fontSize!)),
        ),
        maxLines: 1,
        textDirection: Directionality.of(context))
      ..layout();

    double width = textPainter.width;

    return (width + 32);
  }
}
