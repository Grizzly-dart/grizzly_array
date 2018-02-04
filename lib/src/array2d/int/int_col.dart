part of grizzly.series.array2d;

class Int2DCol extends Object
    with
        IntAxis2DViewMixin,
        AxisMixin<int>,
        AxisFixMixin<int>,
        AxisViewMixin<int>
    implements Numeric2DAxis<int>, Int2DColFix {
  final Int2D inner;

  Int2DCol(this.inner);

  int get length => inner.numCols;

  int get otherDLength => inner.numRows;

  Int1DFix operator [](int col) => new Int1DFixLazy(inner, col);

  operator []=(int index, ArrayView<int> col) {
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

  void add(ArrayView<int> col) {
    if (col.length != inner.numRows)
      throw new ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].add(col[i]);
    }
  }

  void insert(int index, ArrayView<int> col) {
    if (col.length != inner.numRows)
      throw new ArgumentError.value(col, 'col', 'Size mismatch');
    for (int i = 0; i < inner.numRows; i++) {
      inner._data[i].insert(index, col[i]);
    }
  }
}

class Int2DColFix extends Object
    with IntAxis2DViewMixin, AxisFixMixin<int>, AxisViewMixin<int>
    implements Numeric2DAxisFix<int>, Int2DColView {
  final Int2DFix inner;

  Int2DColFix(this.inner);

  int get length => inner.numCols;

  int get otherDLength => inner.numRows;

  Int1DFix operator [](int col) => new Int1DFixLazy(inner, col);

  operator []=(int index, /* Iterable<int> | Array<int> */ col) {
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

class Int2DColView extends Object
    with IntAxis2DViewMixin, AxisViewMixin<int>
    implements Numeric2DAxisView<int> {
  final Int2DView inner;

  Int2DColView(this.inner);

  int get length => inner.numCols;

  int get otherDLength => inner.numRows;

  Int1DView operator [](int col) => new Int1DViewLazy(inner, col);

  @override
  Iterator<Int1DView> get iterator {
    // TODO
  }

  @override
  Iterable<Int1DView> get iterable {
    // TODO
  }
}