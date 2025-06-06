import 'package:style_me/core/lang/localizations_helper.dart';

// ignore_for_file: constant_identifier_names
enum ClothingCategoryEnum {
  ALL,
  BLAZER,
  BLOUSE,
  BODY,
  DRESS,
  HOODIE,
  LONGSLEEVE,
  OUTWEAR,
  PANTS,
  POLO,
  SHIRT,
  SHORTS,
  SKIRT,
  TSHIRT,
  TOP,
  UNDERSHIRT;

  String get text => switch (this) {
        ClothingCategoryEnum.ALL => localizations.clothingCategoryAll,
        ClothingCategoryEnum.BLAZER => localizations.clothingCategoryBlazer,
        ClothingCategoryEnum.BLOUSE => localizations.clothingCategoryBlouse,
        ClothingCategoryEnum.BODY => localizations.clothingCategoryBody,
        ClothingCategoryEnum.DRESS => localizations.clothingCategoryDress,
        ClothingCategoryEnum.HOODIE => localizations.clothingCategoryHoodie,
        ClothingCategoryEnum.LONGSLEEVE =>
          localizations.clothingCategoryLongsleeve,
        ClothingCategoryEnum.OUTWEAR => localizations.clothingCategoryOutwear,
        ClothingCategoryEnum.PANTS => localizations.clothingCategoryPants,
        ClothingCategoryEnum.POLO => localizations.clothingCategoryPolo,
        ClothingCategoryEnum.SHIRT => localizations.clothingCategoryShirt,
        ClothingCategoryEnum.SHORTS => localizations.clothingCategoryShorts,
        ClothingCategoryEnum.SKIRT => localizations.clothingCategorySkirt,
        ClothingCategoryEnum.TSHIRT => localizations.clothingCategoryTshirt,
        ClothingCategoryEnum.TOP => localizations.clothingCategoryTop,
        ClothingCategoryEnum.UNDERSHIRT =>
          localizations.clothingCategoryUndershirt
      };
  static List<ClothingCategoryEnum> withoutAllCategory() {
    return values
        .where((item) => item != ClothingCategoryEnum.ALL)
        .toList();
  }
}
