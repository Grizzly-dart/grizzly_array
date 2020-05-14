part of grizzly.series.array2d;

class String2DCol extends Object
    with
        ColMixin<String>,
        AxisMixin<String>,
        AxisFixMixin<String>,
        AxisViewMixin<String>,
        String2DAxisMixin
    implements Axis2D<String>, String2DColFix {
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

class String2DColFix extends Object
    with
        ColFixMixin<String>,
        AxisFixMixin<String>,
        AxisViewMixin<String>,
        String2DAxisMixin
    implements Axis2DFix<String>, String2DColView {
  final String2DFix inner;

  String2DColFix(this.inner);

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
}

class String2DColView extends Object
    with ColViewMixin<String>, AxisViewMixin<String>, String2DAxisMixin
    implements Axis2DView<String> {
  final String2DView inner;

  String2DColView(this.inner);

  String1DView operator [](int col) =>
      String1DView.own(ColList<String>(inner, col));
}
