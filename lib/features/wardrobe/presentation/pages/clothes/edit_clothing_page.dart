import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_back_button.dart';
import 'package:style_me/core/views/encrypted_image/encrypted_image.dart';
import 'package:style_me/core/views/input/app_text_field.dart';
import 'package:style_me/core/views/input/dropdowns/app_dropdown_button.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_error_widget.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_loading_widget.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_modify_buttons.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/clothing/edit_clothing_photo_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/clothing/edit_clothing_photo_view_model.dart';

class EditClothingPage extends ConsumerStatefulWidget {
  final Clothing clothing;

  const EditClothingPage({super.key, required this.clothing});

  @override
  ConsumerState<EditClothingPage> createState() => _EditClothingPageState();
}

class _EditClothingPageState extends ConsumerState<EditClothingPage> {
  late final EditClothingPhotoViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(editClothingPhotoViewModelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.init(widget.clothing);
    });
  }

  @override
  Widget build(BuildContext context) {
    final EditClothingPhotoStateHolder state =
        ref.watch(editClothingPhotoViewModelProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8, bottom: 12, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBackButton(),
              SizedBox(height: 12),
              AppTextField(
                text: state.clothing.name,
                labelText: localizations.clothingName,
                onTextChanged: (text) {
                  viewModel.onNameTextChanged(text);
                },
                height: 64,
              ),
              AppDropdownButton(
                items: ClothingCategoryEnum.withoutAllCategory(),
                selectedItem: state.clothing.category,
                itemBuilder: (item) => Center(child: Text(item.text)),
                onItemSelect: (item) => viewModel.onCategorySelected(item),
                labelText: localizations.category,
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: EncryptedImage(
                  imageSrc: state.originalImagePath,
                  errorBuilder: (_) => ImageErrorWidget(),
                  loadingBuilder: () => ImageLoadingWidget(),
                  fit: BoxFit.cover,
                ).or(
                  ImageLoadingWidget(),
                  state.isPageLoading,
                ),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: PhotoModifyButtons(
                  isDeleteLoading: state.isDeleteLoading,
                  isSaveLoading: state.isSaveLoading,
                  onDeleteClicked: () async {
                    await viewModel.deleteClothing(
                        () => context.pop(widget.clothing.withDeleteAction()));
                  },
                  onSaveClicked: () async {
                    await viewModel.updateClothing((updatedClothing) =>
                        context.pop(updatedClothing.withUpdateAction()));
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
