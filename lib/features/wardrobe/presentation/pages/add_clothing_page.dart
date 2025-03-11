import 'package:flutter/material.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_fetch/photo_fetcher.dart';

class AddClothingPage extends StatelessWidget {
  const AddClothingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PhotoFetcher(
      topBarTitle: localizations.floatingAddClothingButtonText,
      onImageAccepted: (file) {},
    );
  }
}
