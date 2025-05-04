import 'package:style_me/core/lang/localizations_helper.dart';

// ignore_for_file: constant_identifier_names
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
