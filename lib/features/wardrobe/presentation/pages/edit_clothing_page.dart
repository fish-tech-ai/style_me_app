import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_back_button.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/app_outlined_button.dart';
import 'package:style_me/core/views/encrypted_image/encrypted_image.dart';
import 'package:style_me/core/views/input/app_text_field.dart';
import 'package:style_me/core/views/input/dropdowns/app_dropdown_button.dart';
import 'package:style_me/features/wardrobe/data/models/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/clothing_category_enum.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_error_widget.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_loading_widget.dart';
import 'package:style_me/features/wardrobe/presentation/state/edit_photo_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/edit_photo_view_model.dart';

class EditClothingPage extends ConsumerStatefulWidget {
  final Clothing clothing;

  const EditClothingPage({super.key, required this.clothing});

  @override
  ConsumerState<EditClothingPage> createState() => _EditClothingPageState();
}

class _EditClothingPageState extends ConsumerState<EditClothingPage> {
  late final EditPhotoViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(editPhotoViewModelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.init(widget.clothing);
    });
  }

  @override
  Widget build(BuildContext context) {
    final EditPhotoStateHolder state = ref.watch(editPhotoViewModelProvider);
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
                  imagePath: state.clothing.image,
                  errorBuilder: (_) => ImageErrorWidget(),
                  loadingBuilder: () => ImageLoadingWidget(),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Row(
                  spacing: 12,
                  children: [
                    AppOutlinedButton(
                      text: localizations.deleteClothing,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colorScheme.error,
                        backgroundColor: context.colorScheme.onError,
                        side: BorderSide(color: context.colorScheme.error),
                      ),
                      isLoading: state.isDeleteLoading,
                      onClick: () async {
                        await viewModel.deleteClothing(() =>
                            context.pop(widget.clothing.withDeleteAction()));
                      },
                    ),
                    AppButton(
                        text: localizations.save,
                        isLoading: state.isSaveLoading,
                        onClick: () async {
                          await viewModel.updateClothing((updatedClothing) =>
                              context.pop(updatedClothing.withUpdateAction()));
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
