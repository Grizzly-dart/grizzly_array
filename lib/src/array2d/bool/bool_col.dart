part of grizzly.series.array2d;

class Bool2DCol extends Object
    with
        ColMixin<bool>,
        AxisMixin<bool>,
        AxisFixMixin<bool>,
        AxisViewMixin<bool>,
        BoolAxis2DViewMixin
    implements Axis2D<bool>, Bool2DColFix {
  final Bool2D inner;

  Bool2DCol(this.inner);

  Bool1DFix operator [](int col) =>
      new Bool1DFix(new ColList<bool>(inner, col));

  operator []=(int index, Iterable<bool> col) {
    if (index >= inner.numCols) {
      throw new RangeError.range(index, 0, inner.numCols - 1, 'index');
    }
    if (col.length != inner.numRows) {
      throw new ArgumentError.value(col, 'col', 'Size mismatch!');
    }
    for (int i = 0; i < inner.numRows; i++) {
      inner[i][index] = col.elementAt(i);
    }
  }

  void add(Iterable<bool> col) {
    if (col.length != inner.numRows)
      throw new ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(col.elementAt(i));
    }
  }

  @override
  void addScalar(bool v) {
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(v);
    }
  }

  void insert(int index, Iterable<bool> col) {
    if (col.length != inner.numRows)
      throw new ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].insert(index, col.elementAt(i));
    }
  }
}

class Bool2DColFix extends Object
    with
        ColFixMixin<bool>,
        AxisFixMixin<bool>,
        AxisViewMixin<bool>,
        BoolAxis2DViewMixin
    implements Axis2DFix<bool>, Bool2DColView {
  final Bool2DFix inner;

  Bool2DColFix(this.inner);

  Bool1DFix operator [](int col) =>
      new Bool1DFix(new ColList<bool>(inner, col));

  operator []=(int index, Iterable<bool> col) {
    if (index >= inner.numCols) {
      throw new RangeError.range(index, 0, inner.numCols - 1, 'index');
    }
    if (col.length != inner.numRows) {
      throw new ArgumentError.value(col, 'col', 'Size mismatch!');
    }
    for (int i = 0; i < inner.numRows; i++) {
      inner[i][index] = col.elementAt(i);
    }
  }
}

class Bool2DColView extends Object
    with ColViewMixin<bool>, AxisViewMixin<bool>, BoolAxis2DViewMixin
    implements Axis2DView<bool> {
  final Bool2DView inner;

  Bool2DColView(this.inner);

  Bool1DView operator [](int col) =>
      new Bool1DView.own(new ColList<bool>(inner, col));
}
