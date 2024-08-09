class SortingData<T> {
  final int Function(T a, T b)? onASC, onDESC;
  SortingData({
    required this.onASC,
    required this.onDESC,
  });
}
