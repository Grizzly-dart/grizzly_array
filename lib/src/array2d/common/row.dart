part of grizzly.series.array2d;

abstract class RowMixin<E> implements Axis2D<E> {
  Array2D<E> get inner;

  int get length => inner.numRows;

  int get otherDLength => inner.numCols;

  ArrayFix<E> operator [](int row) => inner[row];

  operator []=(int index, IterView<E> row) => inner[index] = row;

  void add(IterView<E> row) => inner.add(row);

  void addScalar(E v) => inner.addScalar(v);

  void insert(int index, IterView<E> row) => inner.insert(index, row);

  Iterable<ArrayFix<E>> get iterable => inner.rows;
}

abstract class RowFixMixin<E> implements Axis2DFix<E> {
  Array2DFix<E> get inner;

  int get length => inner.numRows;

  int get otherDLength => inner.numCols;

  ArrayFix<E> operator [](int row) => inner[row];

  operator []=(int index, IterView<E> row) => inner[index] = row;

  Iterable<ArrayFix<E>> get iterable => inner.rows;
}

abstract class RowViewMixin<E> implements Axis2DView<E> {
  Array2DView<E> get inner;

  int get length => inner.numRows;

  int get otherDLength => inner.numCols;

  ArrayView<E> operator [](int row) => inner[row];

  Iterable<ArrayView<E>> get iterable => inner.rows;
}
