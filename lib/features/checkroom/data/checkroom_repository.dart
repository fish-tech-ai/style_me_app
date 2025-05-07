import 'package:chopper/chopper.dart';
import 'package:style_me/core/extensions/response_ext.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/services/outfit_service.dart';
import 'package:style_me/features/checkroom/data/models/generate_outfit_body.dart';
import 'package:style_me/features/checkroom/data/models/generated_outfit_response.dart';

class CheckroomRepository {
  final OutfitService service;

  CheckroomRepository(this.service);

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
}
