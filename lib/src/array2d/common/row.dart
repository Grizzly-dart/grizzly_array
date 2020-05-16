part of grizzly.series.array2d;

abstract class RowMixin<E> implements Axis2D<E> {
  Array2D<E> get inner;

  int get length => inner.numRows;

  int get otherDLength => inner.numCols;

  ArrayFix<E> operator [](int row) => inner[row];

  operator []=(int index, Iterable<E> row) => inner[index] = row;

  void add(Iterable<E> row) => inner.add(row);

  void addScalar(E v) => inner.addScalar(v);

  void insert(int index, Iterable<E> row) => inner.insert(index, row);

  Iterable<ArrayFix<E>> get iterable => inner.rows;
}
