import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/views/buttons/app_icon_button.dart';
import 'package:style_me/core/views/default_loading_page.dart';
import 'package:style_me/core/views/popups/app_draggable_horizontal_sheet.dart';
import 'package:style_me/core/views/popups/app_persistent_bottom_sheet.dart';
import 'package:style_me/features/checkroom/presentation/components/checkroom_no_photos_info_page.dart';
import 'package:style_me/features/checkroom/presentation/components/photos_pager.dart';
import 'package:style_me/features/checkroom/presentation/state/checkroom_state_holder.dart';
import 'package:style_me/features/checkroom/presentation/state/checkroom_view_model.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/presentation/pages/clothes/clothes_list_page.dart';

class CheckroomPage extends ConsumerStatefulWidget {
  const CheckroomPage({super.key});

  @override
  ConsumerState<CheckroomPage> createState() => _CheckroomPageState();
}

class _CheckroomPageState extends ConsumerState<CheckroomPage> {
  late final CheckroomViewModel viewModel;

  @override
  void initState() {
    viewModel = ref.read(checkroomViewModelProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CheckroomStateHolder state = ref.watch(checkroomViewModelProvider);
    return Stack(
      children: [
        ...buildContent(state),
        Positioned.fill(child: buildOverlayIfNeeded(state)),
      ],
    );
  }

  Widget buildOverlayIfNeeded(CheckroomStateHolder state) {
    if (state.isLoading) {
      return DefaultLoading();
    } else if (!state.canShowPageContent) {
      return CheckroomNoPhotosInfoPage(
        isClothesEmpty: state.isClothesEmpty,
        isUserPhotosEmpty: state.isUserPhotosEmpty,
      );
    }
    return SizedBox();
  }

  List<Widget> buildContent(CheckroomStateHolder state) {
    return [
      Positioned.fill(
        child: PhotosPager(
          photos: state.userPhotos,
          onPageChange: viewModel.onUserPhotoChange,
        ),
      ).orEmpty(state.userPhotos.isEmpty),
      AppDraggableHorizontalSheet(
        child: Placeholder(),
      ),
      AppPersistentBottomSheet(
        builder: (scrollController) => ClothesListPage(
          clothes: state.clothes,
          onItemClicked: (item) =>
              viewModel.onClothingSelected(item as Clothing),
          onClothesLoaded: viewModel.onClothesLoaded,
          scrollController: scrollController,
        ),
      ),
      Positioned(
        top: 12,
        left: 12,
        child: AppIconButton(
          icon: SvgPicture.asset(
            "assets/bottom_nav_icons/wardrobe.svg",
            colorFilter: ColorFilter.mode(
              context.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          backgroundColor: context.colorScheme.secondary,
          border: Border.all(color: context.colorScheme.primary),
          onClick: () => context.push(AppPage.wardrobe.path),
        ),
      ),
    ];
  }
}
