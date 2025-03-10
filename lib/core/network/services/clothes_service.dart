import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:style_me/features/wardrobe/data/models/io/clothes_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_clothing_photo_response.dart';

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
  Future<Response<SendClothingPhotoResponse>> sendClothingPhoto(@PartFile() File encryptedImage);

  static ClothesService create([ChopperClient? client]) =>
      _$ClothesService(client);
}
