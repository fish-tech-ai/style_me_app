import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/views/encrypted_image/isolated_decrypt_manager.dart';

class EncryptedImage extends StatefulWidget {
  final String imageSrc;
  final Widget Function(StackTrace?) errorBuilder;
  final Widget Function() loadingBuilder;
  final BoxFit? fit;

  const EncryptedImage({
    super.key,
    required this.imageSrc,
    required this.errorBuilder,
    required this.loadingBuilder,
    this.fit,
  });

  @override
  State<EncryptedImage> createState() => _EncryptedImageState();
}

class _EncryptedImageState extends State<EncryptedImage> {
  late String _imageFilePath;
  late Future<Uint8List> image;

  @override
  void initState() {
    super.initState();
    _imageFilePath = widget.imageSrc;
    image = _fetchAndDecryptImage();
  }

  @override
  void didUpdateWidget(EncryptedImage oldWidget) {
    if (widget.imageSrc != oldWidget.imageSrc) {
      _imageFilePath = widget.imageSrc;
      image = _fetchAndDecryptImage();
    }
    super.didUpdateWidget(oldWidget);
  }

   Future<Uint8List> _fetchAndDecryptImage() async {
     return getIt<IsolatedDecryptCompressManager>().getDecryptedImageBytes(_imageFilePath);
   }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: image,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingBuilder();
        } else if (snapshot.hasError) {
          debugMessagePrint("No image found on $_imageFilePath");
          return widget.errorBuilder(snapshot.stackTrace);
        } else if (snapshot.hasData) {
          return Image(
            image: MemoryImage(snapshot.data!),
            fit: widget.fit,
          );
        } else {
          debugMessagePrint("No image found on $_imageFilePath");
          return widget.errorBuilder(null);
        }
      },
    );
  }
}
