import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/extensions/file_ext.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/clipboard.dart';
import 'package:style_me/core/views/default_loading_page.dart';
import 'package:style_me/features/wardrobe/presentation/components/photo_fetch/camera_picker_view.dart';

class PhotoFetcher extends ConsumerStatefulWidget {
  final Function(File) onImageFetched;

  const PhotoFetcher({
    super.key,
    required this.onImageFetched,
  });

  @override
  ConsumerState<PhotoFetcher> createState() => PhotoFetcherState();
}

class PhotoFetcherState extends ConsumerState<PhotoFetcher> {
  late CameraController _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _initCameraController(0);

    await _controller.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });
  }

  void _initCameraController(int index) {
    _controller = CameraController(
      _cameras![index],
      ResolutionPreset.medium,
      enableAudio: false,
    );
  }

  void _readClipboardForImage() async {
    final clipboard = Clipboard();
    clipboard.fetchImageFile(onImageReceived: (File file) {
      _onImageFetched(file);
    }, onNoImageInClipboard: () {
      ref
          .read(appGlobalViewModelProvider.notifier)
          .showErrorMessage(localizations.noImageInClipboard);
    });
  }

  Future<void> _takePicture(double parentAspectRatio) async {
    if (!_controller.value.isInitialized) return;
    try {
      XFile xFile = await _controller.takePicture();
      File image = File(xFile.path);

      final File croppedImage =
          await image.getWithAspectRatio(parentAspectRatio);

      _onImageFetched(croppedImage);
    } catch (e) {
      debugMessagePrint("Error capturing image: $e");
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.isEmpty) return;

    int newIndex = _controller.description == _cameras?[0] ? 1 : 0;
    _initCameraController(newIndex);

    await _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isCameraInitialized
        ? CameraPickerView(
            controller: _controller,
            onOpenGalleryClicked: _openGetGalleryImage,
            onRotateCameraClicked: _switchCamera,
            onTakePictureClicked: (parentAspectRatio) =>
                _takePicture(parentAspectRatio),
            onPasteFromClipboard: _readClipboardForImage,
          )
        : DefaultLoading();
  }

  void _openGetGalleryImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageFile = File(image.path);
      _onImageFetched(imageFile, true);
    }
  }

  void _onImageFetched(File imageFile, [bool fromGallery = false]) async {
    File image = imageFile;
    if (!fromGallery &&
        _controller.description.lensDirection == CameraLensDirection.front) {
      image = await image.getFlippedHorizontally();
    }
    widget.onImageFetched(
      image,
    );
  }
}
