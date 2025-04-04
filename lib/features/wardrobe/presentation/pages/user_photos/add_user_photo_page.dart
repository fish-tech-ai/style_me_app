import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/network/exceptions/helpers/image_error_type/image_type_enum.dart';
import 'package:style_me/core/views/app_top_bar.dart';
import 'package:style_me/features/wardrobe/presentation/components/add_photos/image_acceptation_view.dart';
import 'package:style_me/features/wardrobe/presentation/components/add_photos/user_photo_add_form.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_fetch/photo_fetcher.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/user_photo/add_user_photo_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/user_photo/add_user_photo_view_model.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/add_photo_page_mode.dart';

class AddUserPhotoPage extends ConsumerStatefulWidget {
  const AddUserPhotoPage({super.key});

  @override
  ConsumerState<AddUserPhotoPage> createState() => _AddUserPhotoPageState();
}

class _AddUserPhotoPageState extends ConsumerState<AddUserPhotoPage>
    with WidgetsBindingObserver {
  late final AddUserPhotoViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(addUserPhotoViewModelProvider.notifier);
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
    final AddUserPhotoStateHolder state =
        ref.watch(addUserPhotoViewModelProvider);
    showDialogOnImageError(
      context,
      state.imageProcessingError,
      viewModel,
    );
    return PopScope(
      canPop: state.addPhotoPageMode == AddPhotoPageMode.pickPhoto,
      onPopInvokedWithResult: (_, __) {
        viewModel.onBackAction(() {});
      },
      child: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: localizations.userPhotoAddPageTitle,
              onBackButtonClicked: () {
                viewModel.onBackAction(() => context.pop());
              },
            ),
            _buildPageContentBasedOn(state, viewModel, context)
          ],
        ),
      ),
    );
  }

  Widget _buildPageContentBasedOn(AddUserPhotoStateHolder state,
      AddUserPhotoViewModel viewModel, BuildContext context) {
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
          imageDataForm: UserPhotoAddForm(
            isVisible: state.addPhotoPageMode == AddPhotoPageMode.fillData,
            nameText: state.userPhotoForm.nameText,
            isDefaultChecked: state.userPhotoForm.isDefault,
            onNameTextChanged: (text) {
              viewModel.onTextChanged(text);
            },
            onIsDefaultChanged: (isChecked) {
              viewModel.onIsDefaultChanged(isChecked);
            },
          ),
        );
    }
  }

  void showDialogOnImageError(
    BuildContext context,
    ImageErrorTypeEnum? imageProcessingError,
    AddUserPhotoViewModel viewModel,
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
