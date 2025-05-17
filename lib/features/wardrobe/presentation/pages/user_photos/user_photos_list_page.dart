import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';
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
      return EmptyPage(
        title: localizations.nothingFound,
        subTitle: localizations.nothingFoundSubText,
      );
    }
    return PhotoGrid(
      items: state.userPhotos,
      clipBehavior: Clip.none,
      onItemClicked: (item) => onItemClicked(item, context),
    ).orLoading(state.isUserPhotosLoading);
  }

  void onItemClicked(PhotoItem photoItem, BuildContext context) async {
    final PhotoWithAction? userPhotoWithAction = await context
        .push(AppPage.editUserPhotoPage.path, extra: photoItem as UserPhoto);
    if (userPhotoWithAction != null) {
      onModifyResult(userPhotoWithAction);
    }
  }
}
