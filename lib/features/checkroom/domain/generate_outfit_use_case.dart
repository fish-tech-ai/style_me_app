import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/checkroom/data/models/generate_outfit_body.dart';
import 'package:style_me/features/checkroom/data/models/generated_outfit_response.dart';
import 'package:style_me/features/home/data/outfit_repository.dart';

class GenerateOutfitUseCase {
  final OutfitRepository _repository;
  final NetworkRequestUtil _networkUtil;

  GenerateOutfitUseCase(this._repository, this._networkUtil);

  Future<Result<GeneratedOutfitResponse>> call(GenerateOutfitBody request) {
    return _networkUtil.makeRepositoryRequest(() async {
      return _repository.generateOutfit(request);
    });
  }
}
