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

class PhotoFetcherState extends ConsumerState<PhotoFetcher>
    with WidgetsBindingObserver {
  late CameraController _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCameraLoading = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _initCameraController(0);

    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
        _isCameraLoading = false;
      });
    }).catchError((Object e) {
      if (e is CameraException && e.code == 'CameraAccessDenied') {
        setState(() {
          _isCameraInitialized = false;
        });
      }
      setState(() {
        _isCameraLoading = false;
      });
      debugMessagePrint(e.toString(), "STYLE_ME_PHOTO_LABEL: ");
    });
  }

  void _initCameraController(int index) {
    if (_cameras?.isEmpty == true) {
      return;
    }
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
  Widget build(BuildContext context) {
    return !_isCameraLoading
        ? CameraPickerView(
            controller: _controller,
            isInitialized: _isCameraInitialized,
            onOpenGalleryClicked: _openGetGalleryImage,
            onRotateCameraClicked: _switchCamera,
            onTakePictureClicked: (parentAspectRatio) =>
                _takePicture(parentAspectRatio),
            onPasteFromClipboard: _readClipboardForImage,
          )
        : Flexible(fit: FlexFit.loose, child: DefaultLoading());
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
