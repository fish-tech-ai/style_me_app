import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/network/utils/image_process/image_fetcher.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/io/original_image_response.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/domain/get_original_image_url_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/delete_user_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/update_user_photo_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/user_photo/edit_user_photo_state_holder.dart';

part 'edit_user_photo_view_model.g.dart';

@riverpod
class EditUserPhotoViewModel extends _$EditUserPhotoViewModel {
  late final DeleteUserPhotoUseCase _deleteUserPhotoUseCase;
  late final UpdateUserPhotoUseCase _updateUserPhotoUseCase;
  late final GetOriginalImageUrlUseCase _getOriginalImageUrlUseCase;
  late final ImageFetcher _multipleImageFetcher;

  EditUserPhotoViewModel() {
    _deleteUserPhotoUseCase = getIt();
    _updateUserPhotoUseCase = getIt();
    _getOriginalImageUrlUseCase = getIt();
    _multipleImageFetcher = getIt();
  }

  @override
  EditUserPhotoStateHolder build() {
    return EditUserPhotoStateHolder(
      userPhoto: UserPhoto(
        "",
        "",
        "",
      ),
    );
  }

  void init(UserPhoto userPhoto) async {
    state = state.copyWith(userPhoto: userPhoto, isPageLoading: true);

    final Result<OriginalImageUrlResponse> result =
        await _getOriginalImageUrlUseCase(userPhoto.id);

    final cacheDir = await getTemporaryDirectory();
    result.collect((data) async {
      final String originalImagePath =
          '${cacheDir.path}/${userPhoto.id}_original.webp';
      await _multipleImageFetcher.handleSingleImageLoadingAndCache(
          data.signedUrl, originalImagePath);

      state = state.copyWith(
          userPhoto: userPhoto,
          originalImagePath: originalImagePath,
          isPageLoading: false);
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
      state = state.copyWith(isPageLoading: false);
    });
  }

  Future deleteUserPhoto(Function() onSuccess) async {
    state = state.copyWith(isDeleteLoading: true);
    final result = await _deleteUserPhotoUseCase(state.userPhoto.image);
    result.collect((_) {
      onSuccess();
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });
    state = state.copyWith(isDeleteLoading: false);
  }

  Future updateUserPhoto(Function(UserPhoto) onSuccess) async {
    state = state.copyWith(isSaveLoading: true);
    final result = await _updateUserPhotoUseCase(
        state.userPhoto.id, state.userPhoto.name, state.userPhoto.isDefault);
    result.collect((_) {
      onSuccess(state.userPhoto);
    }, (failure) {
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });
    state = state.copyWith(isSaveLoading: false);
  }

  void onNameTextChanged(String text) {
    state = state.copyWith(userPhoto: state.userPhoto.copyWith(name: text));
  }
}
