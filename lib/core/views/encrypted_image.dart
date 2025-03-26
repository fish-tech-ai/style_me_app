import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/network/utils/aes_encryptor.dart';

class EncryptedImage extends StatefulWidget {
  final String imageUrl;
  final Widget Function() errorBuilder;
  final Widget Function() loadingBuilder;
  final BoxFit? fit;

  const EncryptedImage({
    super.key,
    required this.imageUrl,
    required this.errorBuilder,
    required this.loadingBuilder,
    this.fit,
  });

  @override
  State<EncryptedImage> createState() => _EncryptedImageState();
}

class _EncryptedImageState extends State<EncryptedImage> {
  String? _imageUrl;
  late Future<Uint8List> image;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imageUrl;
    image = _fetchAndDecryptImage();
  }

  @override
  void didUpdateWidget(EncryptedImage oldWidget) {
    if (widget.imageUrl != oldWidget.imageUrl) {
      _imageUrl = widget.imageUrl;
      image = _fetchAndDecryptImage();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<Uint8List> _fetchAndDecryptImage() async {
    return getIt<AESEncryptor>().decryptImageFrom(_imageUrl!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: image,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingBuilder();
        } else if (snapshot.hasError) {
          debugMessagePrint("No image found on $_imageUrl");
          return widget.errorBuilder();
        } else if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            fit: widget.fit,
          );
        } else {
          debugMessagePrint("No image found on $_imageUrl");
          return widget.errorBuilder();
        }
      },
    );
  }
}
