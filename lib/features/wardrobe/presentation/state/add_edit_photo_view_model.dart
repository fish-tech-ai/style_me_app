import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/network/failures/image_process_failure.dart';
import 'package:style_me/features/wardrobe/domain/send_clothing_photo_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/add_edit_photo_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/add_photo_page_mode.dart';

part 'add_edit_photo_view_model.g.dart';

@riverpod
class AddEditPhotoViewModel extends _$AddEditPhotoViewModel {
  late final SendClothingPhotoUseCase _sendClothingPhotoUseCase;

  AddEditPhotoViewModel() {
    _sendClothingPhotoUseCase = getIt();
  }

  @override
  AddEditPhotoStateHolder build() {
    return AddEditPhotoStateHolder();
  }

  void onImageFetched(File image) {
    state = state.copyWith(
      addPhotoPageMode: AddPhotoPageMode.acceptPhoto,
      image: image,
    );
  }

  void onImageAccepted() {}

  Future sendClothingPhoto(File image) async {
    final result = await _sendClothingPhotoUseCase(image);
    result.collect((response) {
      state = state.copyWith(isImageAddLoading: false);
    }, (failure) {
      if (failure is ImageProcessFailure) {
        state = state.copyWith(error: failure.type);
      }
      state = state.copyWith(isImageAddLoading: false);
    });
  }

  void onBackAction([Function()? pop]) {
    if (state.addPhotoPageMode != AddPhotoPageMode.pickPhoto) {
      state = state.copyWith(
          addPhotoPageMode: AddPhotoPageMode.pickPhoto, image: null);
    } else {
      pop?.call();
    }
  }
}
