import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/modification_action_enum.dart';

class PhotoWithAction {
  final PhotoItem item;
  final ModificationActionEnum action;

  PhotoWithAction.delete(this.item)
      : action = ModificationActionEnum.delete;

  PhotoWithAction.update(this.item)
      : action = ModificationActionEnum.update;
}
