part of grizzly.array2d;

class Double2DCol extends Object
    with Axis2DMixin<double>, ColMixin<double>, DoubleAxis2DViewMixin
    implements Numeric2DAxis<double> {
  final Double2D inner;

  Double2DCol(this.inner);

  Double1DFix operator [](int col) =>
      Double1DFix.own(ColList<double>(inner, col));

  operator []=(int index, Iterable<double> col) {
    if (index >= inner.numCols) {
      throw RangeError.range(index, 0, inner.numCols - 1, 'index');
    }
    if (col.length != inner.numRows) {
      throw ArgumentError.value(col, 'col', 'Size mismatch!');
    }
    for (int i = 0; i < inner.numRows; i++) {
      inner[i][index] = col.elementAt(i);
    }
  }

  void add(Iterable<double> col) {
    if (col.length != inner.numRows)
      throw ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(col.elementAt(i));
    }
  }

  @override
  void addScalar(double v) {
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(v);
    }
  }

  void insert(int index, Iterable<double> col) {
    if (col.length != inner.numRows)
      throw ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].insert(index, col.elementAt(i));
    }
  }
}
