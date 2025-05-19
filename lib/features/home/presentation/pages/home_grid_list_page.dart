import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    return Column(
      children: [
        AppTopBar(
          title: type.getTitle(),
        ),
        Expanded(
            child: PhotoGrid(
          items: state.outfits,
          onItemClicked: (photo) =>
              ref.context.push(AppPage.homeOutfitDetails.path, extra: photo),
          onFavoriteClicked: type == HomeGridType.recentOutfits
              ? getViewModel(ref).toggleFavoriteFor
              : null,
          onDeleteClicked: type == HomeGridType.favorites
              ? getViewModel(ref).deletePhoto
              : null,
          onDownloadClicked: (photo) {},
        ))
      ],
    );
  }

  HomeGridListViewModel getViewModel(WidgetRef ref) =>
      ref.read(homeGridListViewModelProvider(type).notifier);
}
