import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:style_me/core/extensions/response_ext.dart';
import 'package:style_me/core/network/exceptions/expected_error_response.dart';
import 'package:style_me/core/network/exceptions/image_process_exception.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/clothes_service.dart';
import 'package:style_me/core/network/services/user_photos_service.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothes_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothes_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothing_confirmation_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/original_image_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_clothing_photo_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_user_photo_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/update_clothing_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/update_user_photo_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/user_photo_confirmation_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/user_photos_response.dart';

class WardrobeRepository {
  final ClothesService _clothesService;
  final UserPhotosService _userPhotosService;

  WardrobeRepository(this._clothesService, this._userPhotosService);

  Future<ClothesResponse> getClothes(ClothesRequest clothesRequest) async {
    try {
      final Response<ClothesResponse> response =
          await _clothesService.getClothes(
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
          await _clothesService.sendClothingPhoto(encryptedImage.path);
      if (!response.isSuccessful && response.error is ExpectedErrorResponse) {
        throw ImageProcessException(
            (response.error as ExpectedErrorResponse).error);
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

  Future<OriginalImageUrlResponse> getOriginalImage(String id) async {
    try {
      final Response<OriginalImageUrlResponse> response =
          await _clothesService.getOriginalImageUrl(id);
      response.handleIfNotSuccessful();
      return response.body!;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future confirmClothingPhoto(ClothingConfirmationRequest request) async {
    try {
      final Response response =
          await _clothesService.confirmClothingPhoto(request);
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future updateClothing(String id, UpdateClothingRequest request) async {
    try {
      final Response response =
          await _clothesService.updateClothing(id, request);
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future deleteClothing(String id) async {
    try {
      final Response response = await _clothesService.deleteClothing(id);
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future<UserPhotosResponse> getUserPhotos() async {
    try {
      final Response<UserPhotosResponse> response =
          await _userPhotosService.getUserPhotos();
      response.handleIfNotSuccessful();
      return response.body!;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future<SendUserPhotoResponse> sendUserPhoto(File encryptedImage) async {
    try {
      final Response response =
          await _userPhotosService.sendUserPhoto(encryptedImage.path);
      if (!response.isSuccessful && response.error is ExpectedErrorResponse) {
        throw ImageProcessException(
            (response.error as ExpectedErrorResponse).error);
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

  Future confirmUserPhoto(UserPhotoConfirmationRequest request) async {
    try {
      final Response response =
          await _userPhotosService.confirmUserPhoto(request);
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future updateUserPhoto(String id, UpdateUserPhotoRequest request) async {
    try {
      final Response response =
          await _userPhotosService.updateUserPhoto(id, request);
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future deleteUserPhoto(String id) async {
    try {
      final Response response = await _userPhotosService.deleteUserPhoto(id);
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
