part of grizzly.series.array2d;

class Int2DCol extends Object
    with
        AxisViewMixin<int>,
        AxisFixMixin<int>,
        AxisMixin<int>,
        ColMixin<int>,
        IntAxis2DViewMixin,
        Int2DColViewMixin
    implements Numeric2DAxis<int>, Int2DColFix {
  final Int2D inner;

  Int2DCol(this.inner);

  Int1DFix operator [](int col) =>
      new Int1DFix.own(new ColList<int>(inner, col));

  operator []=(int col, Iterable<int> val) {
    if (col >= inner.numCols) {
      throw new RangeError.range(col, 0, inner.numCols - 1, 'index');
    }

    if (val.length != inner.numRows) {
      throw new ArgumentError.value(val, 'col', 'Size mismatch!');
    }
    for (int i = 0; i < inner.numRows; i++) {
      inner[i][col] = val.elementAt(i);
    }
  }

  void add(Iterable<int> col) {
    if (col.length != inner.numRows)
      throw new ArgumentError.value(col, 'col', 'Size mismatch');
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
      throw new ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].insert(index, col.elementAt(i));
    }
  }
}

class Int2DColFix extends Object
    with
        AxisViewMixin<int>,
        AxisFixMixin<int>,
        ColFixMixin<int>,
        IntAxis2DViewMixin,
        Int2DColViewMixin
    implements Numeric2DAxisFix<int>, Int2DColView {
  final Int2DFix inner;

  Int2DColFix(this.inner);

  Int1DFix operator [](int col) =>
      new Int1DFix.own(new ColList<int>(inner, col));

  operator []=(int index, Iterable<int> col) {
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

class Int2DColView extends Object
    with
        AxisViewMixin<int>,
        ColViewMixin<int>,
        IntAxis2DViewMixin,
        Int2DColViewMixin
    implements Numeric2DAxisView<int> {
  final Int2DView inner;

  Int2DColView(this.inner);

  Int1DView operator [](int col) =>
      new Int1DView.own(new ColList<int>(inner, col));
}
