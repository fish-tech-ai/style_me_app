import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/app_top_bar.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_fetch/image_acceptation_view.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_fetch/photo_fetcher.dart';
import 'package:style_me/features/wardrobe/presentation/state/add_edit_photo_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/state/add_edit_photo_view_model.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/add_photo_page_mode.dart';

class AddClothingPage extends ConsumerWidget {
  const AddClothingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addEditPhotoViewModelProvider);
    final viewModel = ref.read(addEditPhotoViewModelProvider.notifier);
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

  Widget _buildPageContentBasedOn(AddEditPhotoStateHolder state, AddEditPhotoViewModel viewModel) {
    switch (state.addPhotoPageMode) {
      case AddPhotoPageMode.pickPhoto:
        return PhotoFetcher(
          onImageFetched: (image) {
            viewModel.onImageFetched(image);
          },
        );
      case AddPhotoPageMode.acceptPhoto:
        return ImageAcceptationView(
          imageFile: state.image!,
          shouldFlip: false,
          onTryAgainClicked: () => viewModel.onBackAction(),
          onAcceptClicked: () => viewModel.onImageAccepted(),
        );
      case AddPhotoPageMode.fillData:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
