part of grizzly.array2d;

class String2DCol extends Object
    with ColMixin<String>, Axis2DMixin<String>, String2DAxisMixin
    implements Axis2D<String> {
  final String2D inner;

  String2DCol(this.inner);

  String1DFix operator [](int col) =>
      String1DFix.own(ColList<String>(inner, col));

  operator []=(int index, Iterable<String> col) {
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

  void add(Iterable<String> col) {
    if (col.length != inner.numRows)
      throw ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(col.elementAt(i));
    }
  }

  @override
  void addScalar(String v) {
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(v);
    }
  }

  void insert(int index, Iterable<String> col) {
    if (col.length != inner.numRows)
      throw ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].insert(index, col.elementAt(i));
    }
  }
}
