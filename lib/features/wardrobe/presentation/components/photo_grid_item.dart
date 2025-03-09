import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_error_widget.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_loading_widget.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

class PhotoGridItem extends StatelessWidget {
  final PhotoItem item;
  final Function(PhotoItem photoItem) onItemClicked;

  const PhotoGridItem(
      {super.key, required this.item, required this.onItemClicked});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return ImageLoadingWidget();
                },
                errorBuilder: (context, error, stackTrace) {
                  return ImageErrorWidget();
                },
              ),
            ),
          ),
          Positioned(
            top: -6,
            left: -6,
            child: _buildIsDefaultIndicator(context),
          ).orEmpty(!item.isDefault),
          Positioned(
            bottom: 28,
            left: 0,
            child: _buildNameLabel(context, constraints),
          ),
        ],
      );
    });
  }

  Widget _buildNameLabel(BuildContext context, BoxConstraints constraints) {
    final radius = Radius.circular(12);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: constraints.maxWidth,
      ),
      child: Container(
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
          item.imageName,
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
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(localizations.defaultText),
    );
  }
}
