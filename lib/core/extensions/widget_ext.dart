import 'package:flutter/material.dart';
import 'package:style_me/core/navigation/scoped_page.dart';

extension WidgetExt on Widget {
  Widget orLoading(bool condition) =>
      condition ? Center(child: CircularProgressIndicator()) : this;

  Widget orEmpty(bool condition) => condition ? SizedBox() : this;

  Widget orWrapWithSafeArea(bool condition) =>
      condition ? SafeArea(child: this) : this;

  Widget or(Widget otherWidget, bool ifConditionTrue) =>
      ifConditionTrue ? otherWidget : this;

  Widget scopedPage() => ScopedPage(child: this);
}
