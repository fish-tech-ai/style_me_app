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