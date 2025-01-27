extension FirstWhereExt<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) where) {
    for (final element in this) {
      if (where(element)) return element;
    }
    return null;
  }
}