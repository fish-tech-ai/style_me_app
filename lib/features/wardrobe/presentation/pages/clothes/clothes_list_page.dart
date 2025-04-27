import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/views/input/search_text_field.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/presentation/components/empty_page.dart';
import 'package:style_me/features/wardrobe/presentation/components/filtering_view.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_grid.dart';
import 'package:style_me/features/wardrobe/presentation/pages/clothes/edit_clothing_page.dart';
import 'package:style_me/features/wardrobe/presentation/state/states/clothing/clothes_list_state.dart';
import 'package:style_me/features/wardrobe/presentation/state/viewmodels/clothing/clothes_list_view_model.dart';
import 'package:style_me/features/wardrobe/presentation/ui_models/photo_with_action.dart';

class ClothesListPage extends ConsumerStatefulWidget {
  /// if not null, will be used instead clothes that comes from [onClothesLoaded]
  final List<Clothing>? clothes;

  /// by default navigates to [EditClothingPage] for the result ([PhotoWithAction]),
  /// then updates list or an item if it has been deleted or updated.
  final Function(PhotoItem)? onItemClicked;

  /// [onClothesLoaded] will be called after downloading the user's clothing list.
  /// NOTE: This callback will be called at every rebuild if the clothing list is downloaded.
  final Function(List<Clothing>)? onClothesLoaded;
  final ScrollController? scrollController;

  const ClothesListPage({
    super.key,
    this.clothes,
    this.onItemClicked,
    this.onClothesLoaded,
    this.scrollController,
  });

  @override
  ConsumerState<ClothesListPage> createState() => _ClothesListPageState();
}

class _ClothesListPageState extends ConsumerState<ClothesListPage> {
  late final ClothesListViewModel viewModel;

  @override
  void initState() {
    viewModel = ref.read(clothesListViewModelProvider.notifier)
      ..setOnLoadedListener(widget.onClothesLoaded);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ClothesListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.didUpdateWidget(widget.clothes, oldWidget.clothes);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ClothesListState state = ref.watch(clothesListViewModelProvider);
    return Padding(
      padding: EdgeInsets.only(top: 4, left: 12, right: 12),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(viewModel, state),
          Flexible(
              fit: FlexFit.loose,
              child: _buildClothesPage(context, viewModel, state)),
        ],
      ),
    );
  }

  Widget _buildHeader(ClothesListViewModel viewModel, ClothesListState state) {
    return Column(
      spacing: 6,
      children: [
        buildSearchTextField(viewModel, state),
        buildFilterView(viewModel, state),
      ],
    );
  }

  Widget buildSearchTextField(
      ClothesListViewModel viewModel, ClothesListState state) {
    return SearchTextField(
      text: state.searchText,
      onTextChanged: viewModel.onSearchTextChanged,
    );
  }

  Widget buildFilterView(
      ClothesListViewModel viewModel, ClothesListState state) {
    return FilteringView(
      selectedPosition: state.filterPosition,
      selectedCategory: state.filterCategory,
      onFiltersClose: viewModel.clearFilters,
      onFiltersChange: viewModel.onFiltersChanged,
    );
  }

  Widget _buildClothesPage(BuildContext context, ClothesListViewModel viewModel,
      ClothesListState state) {
    if (!state.isClothesLoading && state.clothes.isEmpty) {
      return EmptyPage();
    }
    return PhotoGrid(
      items: state.clothes,
      scrollController: widget.scrollController,
      onItemClicked: (item) {
        if (widget.onItemClicked != null) {
          widget.onItemClicked?.call(item);
          return;
        }
          defaultOnItemClicked(item, context, viewModel);
      },
    ).orLoading(state.isClothesLoading);
  }

  void defaultOnItemClicked(
    PhotoItem photoItem,
    BuildContext context,
    ClothesListViewModel viewModel,
  ) async {
    final PhotoWithAction? clothingWithAction = await context
        .push(AppPage.editClothingPage.path, extra: photoItem as Clothing);
    if (clothingWithAction != null) {
      viewModel.onClothingModifyResult(clothingWithAction);
    }
  }
}
