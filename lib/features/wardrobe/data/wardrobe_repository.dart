import 'package:chopper/chopper.dart';
import 'package:style_me/core/extensions/response_ext.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/clothes_service.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothes_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothes_response.dart';

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
}
