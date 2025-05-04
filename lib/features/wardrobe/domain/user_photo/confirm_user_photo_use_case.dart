import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/io/user_photo_confirmation_request.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';

class ConfirmUserPhotoUseCase {
  final WardrobeRepository _repository;
  final NetworkRequestUtil _networkRequestUtil;

  ConfirmUserPhotoUseCase(this._repository, this._networkRequestUtil);

  Future<Result> call(String id, String name, bool isDefault) {
    final request = UserPhotoConfirmationRequest.add(id, name, isDefault);
    return _networkRequestUtil
        .makeRepositoryRequest(() => _repository.confirmUserPhoto(request));
  }
}
