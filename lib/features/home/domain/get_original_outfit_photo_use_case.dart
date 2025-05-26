import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfit_original_photo_response.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';

class GetOriginalOutfitPhotoUseCase {
  final OutfitRepository _repository;
  final NetworkRequestUtil _networkRequestUtil;

  GetOriginalOutfitPhotoUseCase(this._repository, this._networkRequestUtil);

  Future<Result<OutfitOriginalPhotoResponse>> call(String outfitId) {
    return _networkRequestUtil.makeRepositoryRequest(
        () => _repository.getOriginalOutfitPhoto(outfitId));
  }
}
