import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';

class SetIsOutfitFavoriteUseCase {
  final OutfitRepository _repository;
  final NetworkRequestUtil _networkRequestUtil;

  SetIsOutfitFavoriteUseCase(this._repository, this._networkRequestUtil);

  Future<Result> call(String outfitId, bool shouldLike) {
    return _networkRequestUtil.makeRepositoryRequest(
        () => _repository.setIsOutfitFavorite(outfitId, shouldLike));
  }
}
