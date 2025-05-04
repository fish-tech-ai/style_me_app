import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothing_confirmation_request.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';

class ClearClothingPhotoUseCase {
  final WardrobeRepository _repository;
  final NetworkRequestUtil _networkRequestUtil;

  ClearClothingPhotoUseCase(this._repository, this._networkRequestUtil);

  Future<Result> call(String id) {
    final request = ClothingConfirmationRequest.delete(id);
    return _networkRequestUtil
        .makeRepositoryRequest(() => _repository.confirmClothingPhoto(request));
  }
}