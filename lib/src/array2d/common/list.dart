part of grizzly.array2d;

/// List of elements along a column of Array2D
class ColList<T> extends Object with ListMixin<T> implements List<T> {
  final Array2D<T> inner;

  final int colIdx;

  ColList(this.inner, this.colIdx);

  @override
  T operator [](int index) => inner[index][colIdx];

  @override
  void operator []=(int index, T value) {
    // TODO check range
    inner[index][colIdx] = value;
  }

  @override
  int get length => inner.numRows;

  @override
  set length(int newLength) {
    throw UnsupportedError('Changing lenght not supported!');
  }
}
