part of grizzly.series.array2d;

/// List of elements along a column of Array2D
class ColList<T> extends Object with ListMixin<T> implements List<T> {
  final Array2DView<T> inner;

  final int colIdx;

  ColList(this.inner, this.colIdx);

  @override
  T operator [](int index) => inner[index][colIdx];

  @override
  void operator []=(int index, T value) {
    // TODO check range
    if (inner is Array2DFix<T>) {
      (inner as Array2DFix<T>)[index][colIdx] = value;
    } else {
      throw new UnsupportedError('Array2DView is not modifiable!');
    }
  }

  @override
  int get length => inner.numRows;

  @override
  set length(int newLength) {
    throw new UnsupportedError('Changing lenght not supported!');
  }
}

/// List of columns in Array2D
class ColsListView<T> extends Object
    with ListMixin<ArrayView<T>>
    implements List<ArrayView<T>> {
  final Array2DView<T> inner;

  ColsListView(this.inner);

  @override
  ArrayView<T> operator [](int index) => inner.col[index];

  @override
  void operator []=(int index, ArrayView<T> value) {
    // TODO check range
    if (inner is Array2DFix<T>) {
      (inner as Array2DFix<T>).col[index] = value;
    } else {
      throw new UnsupportedError('Array2DView is not modifiable!');
    }
  }

  @override
  int get length => inner.numCols;

  @override
  set length(int newLength) {
    throw new UnsupportedError('Changing lenght not supported!');
  }
}

/// List of columns in Array2D
class ColsListFix<T> extends Object
    with ListMixin<ArrayFix<T>>
    implements List<ArrayFix<T>> {
  final Array2DFix<T> inner;

  ColsListFix(this.inner);

  @override
  ArrayFix<T> operator [](int index) => inner.col[index];

  @override
  void operator []=(int index, ArrayFix<T> value) {
    // TODO check range
    if (inner is Array2DFix<T>) {
      inner.col[index] = value;
    } else {
      throw new UnsupportedError('Array2DView is not modifiable!');
    }
  }

  @override
  int get length => inner.numCols;

  @override
  set length(int newLength) {
    throw new UnsupportedError('Changing lenght not supported!');
  }
}
