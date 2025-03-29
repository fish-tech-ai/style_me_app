import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:style_me/core/extensions/context_ext.dart';

class ImageLoadingWidget extends StatelessWidget {
  const ImageLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colorScheme.surface,
      highlightColor: context.colorScheme.secondary,
      period: Duration(milliseconds: 700),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
    );  }
}
