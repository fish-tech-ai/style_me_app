import 'package:style_me/features/wardrobe/presentation/ui_models/photo_with_action.dart';

abstract class PhotoItem {
  final String id;
  final String image;
  final String name;
  final bool isDefault;

  PhotoItem(this.id, this.image, this.name, {this.isDefault = false});

  PhotoWithAction withDeleteAction() {
    return PhotoWithAction.delete(this);
  }

  PhotoWithAction withUpdateAction() {
    return PhotoWithAction.update(this);
  }
}
