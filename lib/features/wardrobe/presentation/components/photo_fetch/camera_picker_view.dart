import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/views/animators/countdown_timer.dart';
import 'package:style_me/core/views/buttons/app_button.dart';
import 'package:style_me/core/views/buttons/app_icon_button.dart';
import 'package:style_me/core/views/ui_models/app_button_icon_data.dart';
import 'package:style_me/core/views/ui_models/countdown_option_enum.dart';
import 'package:style_me/core/views/ui_models/icon_position.dart';
import 'package:style_me/features/wardrobe/presentation/components/add_photos/expandable_timer_picker.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_fetch/photo_take_button.dart';

class CameraPickerView extends StatefulWidget {
  final CameraController controller;
  final bool isInitialized;
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
    required this.isInitialized,
  });

  @override
  State<CameraPickerView> createState() => _CameraPickerViewState();
}

class _CameraPickerViewState extends State<CameraPickerView> {
  bool isTimerPickerExpanded = false;
  bool showCountdownTimer = false;
  int? _countdownTime;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        double? parentAspectRatio;
        double? scale;

        if (widget.isInitialized) {
          CameraValue camera = widget.controller.value;
          parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
          scale = parentAspectRatio * camera.aspectRatio;
          if (scale < 1) scale = 1 / scale;
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            _buildCameraPreview(constraints, scale ?? 1),
            Positioned(
              left: 24,
              bottom: 24,
              child: AppIconButton(
                icon: Icon(Icons.image_outlined),
                onClick: widget.onOpenGalleryClicked,
              ),
            ),
            Positioned(
              right: 24,
              bottom: 24,
              child: AppIconButton(
                icon: SvgPicture.asset("assets/circle_icon.svg"),
                backgroundColor: context.colorScheme.secondary,
                border: Border.all(color: context.colorScheme.primary),
                onClick: widget.onRotateCameraClicked,
              ),
            ).orEmpty(!widget.isInitialized),
            Positioned(
              bottom: 56,
              child: PhotoTakeButton(
                onClick: () async {
                  await countdownIfNeeded();
                  return widget.onTakePictureClicked(parentAspectRatio ?? 1);
                },
              ),
            ).orEmpty(!widget.isInitialized),
            Positioned(
              right: 12,
              top: 12,
              child: AppIconButton(
                icon: Icon(Icons.content_paste_go_rounded),
                onClick: widget.onPasteFromClipboard,
              ),
            ),
            Positioned(
              left: 12,
              top: 12,
              child: ExpandableTimerPicker(
                onOptionSelected: _setCountdownTime,
              ),
            ).orEmpty(!widget.isInitialized),
            Positioned.fill(
              child: CountdownTimer(_countdownTime),
            ).orEmpty(!showCountdownTimer),
          ],
        );
      }),
    );
  }

  Widget _buildCameraPreview(BoxConstraints constraints, double scale) {
    if (widget.isInitialized) {
      return Transform.flip(
        flipX: widget.controller.description.lensDirection ==
            CameraLensDirection.front,
        child: Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(
              widget.controller,
            ),
          ),
        ),
      );
    } else {
      return _buildMissingPermissionPage(constraints);
    }
  }

  Widget _buildMissingPermissionPage(BoxConstraints constraints) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.no_photography_rounded, size: 72),
          Text(
            localizations.photoFetcherNoCameraPermissionsTitle,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
          ),
          Text(
            localizations.photoFetcherNoCameraPermissionsSubtitle,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          AppButton(
            text: localizations.photoFetcherNoCameraPermissionsGoToSettings,
            icon: AppButtonIconData.iconData(
                Icons.keyboard_arrow_right_rounded, IconPosition.trailing),
            onClick: () {
              AppSettings.openAppSettings();
            },
          )
        ],
      ),
    );
  }

  void _setCountdownTime(CountdownOptionEnum? option) {
    _countdownTime = option?.value ?? 0;
  }

  Future<void> countdownIfNeeded() async {
    if (_countdownTime == null || _countdownTime == 0) return;

    setState(() {
      showCountdownTimer = true;
    });
    for (int i = _countdownTime!; i >= 0; i--) {
      setState(() {
        _countdownTime = i;
      });
      await Future.delayed(const Duration(seconds: 1));
    }
    setState(() {
      showCountdownTimer = false;
      _countdownTime = null;
    });
  }
}
