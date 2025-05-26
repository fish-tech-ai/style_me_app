import 'package:chopper/chopper.dart';
import 'package:style_me/core/extensions/response_ext.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/outfit_service.dart';
import 'package:style_me/features/checkroom/data/models/generate_outfit_body.dart';
import 'package:style_me/features/checkroom/data/models/generated_outfit_response.dart';
import 'package:style_me/features/home/data/models/outfit_original_photo_response.dart';
import 'package:style_me/features/home/data/models/outfits_response.dart';

class OutfitRepository {
  final OutfitService service;

  OutfitRepository(this.service);

  Future<GeneratedOutfitResponse> generateOutfit(
      GenerateOutfitBody request) async {
    try {
      final Response<GeneratedOutfitResponse> response =
          await service.generateOutfit(request);
      response.handleIfNotSuccessful();
      return response.body!;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future<OutfitsResponse> getRecentOutfits() async {
    try {
      final Response<OutfitsResponse> response =
          await service.getRecentOutfits();
      response.handleIfNotSuccessful();
      return response.body!;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future<OutfitsResponse> getFavoriteOutfits() async {
    try {
      final Response<OutfitsResponse> response =
          await service.getFavoriteOutfits();
      response.handleIfNotSuccessful();
      return response.body!;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future<OutfitOriginalPhotoResponse> getOriginalOutfitPhoto(
      String outfitId) async {
    try {
      final Response<OutfitOriginalPhotoResponse> response =
          await service.getOriginalOutfitUrl(outfitId);
      response.handleIfNotSuccessful();
      return response.body!;
    } catch (error) {
      throw ServerException(error.toString());
    }
  }

  Future setIsOutfitFavorite(String outfitId, bool shouldLike) async {
    try {
      final Response response = await service.likeOutfit(outfitId, shouldLike);
      response.handleIfNotSuccessful();
    } catch (error) {
      throw ServerException(error.toString());
    }
  }
}
