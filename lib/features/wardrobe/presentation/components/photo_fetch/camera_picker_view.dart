import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/views/buttons/app_icon_button.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_fetch/photo_take_button.dart';

class CameraPickerView extends StatelessWidget {
  final CameraController controller;
  final Function() onOpenGalleryClicked;
  final Function() onRotateCameraClicked;
  final Function(double aspectRatio) onTakePictureClicked;
  final Function() onPasteFromClipboard;

  const CameraPickerView({
    super.key,
    required this.controller,
    required this.onOpenGalleryClicked,
    required this.onRotateCameraClicked,
    required this.onTakePictureClicked,
    required this.onPasteFromClipboard,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        CameraValue camera = controller.value;
        double parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
        double scale = parentAspectRatio * camera.aspectRatio;
        if (scale < 1) scale = 1 / scale;
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.flip(
              flipX: controller.description.lensDirection ==
                  CameraLensDirection.front,
              child: Transform.scale(
                scale: scale,
                child: Center(
                  child: CameraPreview(
                    controller,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              bottom: 24,
              child: AppIconButton(
                icon: Icon(Icons.image_outlined),
                onClick: onOpenGalleryClicked,
              ),
            ),
            Positioned(
              right: 24,
              bottom: 24,
              child: AppIconButton(
                icon: SvgPicture.asset("assets/circle_icon.svg"),
                backgroundColor: context.colorScheme.secondary,
                border: Border.all(color: context.colorScheme.primary),
                onClick: onRotateCameraClicked,
              ),
            ),
            Positioned(
              bottom: 56,
              child: PhotoTakeButton(
                onClick: () => onTakePictureClicked(parentAspectRatio),
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: AppIconButton(
                icon: Icon(Icons.content_paste_go_rounded),
                onClick: onPasteFromClipboard,
              ),
            ),
          ],
        );
      }),
    );
  }
}
