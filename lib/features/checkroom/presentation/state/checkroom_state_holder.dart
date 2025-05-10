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

    ///generate outfit state
    String? generatedOutfitPath,
    @Default("") String generatedOutfitId,
    @Default(false) bool isGenerateLoading,
    @Default(false) bool isLiked,

    ///Initial loading flags
    @Default(true) bool isUserPhotosLoading,
    @Default(true) bool isClothesLoading,
    @Default(false) bool isClothesEmpty,
    @Default(false) bool isUserPhotosEmpty,
  }) = _CheckroomStateHolder;

  bool get canShowPageContent =>
      !isClothesEmpty &&
      !isUserPhotosEmpty;

  bool get isLoading => isClothesLoading || isUserPhotosLoading;
}
