import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';

class DeleteUserPhotoUseCase {
  final NetworkRequestUtil _networkRequestUtil;
  final WardrobeRepository _repository;

  DeleteUserPhotoUseCase(this._networkRequestUtil, this._repository);

  Future<Result> call(String id) {
    return _networkRequestUtil
        .makeRepositoryRequest(() => _repository.deleteUserPhoto(id));
  }
}
