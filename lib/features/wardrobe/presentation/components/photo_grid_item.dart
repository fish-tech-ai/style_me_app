import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/core/views/buttons/app_icon_button.dart';
import 'package:style_me/core/views/encrypted_image/encrypted_image.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_error_widget.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_loading_widget.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

class PhotoGridItem extends StatelessWidget {
  final PhotoItem photo;
  final double labelWidthFraction;
  final Function(PhotoItem photo) onItemClicked;

  /// when null favorite button will not appear
  final Function(PhotoItem photo)? onFavoriteClicked;

  /// when null delete button will not appear
  final Function(PhotoItem photo)? onDeleteClicked;

  /// when null download button will not appear
  final Function(PhotoItem photo)? onDownloadClicked;

  const PhotoGridItem({
    super.key,
    required this.photo,
    required this.onItemClicked,
    this.labelWidthFraction = 2.6,
    this.onDeleteClicked,
    this.onFavoriteClicked,
    this.onDownloadClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.grey,
        photo.isDisabled ? BlendMode.saturation : BlendMode.dst,
      ),
      child: InkWell(
        onTap: () => onItemClicked(photo),
        borderRadius: GlobalUiConst.borderRadiusExtraLarge,
        child: Stack(
          fit: StackFit.loose,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: photo.isSelected
                      ? Border.all(color: context.colorScheme.primary, width: 4)
                      : null,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: ClipRRect(
                  borderRadius: GlobalUiConst.borderRadiusExtraLarge,
                  child: EncryptedImage(
                    imageSrc: photo.image,
                    fit: BoxFit.cover,
                    loadingBuilder: () {
                      return ImageLoadingWidget();
                    },
                    errorBuilder: (stackTrace) {
                      debugPrintStack(stackTrace: stackTrace);
                      return ImageErrorWidget();
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: -6,
              left: -6,
              child: _buildIsDefaultIndicator(context),
            ).orEmpty(!photo.isDefault),
            Positioned(
              bottom: 28,
              left: 0,
              child: _buildNameLabel(context),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: _buildSelectedIndicator(context),
            ).orEmpty(!photo.isSelected),
            Positioned(
              top: 0,
              right: 0,
              child: _wideClickableArea(
                child: _buildDeleteButton(context),
                onClick: onDeleteClicked,
              ),
            ).orEmpty(onDeleteClicked == null),
            Positioned(
              top: 0,
              right: 0,
              child: _wideClickableArea(
                child: _buildFavoriteButton(context),
                onClick: onFavoriteClicked,
              ),
            ).orEmpty(onFavoriteClicked == null),
            Positioned(
              top: 0,
              left: 0,
              child: _wideClickableArea(
                child: _buildDownloadButton(context),
                onClick: onDownloadClicked,
              ),
            ).orEmpty(onDownloadClicked == null),
            Positioned(
              top: 16,
              right: 16,
              child: _buildDisabledIndicator(context),
            ).orEmpty(!photo.isDisabled)
          ],
        ),
      ),
    );
  }

  Widget _buildNameLabel(BuildContext context) {
    final radius = Radius.circular(12);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width / labelWidthFraction,
        ),
        decoration: BoxDecoration(
          color: context.customColors.accentA80,
          borderRadius: BorderRadius.only(
            topRight: radius,
            bottomRight: radius,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        margin: EdgeInsets.only(right: 12),
        child: Text(
          photo is Clothing
              ? "${(photo as Clothing).category.text}: ${photo.name}"
              : photo.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildIsDefaultIndicator(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.colorScheme.primary,
          borderRadius: BorderRadius.circular(14)),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(localizations.defaultText),
    );
  }

  Widget _buildSelectedIndicator(BuildContext context) {
    String? categoryText;
    if (photo is Clothing) {
      categoryText = (photo as Clothing).position.text;
    }
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: GlobalUiConst.borderRadiusExtraLarge,
      ),
      child: categoryText != null
          ? Text(
              categoryText,
              style: TextStyle(color: context.colorScheme.onPrimary),
            )
          : Icon(
              Icons.check_rounded,
              color: context.colorScheme.onPrimary,
            ),
    );
  }

  Widget _wideClickableArea(
      {Function(PhotoItem)? onClick, required Widget child}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onClick?.call(photo);
      },
      child: Padding(
        padding: EdgeInsets.all(12),
        child: IgnorePointer(child: child),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return AppIconButton(
      icon: Icon(Icons.close_rounded, color: context.colorScheme.onSurface),
      borderRadius: BorderRadius.circular(100),
      padding: EdgeInsets.all(6),
      backgroundColor: context.colorScheme.error,
      onClick: () {},
    );
  }

  Widget _buildDisabledIndicator(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: context.theme.hintColor),
      child: Icon(
        Icons.not_interested_rounded,
        color: context.theme.disabledColor,
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return AppIconButton(
      icon: Icon(
        photo.isFavorite
            ? Icons.favorite_rounded
            : Icons.favorite_border_rounded,
        color: photo.isFavorite
            ? context.colorScheme.onPrimary
            : context.colorScheme.primary,
      ),
      backgroundColor: photo.isFavorite
          ? context.colorScheme.primary
          : context.colorScheme.secondary,
      borderRadius: GlobalUiConst.borderRadiusSmall,
      padding: EdgeInsets.all(6),
      onClick: () {},
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return AppIconButton(
      icon: Icon(
        Icons.file_download_outlined,
        color: context.colorScheme.onPrimary,
      ),
      borderRadius: GlobalUiConst.borderRadiusSmall,
      padding: EdgeInsets.all(6),
      onClick: () {},
    );
  }
}
