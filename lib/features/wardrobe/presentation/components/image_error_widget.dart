import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';

class ImageErrorWidget extends StatelessWidget {
  const ImageErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.disabledColor,
      alignment: Alignment.center,
      child:
      Icon(Icons.broken_image, size: 50, color: context.theme.hintColor),
    );  }
}
