import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/io/original_image_response.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';

class GetOriginalClothingImageUrlUseCase {
  final WardrobeRepository _repository;
  final NetworkRequestUtil _networkUtil;

  GetOriginalClothingImageUrlUseCase(this._repository, this._networkUtil);

  Future<Result<OriginalImageUrlResponse>> call(String id) {
    return _networkUtil
        .makeRepositoryRequest(() => _repository.getOriginalClothingImage(id));
  }
}
