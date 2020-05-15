part of grizzly.series.array2d;

abstract class ColMixin<E> implements Axis2D<E> {
  Array2D<E> get inner;

  int get length => inner.numCols;

  int get otherDLength => inner.numRows;

  Iterable<ArrayFix<E>> get iterable => inner.cols;
}

/// List of columns in Array2D
class ColsList<T> extends Object
    with ListMixin<ArrayFix<T>>
    implements List<ArrayFix<T>> {
  final Array2D<T> inner;

  ColsList(this.inner);

  @override
  ArrayFix<T> operator [](int index) => inner.col[index];

  @override
  void operator []=(int index, ArrayFix<T> value) {
    // TODO check range
    inner.col[index] = value;
  }

  @override
  int get length => inner.numCols;

  @override
  set length(int newLength) {
    throw UnsupportedError('Changing lenght not supported!');
  }
}
