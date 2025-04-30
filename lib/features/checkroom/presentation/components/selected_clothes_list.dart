import 'package:flutter/material.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_grid_item.dart';

class SelectedClothesList extends StatelessWidget {
  final List<Clothing> selectedClothes;
  final Function(Clothing clothing) onDeleteClicked;

  const SelectedClothesList({
    super.key,
    required this.selectedClothes,
    required this.onDeleteClicked,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 16),
        child: Column(
          spacing: 12,
          children: [
            ...selectedClothes.map(
              (clothing) => SizedBox(
                height: 200,
                width: 150,
                child: PhotoGridItem(
                  photo: clothing,
                  labelMaxWidth: 140,
                  onItemClicked: (clothing) {},
                  onDeleteClicked: (clothing) {
                    onDeleteClicked(clothing as Clothing);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
