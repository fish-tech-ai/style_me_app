import 'package:flutter/material.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_grid_item.dart';

class PhotosCarousel extends StatelessWidget {
  final List<PhotoItem> items;
  final Function(PhotoItem) onItemClicked;
  final Function(PhotoItem)? onItemFavoriteClicked;
  final Function(PhotoItem)? onItemDeleteClicked;

  const PhotosCarousel({
    super.key,
    required this.items,
    required this.onItemClicked,
    this.onItemFavoriteClicked,
    this.onItemDeleteClicked,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) => SizedBox(
          width: 180,
          child: PhotoGridItem(
            photo: items[index],
            onItemClicked: onItemClicked,
            onFavoriteClicked: onItemFavoriteClicked,
            onDeleteClicked: onItemDeleteClicked,
          ),
        ),
        separatorBuilder: (BuildContext _, int __) => SizedBox(width: 12),
        itemCount: items.length,
      ),
    );
  }
}
