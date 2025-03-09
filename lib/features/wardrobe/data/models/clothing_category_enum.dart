import 'package:style_me/core/lang/localizations_helper.dart';

enum ClothingCategoryEnum {
  ALL,
  BLAZER,
  BLOUSE,
  BODY,
  DRESS,
  HAT,
  HOODIE,
  LONGSLEEVE,
  OUTWEAR,
  PANTS,
  POLO,
  SHIRT,
  SHOES,
  SHORTS,
  SKIP,
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
        ClothingCategoryEnum.HAT => localizations.clothingCategoryHat,
        ClothingCategoryEnum.HOODIE => localizations.clothingCategoryHoodie,
        ClothingCategoryEnum.LONGSLEEVE =>
          localizations.clothingCategoryLongsleeve,
        ClothingCategoryEnum.OUTWEAR => localizations.clothingCategoryOutwear,
        ClothingCategoryEnum.PANTS => localizations.clothingCategoryPants,
        ClothingCategoryEnum.POLO => localizations.clothingCategoryPolo,
        ClothingCategoryEnum.SHIRT => localizations.clothingCategoryShirt,
        ClothingCategoryEnum.SHOES => localizations.clothingCategoryShoes,
        ClothingCategoryEnum.SHORTS => localizations.clothingCategoryShorts,
        ClothingCategoryEnum.SKIP => localizations.clothingCategorySkip,
        ClothingCategoryEnum.SKIRT => localizations.clothingCategorySkirt,
        ClothingCategoryEnum.TSHIRT => localizations.clothingCategoryTshirt,
        ClothingCategoryEnum.TOP => localizations.clothingCategoryTop,
        ClothingCategoryEnum.UNDERSHIRT =>
          localizations.clothingCategoryUndershirt
      };
}
