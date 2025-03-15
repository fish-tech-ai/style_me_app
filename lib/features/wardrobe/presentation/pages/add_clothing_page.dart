import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/network/exceptions/helpers/error_type_enum.dart';
import 'package:style_me/core/views/app_top_bar.dart';
import 'package:style_me/features/wardrobe/presentation/components/addPhotos/clothing_photo_add_form.dart';
import 'package:style_me/features/wardrobe/presentation/components/addPhotos/image_acceptation_view.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_fetch/photo_fetcher.dart';
import 'package:style_me/features/wardrobe/presentation/state/add_edit_photo_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/add_edit_photo_view_model.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/add_photo_page_mode.dart';

class AddClothingPage extends ConsumerWidget {
  const AddClothingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AddEditPhotoStateHolder state =
        ref.watch(addEditPhotoViewModelProvider);
    final AddEditPhotoViewModel viewModel =
        ref.read(addEditPhotoViewModelProvider.notifier);
    showDialogOnImageError(
      context,
      state.imageProcessingError,
      viewModel,
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        viewModel.onBackAction(() => context.pop());
      },
      child: Column(
        children: [
          AppTopBar(
            title: localizations.floatingAddClothingButtonText,
            onBackButtonClicked: () {
              viewModel.onBackAction(() => context.pop());
            },
          ),
          _buildPageContentBasedOn(state, viewModel)
        ],
      ),
    );
  }

  Widget _buildPageContentBasedOn(
      AddEditPhotoStateHolder state, AddEditPhotoViewModel viewModel) {
    switch (state.addPhotoPageMode) {
      case AddPhotoPageMode.pickPhoto:
        return PhotoFetcher(
          onImageFetched: (image) {
            viewModel.onImageFetched(image);
          },
        );
      case AddPhotoPageMode.fillData:
      case AddPhotoPageMode.acceptPhoto:
        return ImageAcceptationView(
          imageFile: state.image!,
          hideButtons: state.addPhotoPageMode == AddPhotoPageMode.fillData,
          isImageAddLoading: state.isImageAddLoading,
          onTryAgainClicked: () => viewModel.onBackAction(),
          onAcceptClicked: () => viewModel.onImageAccepted(),
          imageDataForm: ClothingPhotoAddForm(
              isVisible: state.addPhotoPageMode == AddPhotoPageMode.fillData,
              nameText: state.clothingForm.nameText,
              category: state.clothingForm.selectedCategory,
              onNameTextChanged: (text) {
                viewModel.onTextChanged(text);
              },
              onCategorySelected: (category) {
                viewModel.onCategorySelected(category);
              }),
        );
    }
  }

  void showDialogOnImageError(
    BuildContext context,
    ImageErrorTypeEnum? imageProcessingError,
    AddEditPhotoViewModel viewModel,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (imageProcessingError != null) {
        imageProcessingError.showImageProcessErrorDialog(
          context,
          () => viewModel.onBackAction(
            () => context.pop(),
          ),
        );
      }
    });
  }
}
