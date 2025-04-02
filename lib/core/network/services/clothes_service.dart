import 'package:chopper/chopper.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothes_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothing_confirmation_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/original_image_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_clothing_photo_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/update_clothing_request.dart';

part "clothes_service.chopper.dart";

@ChopperApi(baseUrl: "/clothes")
abstract class ClothesService extends ChopperService {
  @Get()
  Future<Response<ClothesResponse>> getClothes(
    @Query("searchText") String? searchText,
    @Query("position") String? position,
    @Query("category") String? category,
  );

  @Post(path: '/image')
  @Multipart()
  Future<Response<SendClothingPhotoResponse>> sendClothingPhoto(
      @PartFile("image") String encryptedImage);

  @Get(path: '/single')
  Future<Response<OriginalImageUrlResponse>> getOriginalImageUrl(
      @Query('id') String id);

  @Post(path: '/confirm')
  Future<Response> confirmClothingPhoto(
      @Body() ClothingConfirmationRequest request);

  @Put(path: '/update')
  Future<Response> updateClothing(
      @Query('id') String id, @Body() UpdateClothingRequest request);

  @Delete(path: '/delete')
  Future<Response> deleteClothing(@Query('id') String id);

  static ClothesService create([ChopperClient? client]) =>
      _$ClothesService(client);
}
