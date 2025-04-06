import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/buttons/app_back_button.dart';
import 'package:style_me/core/views/encrypted_image/encrypted_image.dart';
import 'package:style_me/core/views/input/app_checkbox.dart';
import 'package:style_me/core/views/input/app_text_field.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_error_widget.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_loading_widget.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_modify_buttons.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/user_photo/edit_user_photo_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/user_photo/edit_user_photo_view_model.dart';

class EditUserPhotoPage extends ConsumerStatefulWidget {
  final UserPhoto userPhoto;

  const EditUserPhotoPage({super.key, required this.userPhoto});

  @override
  ConsumerState<EditUserPhotoPage> createState() => _EditUserPhotoPageState();
}

class _EditUserPhotoPageState extends ConsumerState<EditUserPhotoPage> {
  late final EditUserPhotoViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(editUserPhotoViewModelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.init(widget.userPhoto);
    });
  }

  @override
  Widget build(BuildContext context) {
    final EditUserPhotoStateHolder state =
        ref.watch(editUserPhotoViewModelProvider);
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
                text: state.userPhoto.name,
                labelText: localizations.nameLabel,
                onTextChanged: (text) {
                  viewModel.onNameTextChanged(text);
                },
                height: 64,
              ),
              AppCheckbox(
                value: state.userPhoto.isDefault,
                title: localizations.setAsDefault,
                onChanged: (isChecked) =>
                    viewModel.onIsDefaultChanged(isChecked!),
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
                    await viewModel.deleteUserPhoto(
                        () => context.pop(widget.userPhoto.withDeleteAction()));
                  },
                  onSaveClicked: () async {
                    await viewModel.updateUserPhoto((updatedUserPhoto) =>
                        context.pop(updatedUserPhoto.withUpdateAction()));
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
