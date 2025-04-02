import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/network/failures/image_process_failure.dart';
import 'package:style_me/core/network/utils/result.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_user_photo_response.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/clear_user_photo_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/confirm_user_photo_photo_use_case.dart';
import 'package:style_me/features/wardrobe/domain/user_photo/send_user_photo_photo_use_case.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/user_photo/add_user_photo_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/add_photo_page_mode.dart';

part 'add_user_photo_view_model.g.dart';

@riverpod
class AddUserPhotoPhotoViewModel extends _$AddUserPhotoPhotoViewModel {
  late final SendUserPhotoPhotoUseCase _sendUserPhotoPhotoUseCase;
  late final ConfirmUserPhotoPhotoUseCase _confirmUserPhotoPhotoUseCase;
  late final ClearUserPhotoPhotoUseCase _deleteUserPhotoPhotoUseCase;

  AddUserPhotoPhotoViewModel() {
    _sendUserPhotoPhotoUseCase = getIt();
    _confirmUserPhotoPhotoUseCase = getIt();
    _deleteUserPhotoPhotoUseCase = getIt();
  }

  String? _imageId;

  @override
  AddUserPhotoStateHolder build() {
    return AddUserPhotoStateHolder();
  }

  void onImageFetched(File image) {
    state = state.copyWith(
      addPhotoPageMode: AddPhotoPageMode.acceptPhoto,
      image: image,
    );
  }

  void onAcceptClicked(Function() onConfirmSuccess) {
    state = state.copyWith(isImageAddLoading: true);
    if (state.addPhotoPageMode == AddPhotoPageMode.fillData) {
      sendConfirmationData(onConfirmSuccess);
    } else {
      sendUserPhotoPhoto(state.image!);
    }
  }

  Future sendUserPhotoPhoto(File image) async {
    final Result<SendUserPhotoResponse> result = await _sendUserPhotoPhotoUseCase(image);
    result.collect((SendUserPhotoResponse response) {
      _imageId = response.id;
      state = state.copyWith(
        isImageAddLoading: false,
        addPhotoPageMode: AddPhotoPageMode.fillData,
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

  Future sendConfirmationData(Function() onSuccess) async {
    state = state.copyWith(isImageAddLoading: true);
    final result = await _confirmUserPhotoPhotoUseCase(
      _imageId ?? "",
      state.userPhotoForm.nameText,
      state.userPhotoForm.isDefault,
    );
    result.collect((_) {
      state = state.copyWith(
        isImageAddLoading: false,
        shouldDeletePhoto: false,
      );
      onSuccess();
    }, (failure) {
      state = state.copyWith(isImageAddLoading: false);
      ref.read(appGlobalViewModelProvider.notifier).showFailure(failure);
    });
  }

  void onBackAction([Function()? pop]) {
    if (state.shouldDeletePhoto) {
      clearImageData();
    }
    if (state.addPhotoPageMode != AddPhotoPageMode.pickPhoto) {
      backToPickPhotoMode();
    } else {
      pop?.call();
    }
  }

  void onAppPaused() {
    if (_imageId != null) {
      onBackAction();
    }
  }

  void backToPickPhotoMode() {
    state = state.copyWith(
        addPhotoPageMode: AddPhotoPageMode.pickPhoto,
        image: null,
        imageProcessingError: null);
  }

  void onTextChanged(String text) {
    state = state.copyWith(
        userPhotoForm: state.userPhotoForm.copyWith(nameText: text));
  }

  Future clearImageData() async {
    if (state.addPhotoPageMode == AddPhotoPageMode.fillData) {
      final result = await _deleteUserPhotoPhotoUseCase(_imageId!);
      result.collect((_) {}, (failure) {
        debugMessagePrint(failure.toString());
      });
    }
  }

  @visibleForTesting
  AddUserPhotoPhotoViewModel.test(
    this._sendUserPhotoPhotoUseCase,
    this._confirmUserPhotoPhotoUseCase,
    this._deleteUserPhotoPhotoUseCase,
  );
}
