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
  bool _hasCameraController = false;
  Future<void>? _pendingDispose;
  bool _isInitializing = false;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCameraLoading = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _disposeCameraController();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_hasCameraController) {
      _hasCameraController = false;
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      await _prepareCamera();
    } catch (e) {
      _setCameraState(initialized: false, loading: false);
      debugMessagePrint(e.toString(), "STYLE_ME_PHOTO_LABEL: ");
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> _prepareCamera() async {
    final cameras = await _loadCameras();

    if (cameras == null || cameras.isEmpty) {
      _setCameraState(initialized: false, loading: false);
      return;
    }

    _setCameraState(initialized: false, loading: true);

    await _pendingDispose;
    await _disposeCameraController();

    await _startCamera(0);
  }

  Future<List<CameraDescription>?> _loadCameras() async {
    _cameras ??= await availableCameras();
    return _cameras;
  }

  Future<void> _startCamera(int index) async {
    if (!mounted) return;
    _initCameraController(index);
    await _controller.initialize();
    _setCameraState(initialized: true, loading: false);
  }

  Future<void> _disposeCameraController() async {
    if (!_hasCameraController) return;
    _hasCameraController = false;
    _setCameraState(initialized: false, loading: true);

    final future = _controller.dispose();
    _pendingDispose = future;
    await future;
    if (identical(_pendingDispose, future)) {
      _pendingDispose = null;
    }
  }

  void _initCameraController(int index) {
    if (_cameras == null || _cameras!.isEmpty) {
      return;
    }
    _controller = CameraController(
      _cameras![index],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _hasCameraController = true;
  }

  void _setCameraState({required bool initialized, required bool loading}) {
    if (!mounted) return;
    setState(() {
      _isCameraInitialized = initialized;
      _isCameraLoading = loading;
    });
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
    final cameras = _cameras;
    if (cameras == null || cameras.isEmpty || _isInitializing) return;
    _isInitializing = true;

    try {
      final newIndex = cameras.indexOf(_controller.description) == 0 ? 1 : 0;
      await _disposeCameraController();

      await _startCamera(newIndex);
    } catch (e) {
      _setCameraState(initialized: false, loading: false);
      debugMessagePrint(e.toString(), "STYLE_ME_PHOTO_LABEL: ");
    } finally {
      _isInitializing = false;
    }
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
