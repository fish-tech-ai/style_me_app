import 'dart:typed_data';

import 'package:style_me/core/app/data/app_repository.dart';

class FetchImageUseCase {
  final AppRepository _repository;

  FetchImageUseCase(this._repository);

  Future<Uint8List> call(String url) {
    return _repository.fetchImageFrom(url);
  }
}
