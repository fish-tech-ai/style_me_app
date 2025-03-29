import 'package:style_me/features/wardrobe/data/models/clothing.dart';
import 'package:style_me/features/wardrobe/data/models/photo_item.dart';

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
}