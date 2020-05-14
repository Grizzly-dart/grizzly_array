part of grizzly.series.array2d;

class Double2DCol extends Object
    with
        AxisViewMixin<double>,
        AxisFixMixin<double>,
        AxisMixin<double>,
        ColMixin<double>,
        DoubleAxis2DViewMixin,
        Double2DColViewMixin
    implements Numeric2DAxis<double>, Double2DColFix {
  final Double2D inner;

  Double2DCol(this.inner);

  Double1DFix operator [](int col) =>
      new Double1DFix.own(new ColList<double>(inner, col));

  operator []=(int index, Iterable<double> col) {
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

  void add(Iterable<double> col) {
    if (col.length != inner.numRows)
      throw new ArgumentError.value(col, 'col', 'Size mismatch');
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
      throw new ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].insert(index, col.elementAt(i));
    }
  }
}

class Double2DColFix extends Object
    with
        AxisViewMixin<double>,
        AxisFixMixin<double>,
        ColFixMixin<double>,
        DoubleAxis2DViewMixin,
        Double2DColViewMixin
    implements Numeric2DAxisFix<double>, Double2DColView {
  final Double2DFix inner;

  Double2DColFix(this.inner);

  Double1DFix operator [](int col) =>
      new Double1DFix.own(new ColList<double>(inner, col));

  operator []=(int index, Iterable<double> col) {
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

class Double2DColView extends Object
    with
        AxisViewMixin<double>,
        ColViewMixin<double>,
        DoubleAxis2DViewMixin,
        Double2DColViewMixin
    implements Numeric2DAxisView<double> {
  final Double2DView inner;

  Double2DColView(this.inner);

  Double1DView operator [](int col) =>
      new Double1DView.own(new ColList<double>(inner, col));
}
