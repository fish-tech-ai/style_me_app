import 'package:chopper/chopper.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothes_response.dart';

part "clothes_service.chopper.dart";

@ChopperApi(baseUrl: "/clothes")
abstract class ClothesService extends ChopperService {
  @Get()
  Future<Response<ClothesResponse>> getClothes(
    @Query("searchText") String? searchText,
    @Query("position") String? position,
    @Query("category") String? category,
  );

  static ClothesService create([ChopperClient? client]) =>
      _$ClothesService(client);
}
