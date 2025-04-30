import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/app_icon_button.dart';
import 'package:style_me/core/views/popups/app_draggable_horizontal_sheet.dart';
import 'package:style_me/core/views/popups/app_persistent_bottom_sheet.dart';
import 'package:style_me/core/views/ui_models/limit.dart';
import 'package:style_me/features/checkroom/presentation/components/checkroom_no_photos_info_page.dart';
import 'package:style_me/features/checkroom/presentation/components/photos_pager.dart';
import 'package:style_me/features/checkroom/presentation/components/selected_clothes_list.dart';
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
  final GlobalKey<AppPersistentBottomSheetState> clothesPersistentSheet =
      GlobalKey<AppPersistentBottomSheetState>();
  final GlobalKey<AppDraggableHorizontalSheetState> selectedClothesPersistentHorizontalSheet =
  GlobalKey<AppDraggableHorizontalSheetState>();

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
    if (!state.canShowPageContent) {
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
      ).orLoading(state.isLoading).orEmpty(state.userPhotos.isEmpty),
      Positioned(
        right: 12,
        bottom: 90,
        child: _buildTryOnButton(),
      ).orEmpty(state.selectedClothes.isEmpty),
      Positioned(
        top: 12,
        left: 12,
        child: _buildWardrobeButton(),
      ),
      AppDraggableHorizontalSheet(
        key: selectedClothesPersistentHorizontalSheet,
        child: SelectedClothesList(
          selectedClothes: state.selectedClothes,
          onDeleteClicked: (clothing) {
            viewModel.unselectClothingBy(clothing.id);
          },
        ),
      ).orEmpty(state.selectedClothes.isEmpty),
      AppPersistentBottomSheet(
        key: clothesPersistentSheet,
        onCollapse: () {
          FocusScope.of(context).unfocus();
        },
        builder: (scrollController) => ClothesListPage(
          clothes: state.clothes,
          onItemClicked: (item) =>
              viewModel.onClothingSelected(item as Clothing),
          onSearchParametersChanged: (searchParameters) {
            viewModel.onSearchParametersChanged(searchParameters);
          },
          onSearchClicked: () {
            clothesPersistentSheet.currentState?.animateTo(Limit.max);
          },
          isLoading: state.isClothesLoading,
          scrollController: scrollController,
        ),
      ),
    ];
  }

  Widget _buildWardrobeButton() {
    return AppIconButton(
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
    );
  }

  Widget _buildTryOnButton() {
    return AppButton(
      text: localizations.tryOn,
      style: ElevatedButton.styleFrom(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: GlobalUiConst.borderRadiusLarge,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24),
      onClick: () {
        //TODO request to backend
      },
    );
  }
}
