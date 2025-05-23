import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/app/presentation/components/app_status.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/views/app_top_bar.dart';
import 'package:style_me/core/views/default_loading_page.dart';
import 'package:style_me/features/home/presentation/state/home_grid_list/home_grid_list_state_holder.dart';
import 'package:style_me/features/home/presentation/state/home_grid_list/home_grid_list_view_model.dart';
import 'package:style_me/features/home/presentation/ui_models/home_grid_type.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_grid.dart';

class HomeGridListPage extends ConsumerWidget {
  final HomeGridType type;

  const HomeGridListPage({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HomeGridListStateHolder> state =
        ref.watch(homeGridListViewModelProvider(type));
    return state.when(
      data: (state) => buildContent(state, ref),
      error: (_, __) => SizedBox(),
      loading: () => DefaultLoading(),
    );
  }

  Widget buildContent(HomeGridListStateHolder state, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          AppTopBar(
            title: type.getTitle(),
          ),
          Expanded(
            child: Stack(
              children: [
                PhotoGrid(
                  items: state.outfits,
                  onItemClicked: (photo) => ref.context
                      .push(AppPage.homeOutfitDetails.path, extra: photo),
                  onFavoriteClicked: type == HomeGridType.recentOutfits
                      ? getViewModel(ref).toggleFavoriteFor
                      : null,
                  onDeleteClicked: type == HomeGridType.favorites
                      ? getViewModel(ref).deletePhoto
                      : null,
                  onDownloadClicked: getViewModel(ref).downloadPhoto,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 4,
                  child: InkWell(
                    onTap: () {
                      AppSettings.openAppSettings();
                    },
                    child: AppStatus.text(
                      color: ref.context.colorScheme.error,
                      textColor: ref.context.colorScheme.onError,
                      text: localizations.galTypeAccessDenied,
                      endEdgeWidget: _buildTextButton(),
                    ).orEmpty(!state.isNoPermissionSnackBarVisible),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 4,
                  child: AppStatus.text(
                    color: ref.context.colorScheme.primary,
                    textColor: ref.context.colorScheme.onPrimary,
                    text: localizations.downloadingInProgress,
                    endEdgeWidget: Transform.scale(
                      scale: 0.6,
                      child: CircularProgressIndicator(
                        color: ref.context.colorScheme.onPrimary,
                      ),
                    ),
                  ).orEmpty(!state.isDownloading),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  HomeGridListViewModel getViewModel(WidgetRef ref) =>
      ref.read(homeGridListViewModelProvider(type).notifier);

  Widget _buildTextButton() {
    return Row(
      children: [
        Text(localizations.downloadNoPermissionsButtonText),
        Icon(Icons.keyboard_arrow_right_rounded, size: 16)
      ],
    );
  }
}
