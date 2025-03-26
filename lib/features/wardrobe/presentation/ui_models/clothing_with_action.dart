import 'package:style_me/features/wardrobe/data/models/clothing.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/modification_action_enum.dart';

class ClothingWithAction {
  final Clothing clothing;
  final ModificationActionEnum action;

  ClothingWithAction.delete(this.clothing)
      : action = ModificationActionEnum.delete;

  ClothingWithAction.update(this.clothing)
      : action = ModificationActionEnum.update;
}
