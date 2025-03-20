import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/network/exceptions/helpers/image_error_type/image_type_enum.dart';
import 'package:style_me/core/views/app_top_bar.dart';
import 'package:style_me/features/wardrobe/presentation/components/add_photos/clothing_photo_add_form.dart';
import 'package:style_me/features/wardrobe/presentation/components/add_photos/image_acceptation_view.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_fetch/photo_fetcher.dart';
import 'package:style_me/features/wardrobe/presentation/state/add_edit_photo_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/add_edit_photo_view_model.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/add_photo_page_mode.dart';

class AddClothingPage extends ConsumerStatefulWidget {
  const AddClothingPage({super.key});
  @override
  ConsumerState<AddClothingPage> createState() => _AddClothingPageState();
}

class _AddClothingPageState extends ConsumerState<AddClothingPage> with WidgetsBindingObserver {

  late final AddEditPhotoViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(addEditPhotoViewModelProvider.notifier);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      viewModel.onAppPaused();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AddEditPhotoStateHolder state =
        ref.watch(addEditPhotoViewModelProvider);
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
          _buildPageContentBasedOn(state, viewModel, context)
        ],
      ),
    );
  }

  Widget _buildPageContentBasedOn(AddEditPhotoStateHolder state,
      AddEditPhotoViewModel viewModel, BuildContext context) {
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
          actionButtonText: state.addPhotoPageMode == AddPhotoPageMode.fillData
              ? localizations.addPhoto
              : localizations.continueText,
          isImageAddLoading: state.isImageAddLoading,
          onTryAgainClicked: () => viewModel.onBackAction(),
          onAcceptClicked: () => viewModel.onAcceptClicked(() => context.pop()),
          imageDataForm: ClothingPhotoAddForm(
            isVisible: state.addPhotoPageMode == AddPhotoPageMode.fillData,
            nameText: state.clothingForm.nameText,
            category: state.clothingForm.selectedCategory,
            onNameTextChanged: (text) {
              viewModel.onTextChanged(text);
            },
            onCategorySelected: (category) {
              viewModel.onCategorySelected(category);
            },
            isRecommendedCategory: state.clothingForm.isRecommendedCategory,
          ),
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
