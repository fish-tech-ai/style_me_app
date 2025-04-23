import 'package:style_me/core/network/utils/network_request_util.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/io/user_photos_response.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/data/wardrobe_repository.dart';

class GetUserOriginalPhotosUseCase {
  final WardrobeRepository _repository;
  final NetworkRequestUtil _networkUtil;

  GetUserOriginalPhotosUseCase(this._repository, this._networkUtil);

  Future<Result<List<UserPhoto>>> call() {
    return _networkUtil.makeRepositoryRequest(() async {
      final UserPhotosResponse result = await _repository.getUserPhotos();
      final List<Future<UserPhoto>> originalUserPhotos =
          result.data.map((photo) async {
        final originalUserPath =
            await _repository.getOriginalUserDataImage(photo.id);
        return photo.copyWith(image: originalUserPath.signedUrl);
      }).toList();
      return Future.wait(originalUserPhotos);
    });
  }
}
