import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/extensions/file_ext.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/clipboard.dart';
import 'package:style_me/core/views/app_top_bar.dart';
import 'package:style_me/core/views/default_loading_page.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_fetch/camera_picker_view.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_fetch/image_acceptation_view.dart';

class PhotoFetcher extends ConsumerStatefulWidget {
  final String topBarTitle;
  final Function(File) onImageAccepted;

  const PhotoFetcher({
    super.key,
    required this.onImageAccepted,
    required this.topBarTitle,
  });

  @override
  ConsumerState<PhotoFetcher> createState() => _PhotoFetcherState();
}

class _PhotoFetcherState extends ConsumerState<PhotoFetcher> {
  late CameraController _controller;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  File? imageFile;
  bool fromGallery = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    initCameraController(0);

    await _controller.initialize();
    if (!mounted) return;
    setState(() {
      isCameraInitialized = true;
    });
  }

  void initCameraController(int index) {
    _controller = CameraController(
      cameras![index],
      ResolutionPreset.medium,
      enableAudio: false,
    );
  }

  void readClipboardForImage() async {
    final clipboard = Clipboard();
    clipboard.fetchImageFile(onImageReceived: (File file) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          imageFile = file;
        });
      });
    }, onNoImageInClipboard: () {
      ref
          .read(appGlobalViewModelProvider.notifier)
          .showErrorMessage(localizations.noImageInClipboard);
    });
  }

  Future<void> takePicture(double parentAspectRatio) async {
    if (!_controller.value.isInitialized) return;
    try {
      XFile xFile = await _controller.takePicture();
      File image = File(xFile.path);

      final File croppedImage =
          await image.getWithAspectRatio(parentAspectRatio);

      setState(() {
        imageFile = croppedImage;
      });
    } catch (e) {
      debugMessagePrint("Error capturing image: $e");
    }
  }

  Future<void> switchCamera() async {
    if (cameras == null || cameras!.isEmpty) return;

    int newIndex = _controller.description == cameras?[0] ? 1 : 0;
    initCameraController(newIndex);

    await _controller.initialize();
    setState(() {});
  }

  void clearImage() {
    setState(() {
      imageFile = null;
      fromGallery = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: imageFile == null,
      onPopInvokedWithResult: (_, __) {
        clearImage();
      },
      child: Column(
        children: [
          AppTopBar(
            title: widget.topBarTitle,
            onBackButtonClicked: () {
              if (imageFile != null) {
                clearImage();
              } else {
                context.pop();
              }
            },
          ),
          isCameraInitialized
              ? imageFile != null
                  ? ImageAcceptationView(
                      imageFile: imageFile!,
                      shouldFlip: !fromGallery && _controller.description.lensDirection ==
                              CameraLensDirection.front,
                      onTryAgainClicked: clearImage,
                      onAcceptClicked: () => onImageAccepted(imageFile!),
                    )
                  : CameraPickerView(
                      controller: _controller,
                      onOpenGalleryClicked: openGetGalleryImage,
                      onRotateCameraClicked: switchCamera,
                      onTakePictureClicked: (parentAspectRatio) =>
                          takePicture(parentAspectRatio),
                      onPasteFromClipboard: readClipboardForImage,
                    )
              : DefaultLoading(),
        ],
      ),
    );
  }

  void openGetGalleryImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        fromGallery = true;
        imageFile = File(image.path);
      });
    }
  }

  void onImageAccepted(File imageFile) async {
    File image = imageFile;
    if (_controller.description.lensDirection == CameraLensDirection.front) {
      image = await image.getFlippedHorizontally();
    }
    widget.onImageAccepted(image);
  }
}
