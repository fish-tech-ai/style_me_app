import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:style_me/core/extensions/response_ext.dart';
import 'package:style_me/core/network/exceptions/expected_error_response.dart';
import 'package:style_me/core/network/exceptions/image_process_exception.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/clothes_service.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothes_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothes_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_clothing_photo_response.dart';

class WardrobeRepository {
  final ClothesService _service;

  WardrobeRepository(this._service);

  Future<ClothesResponse> getClothes(ClothesRequest clothesRequest) async {
    try {
      final Response<ClothesResponse> response = await _service.getClothes(
        clothesRequest.searchText,
        clothesRequest.position,
        clothesRequest.category,
      );
      response.handleIfNotSuccessful();
      return response.body!;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future<SendClothingPhotoResponse> sendClothingPhoto(
      File encryptedImage) async {
    try {
      final Response<SendClothingPhotoResponse> response =
          await _service.sendClothingPhoto(encryptedImage.path);
      if (!response.isSuccessful && response.error is ExpectedErrorResponse) {
        throw ImageProcessException(
            (response.error as ExpectedErrorResponse).type);
      }
      response.handleIfNotSuccessful();
      return response.body!;
    } catch (error) {
      if (error is ImageProcessException) {
        rethrow;
      }
      throw ServerException(error.toString());
    }
  }
}
