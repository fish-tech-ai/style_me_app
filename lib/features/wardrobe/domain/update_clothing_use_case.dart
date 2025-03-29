import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/io/update_clothing_request.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';

class UpdateClothingUseCase {
  final NetworkRequestUtil _networkRequestUtil;
  final WardrobeRepository _repository;

  UpdateClothingUseCase(this._networkRequestUtil, this._repository);

  Future<Result> call(String id, String name, ClothingCategoryEnum category) {
    final request = UpdateClothingRequest(name, category);
    return _networkRequestUtil
        .makeRepositoryRequest(() => _repository.updateClothing(id, request));
  }
}
