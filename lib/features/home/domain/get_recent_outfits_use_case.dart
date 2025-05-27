import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/home/data/models/outfits_response.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';

class GetRecentOutfitsUseCase {
  final OutfitRepository _repository;
  final NetworkRequestUtil _networkRequestUtil;

  GetRecentOutfitsUseCase(this._repository, this._networkRequestUtil);

  Future<Result<OutfitsResponse>> call() {
    return _networkRequestUtil
        .makeRepositoryRequest(() => _repository.getRecentOutfits());
  }
}
