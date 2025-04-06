import 'package:style_me/core/lang/localizations_helper.dart';

enum ClothingPositionEnum {
  UPPER,
  BOTTOM,
  FULL_BODY;

  String get text => switch (this) {
        ClothingPositionEnum.UPPER => localizations.positionUpper,
        ClothingPositionEnum.BOTTOM => localizations.positionBottom,
        ClothingPositionEnum.FULL_BODY => localizations.positionFull
      };
}
