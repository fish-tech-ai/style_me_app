import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/views/buttons/floating/floating_add_user_photo_button.dart';
import 'package:style_me/core/views/default_loading_page.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';
import 'package:style_me/features/wardrobe/presentation/components/empty_page.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_grid.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/wardrobe_state_holder.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/photo_with_action.dart';

class UserPhotosListPage extends StatelessWidget {
  final WardrobeStateHolder state;
  final Function(PhotoWithAction) onModifyResult;

  const UserPhotosListPage({
    super.key,
    required this.state,
    required this.onModifyResult,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6, left: 12, right: 12),
      child: _buildUserPhotosPage(context),
    );
  }

  Widget _buildUserPhotosPage(BuildContext context) {
    if (!state.isUserPhotosLoading && state.userPhotos.isEmpty) {
      return _buildWithAddButtonIfNeeded(
        context,
        child: EmptyPage(
          title: localizations.nothingFound,
          subTitle: localizations.nothingFoundSubText,
        ),
      );
    } else if (state.isUserPhotosLoading) {
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: 200,
          child: DefaultLoading(),
        ),
      );
    }

    return _buildWithAddButtonIfNeeded(
      context,
      child: PhotoGrid(
        items: state.userPhotos,
        clipBehavior: Clip.none,
        bottomInset: 72,
        onItemClicked: (item) => onItemClicked(item, context),
      ),
    );
  }

  Widget _buildWithAddButtonIfNeeded(BuildContext context,
      {required Widget child}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          bottom: 12,
          right: 12,
          child: FloatingAddUserPhotoButton(
            onClick: () {
              context.push(AppPage.userPhotoAdd.path);
            },
          ),
        )
      ],
    );
  }

  void onItemClicked(PhotoItem photoItem, BuildContext context) async {
    final PhotoWithAction? userPhotoWithAction = await context
        .push(AppPage.editUserPhotoPage.path, extra: photoItem as UserPhoto);
    if (userPhotoWithAction != null) {
      onModifyResult(userPhotoWithAction);
    }
  }
}
