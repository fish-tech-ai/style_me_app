import 'package:chopper/chopper.dart';
import 'package:style_me/features/wardrobe/data/models/io/original_image_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/send_user_photo_response.dart';
import 'package:style_me/features/wardrobe/data/models/io/update_user_photo_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/user_photo_confirmation_request.dart';
import 'package:style_me/features/wardrobe/data/models/io/user_photos_response.dart';

part "user_photos_service.chopper.dart";

@ChopperApi(baseUrl: "/user-pictures")
abstract class UserPhotosService extends ChopperService {
  @Get()
  Future<Response<UserPhotosResponse>> getUserPhotos();

  @Post(path: '/check')
  @Multipart()
  Future<Response<SendUserPhotoResponse>> sendUserPhoto(
      @PartFile("image") String encryptedImage);

  @Get(path: '/single')
  Future<Response<OriginalImageUrlResponse>> getOriginalImageUrl(
      @Query('id') String id);

  @Post(path: '/confirm')
  Future<Response> confirmUserPhoto(
      @Body() UserPhotoConfirmationRequest request);

  @Put(path: '/update')
  Future<Response> updateUserPhoto(
      @Query('id') String id, @Body() UpdateUserPhotoRequest request);

  @Delete(path: '/delete')
  Future<Response> deleteUserPhoto(@Query('id') String id);

  static UserPhotosService create([ChopperClient? client]) =>
      _$UserPhotosService(client);
}
