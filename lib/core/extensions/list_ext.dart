import 'package:style_me/features/home/data/models/outfit.dart';
import 'package:style_me/features/wardrobe/data/models/clothing/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';
import 'package:style_me/features/wardrobe/data/models/user_photos/user_photo.dart';

extension FirstWhereExt<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) where) {
    for (final element in this) {
      if (where(element)) return element;
    }
    return null;
  }

  List<T> addSeparators(T separator) {
    if (length <= 1) return List.from(this);
    final result = <T>[];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i != length - 1) {
        result.add(separator);
      }
    }
    return result;
  }

  bool everyIndexed(bool Function(T element, int index) test) {
    bool isSatisfied;
    for (int i = 0; i < length; i++)  {
      isSatisfied = test(this[i], i);
      if (!isSatisfied) {
        return false;
      }
    }
    return true;
  }
}

extension PhotoListExt on List<PhotoItem> {
  List<PhotoItem> getUpdatedWith(PhotoItem updatedItem) {
    return map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();
  }

  List<PhotoItem> getReducedWith(PhotoItem updatedItem) {
    return where((item) => item.id != updatedItem.id).toList();
  }

  List<Clothing> asClothingList() {
    return map((item) => item as Clothing).toList();
  }

  List<Outfit> asOutfitList() {
    return map((item) => item as Outfit).toList();
  }

  List<UserPhoto> asUserPhotosList() {
    return map((item) => item as UserPhoto).toList();
  }
}

extension UserPhotoListExt on List<UserPhoto> {
  List<UserPhoto> withDefaultOn(UserPhoto item) {
    return map((photo) => photo.copyWith(isDefault: photo.id == item.id))
        .toList();
  }
}
