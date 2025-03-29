import 'package:flutter/material.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_grid_item.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

class PhotoGrid extends StatelessWidget {
  final List<PhotoItem> items;
  final Function(PhotoItem photoItem) onItemClicked;

  const PhotoGrid(
      {super.key, required this.items, required this.onItemClicked});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => PhotoGridItem(
        photo: items[index],
        onItemClicked: onItemClicked,
      ),
    );
  }
}
