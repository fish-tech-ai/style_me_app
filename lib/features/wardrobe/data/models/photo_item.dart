import 'package:style_me/features/wardrobe/presentation/ui_models/photo_with_action.dart';

abstract class PhotoItem {
  final String id;
  final String image;
  final String name;
  final bool isDefault;
  final bool isSelected;
  final bool isDisabled;
  final bool isFavorite;

  PhotoItem(
    this.id,
    this.image,
    this.name, {
    this.isDefault = false,
    this.isSelected = false,
    this.isDisabled = false,
    this.isFavorite = false,
  });

  PhotoWithAction withDeleteAction() {
    return PhotoWithAction.delete(this);
  }

  PhotoWithAction withUpdateAction() {
    return PhotoWithAction.update(this);
  }

  PhotoItem copyWith({
    String? id,
    String? name,
    String? image,
  });
}
