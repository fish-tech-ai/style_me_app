import 'package:flutter/material.dart';
import 'package:style_me/core/views/app_top_bar.dart';
import 'package:style_me/features/home/data/models/outfit.dart';

class OutfitDetailsPage extends StatelessWidget {
  final Outfit outfit;

  const OutfitDetailsPage({super.key, required this.outfit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(
          title: outfit.name,
        )
      ],
    );
  }
}
