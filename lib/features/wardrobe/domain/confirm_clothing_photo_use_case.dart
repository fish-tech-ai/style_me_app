import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothing_confirmation_request.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';

class ConfirmClothingPhotoUseCase {
  final WardrobeRepository _repository;
  final NetworkRequestUtil _networkRequestUtil;

  ConfirmClothingPhotoUseCase(this._repository, this._networkRequestUtil);

  Future<Result> call(String id, String name, ClothingCategoryEnum category) {
    final request = ClothingConfirmationRequest.add(id, name, category);
    return _networkRequestUtil
        .makeRepositoryRequest(() => _repository.confirmClothingPhoto(request));
  }
}
