part of grizzly.series.array2d;

class Dynamic2DCol extends Object
    with
        ColMixin<dynamic>,
        AxisMixin<dynamic>,
        AxisFixMixin<dynamic>,
        AxisViewMixin<dynamic>,
        Dynamic2DAxisMixin
    implements Axis2D<dynamic>, Dynamic2DColFix {
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

class Dynamic2DColFix extends Object
    with
        ColFixMixin<dynamic>,
        AxisFixMixin<dynamic>,
        AxisViewMixin<dynamic>,
        Dynamic2DAxisMixin
    implements Axis2DFix<dynamic>, Dynamic2DColView {
  final Dynamic2DFix inner;

  Dynamic2DColFix(this.inner);

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
}

class Dynamic2DColView extends Object
    with ColViewMixin<dynamic>, AxisViewMixin<dynamic>, Dynamic2DAxisMixin
    implements Axis2DView<dynamic> {
  final Dynamic2DView inner;

  Dynamic2DColView(this.inner);

  Dynamic1DView operator [](int col) =>
      Dynamic1DView.own(ColList<dynamic>(inner, col));
}
