import 'package:chopper/chopper.dart';
import 'package:style_me/features/checkroom/data/models/generate_outfit_body.dart';
import 'package:style_me/features/checkroom/data/models/generated_outfit_response.dart';

part 'outfit_service.chopper.dart';

@ChopperApi(baseUrl: "/outfit")
abstract class OutfitService extends ChopperService {
  @Post(path: "/generate")
  Future<Response<GeneratedOutfitResponse>> generateOutfit(
      @Body() GenerateOutfitBody request);

  static OutfitService create([ChopperClient? client]) =>
      _$OutfitService(client);
}
