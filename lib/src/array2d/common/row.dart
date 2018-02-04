part of grizzly.series.array2d;

abstract class RowMixin<E> implements Axis2D<E> {
  Array2D<E> get inner;

  int get length => inner.numRows;

  int get otherDLength => inner.numCols;

  ArrayFix<E> operator [](int row) => inner[row];

  operator []=(int index, /* Iterable<int> | Array<int> */ row) =>
      inner[index] = row;

  void add(ArrayView<E> row) => inner.add(row);

  void addScalar(E v) => inner.addScalar(v);

  void insert(int index, ArrayView<E> row) => inner.insert(index, row);

  Iterable<ArrayFix<E>> get iterable => inner.rows;

  Iterator<ArrayFix<E>> get iterator => inner.rows.iterator;
}

abstract class RowFixMixin<E> implements Axis2DFix<E> {
  Array2DFix<E> get inner;

  int get length => inner.numRows;

  int get otherDLength => inner.numCols;

  ArrayFix<E> operator [](int row) => inner[row];

  operator []=(int index, /* Iterable<E> | Array<E> */ row) =>
      inner[index] = row;

  Iterable<ArrayFix<E>> get iterable => inner.rows;

  Iterator<ArrayFix<E>> get iterator => inner.rows.iterator;
}

abstract class RowViewMixin<E> implements Axis2DView<E> {
  Array2DView<E> get inner;

  int get length => inner.numRows;

  int get otherDLength => inner.numCols;

  ArrayView<E> operator [](int row) => inner[row];

  Iterable<ArrayView<E>> get iterable => inner.rows;

  Iterator<ArrayView<E>> get iterator => inner.rows.iterator;
}