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
      new String1DFix.own(new ColList<String>(inner, col));

  operator []=(int index, ArrayView<String> col) {
    if (index >= inner.numCols) {
      throw new RangeError.range(index, 0, inner.numCols - 1, 'index');
    }
    if (col.length != inner.numRows) {
      throw new ArgumentError.value(col, 'col', 'Size mismatch!');
    }
    for (int i = 0; i < inner.numRows; i++) {
      inner[i][index] = col[i];
    }
  }

  void add(ArrayView<String> col) {
    if (col.length != inner.numRows)
      throw new ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(col[i]);
    }
  }

  @override
  void addScalar(String v) {
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(v);
    }
  }

  void insert(int index, ArrayView<String> col) {
    if (col.length != inner.numRows)
      throw new ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].insert(index, col[i]);
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
      new String1DFix.own(new ColList<String>(inner, col));

  operator []=(int index, ArrayView<String> col) {
    if (index >= inner.numCols) {
      throw new RangeError.range(index, 0, inner.numCols - 1, 'index');
    }
    if (col.length != inner.numRows) {
      throw new ArgumentError.value(col, 'col', 'Size mismatch!');
    }
    for (int i = 0; i < inner.numRows; i++) {
      inner[i][index] = col[i];
    }
  }
}

class String2DColView extends Object
    with ColViewMixin<String>, AxisViewMixin<String>, String2DAxisMixin
    implements Axis2DView<String> {
  final String2DView inner;

  String2DColView(this.inner);

  String1DView operator [](int col) =>
      new String1DView.own(new ColList<String>(inner, col));
}
