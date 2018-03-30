part of grizzly.series.array2d;

abstract class ColMixin<E> implements Axis2D<E> {
  Array2D<E> get inner;

  int get length => inner.numCols;

  int get otherDLength => inner.numRows;

  Iterable<ArrayFix<E>> get iterable => inner.cols;
}

abstract class ColFixMixin<E> implements Axis2DFix<E> {
  Array2DFix<E> get inner;

  int get length => inner.numCols;

  int get otherDLength => inner.numRows;

  Iterable<ArrayFix<E>> get iterable => inner.cols;
}

abstract class ColViewMixin<E> implements Axis2DView<E> {
  Array2DView<E> get inner;

  int get length => inner.numCols;

  int get otherDLength => inner.numRows;

  Iterable<ArrayView<E>> get iterable => inner.cols;
}
