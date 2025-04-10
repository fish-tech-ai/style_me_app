import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/views/default_loading_page.dart';
import 'package:style_me/core/views/popups/app_persistent_bottom_sheet.dart';
import 'package:style_me/features/checkroom/presentation/state/checkroom_state_holder.dart';
import 'package:style_me/features/checkroom/presentation/state/checkroom_view_model.dart';
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
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned.fill(child: buildOverlayIfNeeded(state)),
        ...buildContent(),
      ],
    );
  }

  Widget buildOverlayIfNeeded(CheckroomStateHolder state) {
    if (state.isLoading) {
      return DefaultLoading();
    } else if (!state.canShowPageContent) {
      return buildAddPhotosInfoPage();
    }
    return SizedBox();
  }

  Widget buildAddPhotosInfoPage() {
    return Text("addPhotosInfoPage");
  }

  List<Widget> buildContent() {
    return [
      Positioned.fill(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AppPersistentBottomSheet(
              builder: (scrollController, draggableController) =>
                  SizedBox(
                height: constraints.maxHeight - 24,
                child: ClothesListPage(
                  onItemClicked: (item) {},
                  onClothesLoaded: viewModel.onClothesLoaded,
                  scrollController: scrollController,
                ),
              ),
            );
          },
        ),
      )
    ];
  }
}
