import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/views/encrypted_image/encrypted_image.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_error_widget.dart';
import 'package:style_me/features/wardrobe/presentation/components/image_loading_widget.dart';

class PhotosPager<T extends PhotoItem> extends StatefulWidget {
  final List<T> photos;
  final Function(T photo) onPageChange;

  const PhotosPager(
      {super.key, required this.photos, required this.onPageChange});

  @override
  State<PhotosPager> createState() => _PhotosPagerState();
}

class _PhotosPagerState extends State<PhotosPager> {
  late PageController _pagerController;

  @override
  void initState() {
    super.initState();
    _pagerController = PageController();
  }

  @override
  void dispose() {
    _pagerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: PageView(
            controller: _pagerController,
            onPageChanged: (int index) {
              widget.onPageChange(widget.photos[index]);
            },
            children: widget.photos
                .map(
                  (photo) => EncryptedImage(
                    imageSrc: photo.image,
                    errorBuilder: (stackTrace) {
                      debugPrintStack(stackTrace: stackTrace);
                      return ImageErrorWidget();
                    },
                    loadingBuilder: () => ImageLoadingWidget(),
                  ),
                )
                .toList(),
          ),
        ),
        Positioned(
          top: 56,
          child: SmoothPageIndicator(
            controller: _pagerController,
            count: widget.photos.length,
            effect: ExpandingDotsEffect(
              activeDotColor: context.colorScheme.primary,
              dotColor: context.colorScheme.secondary,
              offset: 0
            ),
          ),
        )
      ],
    );
  }
}
