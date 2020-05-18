part of grizzly.array2d;

class Int2DCol extends Object
    with Axis2DMixin<int>, ColMixin<int>, IntAxis2DViewMixin
    implements Numeric2DAxis<int> {
  final Int2D inner;

  Int2DCol(this.inner);

  Int1DFix operator [](int col) => Int1DFix.own(ColList<int>(inner, col));

  operator []=(int col, Iterable<int> val) {
    if (col >= inner.numCols) {
      throw RangeError.range(col, 0, inner.numCols - 1, 'index');
    }

    if (val.length != inner.numRows) {
      throw ArgumentError.value(val, 'col', 'Size mismatch!');
    }
    for (int i = 0; i < inner.numRows; i++) {
      inner[i][col] = val.elementAt(i);
    }
  }

  void add(Iterable<int> col) {
    if (col.length != inner.numRows)
      throw ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(col.elementAt(i));
    }
  }

  @override
  void addScalar(int v) {
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(v);
    }
  }

  void insert(int index, Iterable<int> col) {
    if (col.length != inner.numRows)
      throw ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].insert(index, col.elementAt(i));
    }
  }
}
