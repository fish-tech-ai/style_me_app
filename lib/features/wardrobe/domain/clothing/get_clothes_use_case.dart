import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_position_enum.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothes_request.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';

class GetClothesUseCase {
  final WardrobeRepository _repository;
  final NetworkRequestUtil _networkUtil;

  GetClothesUseCase(this._repository, this._networkUtil);

  Future<Result<List<Clothing>>> call(
    String? searchText,
    ClothingPositionEnum? position,
    ClothingCategoryEnum category,
  ) {
    return _networkUtil.makeRepositoryRequest(() async {
      final result = await _repository.getClothes(
        ClothesRequest(
          searchText?.isEmpty == true ? null : searchText,
          position?.name,
          (category == ClothingCategoryEnum.ALL ? null : category)?.name,
        ),
      );
      return result.data;
    });
  }
}
