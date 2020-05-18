part of grizzly.array2d;

class Dynamic2DCol extends Object
    with ColMixin<dynamic>, Axis2DMixin<dynamic>, Dynamic2DAxisMixin
    implements Axis2D<dynamic> {
  final Dynamic2D inner;

  Dynamic2DCol(this.inner);

  Dynamic1DFix operator [](int col) =>
      Dynamic1DFix.own(ColList<dynamic>(inner, col));

  operator []=(int index, Iterable<dynamic> col) {
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

  void add(Iterable<dynamic> col) {
    if (col.length != inner.numRows)
      throw ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(col.elementAt(i));
    }
  }

  @override
  void addScalar(dynamic v) {
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(v);
    }
  }

  void insert(int index, Iterable<dynamic> col) {
    if (col.length != inner.numRows)
      throw ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].insert(index, col.elementAt(i));
    }
  }
}
