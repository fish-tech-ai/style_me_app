import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';

class GetUserPhotosUseCase {
  final WardrobeRepository _repository;
  final NetworkRequestUtil _networkUtil;

  GetUserPhotosUseCase(this._repository, this._networkUtil);

  Future<Result<List<UserPhoto>>> call() {
    return _networkUtil.makeRepositoryRequest(() async {
      final result = await _repository.getUserPhotos();
      return result.data;
    });
  }
}
