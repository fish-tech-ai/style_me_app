import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  Widget orLoading(bool condition) =>
      condition ? Center(child: CircularProgressIndicator()) : this;

  Widget orEmpty(bool condition) => condition ? SizedBox() : this;

  Widget orWrapWithSafeArea(bool condition) =>
      condition ? SafeArea(child: this) : this;

  Widget or(Widget otherWidget, bool ifConditionTrue) =>
      ifConditionTrue ? otherWidget : this;
}
