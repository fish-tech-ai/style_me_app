import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/views/buttons/floating/page_with_floating_add_button.dart';
import 'package:style_me/core/views/default_loading_page.dart';
import 'package:style_me/features/home/presentation/components/carousel.dart';
import 'package:style_me/features/home/presentation/components/home_header_banner.dart';
import 'package:style_me/features/home/presentation/components/home_section.dart';
import 'package:style_me/features/home/presentation/state/home_state_holder.dart';
import 'package:style_me/features/home/presentation/state/home_view_model.dart';
import 'package:style_me/features/home/presentation/ui_models/home_grid_type.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/presentation/components/empty_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    return PageWithFloatingAddButton(
      addClothingClicked: () {
        context.push(AppPage.clothingAdd.path);
      },
      addUserPhotoClicked: () {
        context.push(AppPage.userPhotoAdd.path);
      },
      child: state.when(
        data: (state) {
          return buildContent(
            state,
            context,
            onFavoriteClicked:
                ref.read(homeViewModelProvider.notifier).toggleFavoriteFor,
          );
        },
        error: (_, __) => buildEmptyPage(),
        loading: () => DefaultLoading(),
        skipError: true,
      ),
    );
  }

  Widget buildContent(HomeStateHolder state, BuildContext context,
      {required Function(PhotoItem outfit) onFavoriteClicked}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeHeaderBanner(userName: state.userName),
          buildCarousels(state, context, onFavoriteClicked)
              .or(buildEmptyPage(), state.noOutfitsAvailable()),
        ],
      ),
    );
  }

  Widget buildEmptyPage() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
        child: EmptyPage(
          title: localizations.homeEmptyPageTitle,
          subTitle: localizations.homeEmptyPageSubTitle,
        ),
      );

  Widget buildCarousels(HomeStateHolder state, BuildContext context,
      Function(PhotoItem outfit) onFavoriteClicked) {
    return Padding(
      padding: EdgeInsets.only(bottom: 96),
      child: Column(
        children: [
          HomeSection(
            title: localizations.homeSectionRecentOutfits,
            onSeeMoreClicked: () => context.push(AppPage.homeGridList.path,
                extra: HomeGridType.recentOutfits),
            child: PhotosCarousel(
              items: state.recentPhotos,
              onItemClicked: (outfit) =>
                  context.push(AppPage.homeOutfitDetails.path, extra: outfit),
              onItemFavoriteClicked: onFavoriteClicked,
            ),
          ).orEmpty(state.recentPhotos.isEmpty),
          HomeSection(
            title: localizations.homeSectionFavorites,
            onSeeMoreClicked: () => context.push(AppPage.homeGridList.path,
                extra: HomeGridType.favorites),
            child: PhotosCarousel(
              items: state.favorites,
              onItemClicked: (outfit) =>
                  context.push(AppPage.homeOutfitDetails.path, extra: outfit),
              onItemDeleteClicked: onFavoriteClicked,
            ),
          ).orEmpty(state.favorites.isEmpty)
        ],
      ),
    );
  }
}
