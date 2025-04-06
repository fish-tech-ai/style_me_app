// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clothing _$ClothingFromJson(Map<String, dynamic> json) => Clothing(
      json['id'] as String,
      json['name'] as String,
      json['image'] as String,
      $enumDecode(_$ClothingCategoryEnumEnumMap, json['category']),
      $enumDecode(_$ClothingPositionEnumEnumMap, json['position']),
    );

Map<String, dynamic> _$ClothingToJson(Clothing instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'category': _$ClothingCategoryEnumEnumMap[instance.category]!,
      'position': _$ClothingPositionEnumEnumMap[instance.position]!,
    };

const _$ClothingCategoryEnumEnumMap = {
  ClothingCategoryEnum.ALL: 'ALL',
  ClothingCategoryEnum.BLAZER: 'BLAZER',
  ClothingCategoryEnum.BLOUSE: 'BLOUSE',
  ClothingCategoryEnum.BODY: 'BODY',
  ClothingCategoryEnum.DRESS: 'DRESS',
  ClothingCategoryEnum.HAT: 'HAT',
  ClothingCategoryEnum.HOODIE: 'HOODIE',
  ClothingCategoryEnum.LONGSLEEVE: 'LONGSLEEVE',
  ClothingCategoryEnum.OUTWEAR: 'OUTWEAR',
  ClothingCategoryEnum.PANTS: 'PANTS',
  ClothingCategoryEnum.POLO: 'POLO',
  ClothingCategoryEnum.SHIRT: 'SHIRT',
  ClothingCategoryEnum.SHOES: 'SHOES',
  ClothingCategoryEnum.SHORTS: 'SHORTS',
  ClothingCategoryEnum.SKIP: 'SKIP',
  ClothingCategoryEnum.SKIRT: 'SKIRT',
  ClothingCategoryEnum.TSHIRT: 'TSHIRT',
  ClothingCategoryEnum.TOP: 'TOP',
  ClothingCategoryEnum.UNDERSHIRT: 'UNDERSHIRT',
};

const _$ClothingPositionEnumEnumMap = {
  ClothingPositionEnum.UPPER: 'UPPER',
  ClothingPositionEnum.BOTTOM: 'BOTTOM',
  ClothingPositionEnum.FULL_BODY: 'FULL_BODY',
};
