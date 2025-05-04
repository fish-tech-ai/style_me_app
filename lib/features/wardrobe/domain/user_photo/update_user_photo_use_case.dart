import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/io/update_user_photo_request.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';

class UpdateUserPhotoUseCase {
  final NetworkRequestUtil _networkRequestUtil;
  final WardrobeRepository _repository;

  UpdateUserPhotoUseCase(this._networkRequestUtil, this._repository);

  Future<Result> call(String id, String name, bool isDefault) {
    final request = UpdateUserPhotoRequest(name, isDefault);
    return _networkRequestUtil
        .makeRepositoryRequest(() => _repository.updateUserPhoto(id, request));
  }
}
