import 'package:chopper/chopper.dart';
import 'package:style_me/features/checkroom/data/models/generate_outfit_body.dart';
import 'package:style_me/features/checkroom/data/models/generated_outfit_response.dart';
import 'package:style_me/features/home/data/models/outfit_original_photo_response.dart';
import 'package:style_me/features/home/data/models/outfits_response.dart';

part 'outfit_service.chopper.dart';

@ChopperApi(baseUrl: "/outfit")
abstract class OutfitService extends ChopperService {
  @Post(path: "/generate")
  Future<Response<GeneratedOutfitResponse>> generateOutfit(
      @Body() GenerateOutfitBody request);

  @Get(path: "/history")
  Future<Response<OutfitsResponse>> getRecentOutfits();

  @Get(path: "/liked")
  Future<Response<OutfitsResponse>> getFavoriteOutfits();

  @Put(path: "/update")
  Future<Response> likeOutfit(
    @Query('outfitId') String outfitId,
    @Body() bool isLiked,
  );

  @Get(path: '/{outfitId}/singleImage')
  Future<Response<OutfitOriginalPhotoResponse>> getOriginalOutfitUrl(
    @Path('outfitId') String outfitId,
  );

  static OutfitService create([ChopperClient? client]) =>
      _$OutfitService(client);
}
