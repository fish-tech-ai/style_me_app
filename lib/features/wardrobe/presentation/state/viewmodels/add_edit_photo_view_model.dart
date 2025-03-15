import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/network/failures/image_process_failure.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_clothing_photo_response.dart';
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

  void onImageAccepted() {
    state = state.copyWith(isImageAddLoading: true);
    sendClothingPhoto(state.image!);
  }

  Future sendClothingPhoto(File image) async {
    final result = await _sendClothingPhotoUseCase(image);
    result.collect((SendClothingPhotoResponse response) {
      state = state.copyWith(
        isImageAddLoading: false,
        addPhotoPageMode: AddPhotoPageMode.fillData,
        clothingForm: state.clothingForm.copyWith(
          selectedCategory: response.recommendedCategory,
          isRecommendedCategory: true,
        ),
      );
    }, (failure) {
      if (failure is ImageProcessFailure) {
        state = state.copyWith(
            imageProcessingError: failure.type, isImageAddLoading: false);
        return;
      }
      state = state.copyWith(isImageAddLoading: false);
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });
  }

  void onBackAction([Function()? pop]) {
    if (state.addPhotoPageMode != AddPhotoPageMode.pickPhoto) {
      state = state.copyWith(
          addPhotoPageMode: AddPhotoPageMode.pickPhoto,
          image: null,
          imageProcessingError: null);
    } else {
      pop?.call();
    }
  }

  void onCategorySelected(ClothingCategoryEnum category) {
    state = state.copyWith(
        clothingForm: state.clothingForm.copyWith(
            selectedCategory: category, isRecommendedCategory: false));
  }

  void onTextChanged(String text) {
    state = state.copyWith(
        clothingForm: state.clothingForm.copyWith(nameText: text));
  }
}
