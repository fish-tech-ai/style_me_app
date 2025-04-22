import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';

part 'checkroom_state_holder.freezed.dart';

@freezed
class CheckroomStateHolder with _$CheckroomStateHolder {
  const CheckroomStateHolder._();

  const factory CheckroomStateHolder({
    @Default([]) List<UserPhoto> userPhotos,
    @Default([]) List<Clothing> clothes,
    @Default([]) List<Clothing> selectedClothes,
    UserPhoto? selectedUserPhoto,


    ///Initial loading flags
    @Default(true) bool isUserPhotosLoading,
    @Default(true) bool isClothesLoading,
    @Default(false) bool isClothesEmpty,
    @Default(false) bool isUserPhotosEmpty,
  }) = _CheckroomStateHolder;

  bool get canShowPageContent =>
      !isUserPhotosLoading &&
      !isClothesLoading &&
      !isClothesEmpty &&
      !isUserPhotosEmpty;

  bool get isLoading => isClothesLoading || isUserPhotosLoading;
}
