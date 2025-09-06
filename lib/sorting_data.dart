class SortingData<T> {
  const SortingData({required this.onASC, required this.onDESC});
  final int Function(T a, T b)? onASC;
  final int Function(T a, T b)? onDESC;
}
