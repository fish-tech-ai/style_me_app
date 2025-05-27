import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/app_top_bar.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/app_icon_button.dart';
import 'package:style_me/core/views/default_loading_page.dart';
import 'package:style_me/core/views/encrypted_image/encrypted_image.dart';
import 'package:style_me/core/views/ui_models/app_button_icon_data.dart';
import 'package:style_me/core/views/ui_models/icon_position.dart';
import 'package:style_me/features/home/data/models/outfit.dart';
import 'package:style_me/features/home/presentation/state/details/outfit_details_state_holder.dart';
import 'package:style_me/features/home/presentation/state/details/outfit_details_view_model.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_error_widget.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_loading_widget.dart';

class OutfitDetailsPage extends ConsumerWidget {
  final Outfit outfit;

  const OutfitDetailsPage({super.key, required this.outfit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outfitDetailsViewModelProvider(outfit));
    return state.when(
      data: (stateValue) => buildContent(stateValue, ref),
      error: (err, stack) {
        debugPrintStack(label: "OutfitDetailsPage", stackTrace: stack);
        return SizedBox();
      },
      loading: () => DefaultLoading(),
    );
  }

  Widget buildContent(OutfitDetailsStateHolder state, WidgetRef ref) {
    return Column(
      children: [
        AppTopBar(
          title: outfit.name,
          rightCornerChild: buildLikeButton(state.isFavorite, ref),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              EncryptedImage(
                fit: BoxFit.fitWidth,
                imageSrc: state.outfit.image,
                errorBuilder: (_) => ImageErrorWidget(),
                loadingBuilder: () => ImageLoadingWidget(),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: AppButton(
                  text: localizations.download,
                  icon: AppButtonIconData.iconData(
                    Icons.file_download_outlined,
                    IconPosition.leading,
                  ),
                  width: 130,
                  isLoading: state.isDownloading,
                  onClick: () {
                    ref
                        .read(outfitDetailsViewModelProvider(outfit).notifier)
                        .downloadOutfit();
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildLikeButton(bool isFavorite, WidgetRef ref) {
    return SizedBox(
      width: 48,
      height: 58,
      child: AppIconButton(
        icon: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFavorite
              ? ref.context.colorScheme.onPrimary
              : ref.context.colorScheme.primary,
        ),
        backgroundColor: isFavorite
            ? ref.context.colorScheme.primary
            : ref.context.colorScheme.secondary,
        border: Border.all(color: ref.context.colorScheme.primary),
        padding: EdgeInsets.zero,
        onClick: () => ref
            .read(outfitDetailsViewModelProvider(outfit).notifier)
            .toggleIsFavorite(),
      ),
    );
  }
}
