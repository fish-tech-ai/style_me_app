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

extension WidgetListExt on List<Widget> {
  List<Widget> orLoading(bool condition) =>
      condition ? [Center(child: CircularProgressIndicator())] : this;

  List<Widget> orEmpty(bool condition) => condition ? [SizedBox()] : this;

  List<Widget> or(List<Widget> otherWidget, bool ifConditionTrue) =>
      ifConditionTrue ? otherWidget : this;
}

