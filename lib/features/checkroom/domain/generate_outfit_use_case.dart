import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/checkroom/data/checkroom_repository.dart';
import 'package:style_me/features/checkroom/data/models/generate_outfit_body.dart';
import 'package:style_me/features/checkroom/data/models/generated_outfit_response.dart';

class GenerateOutfitUseCase {
  final CheckroomRepository _repository;
  final NetworkRequestUtil _networkUtil;

  GenerateOutfitUseCase(this._repository, this._networkUtil);

  Future<Result<GeneratedOutfitResponse>> call(GenerateOutfitBody request) {
    return _networkUtil.makeRepositoryRequest(() async {
      return _repository.generateOutfit(request);
    });
  }
}
