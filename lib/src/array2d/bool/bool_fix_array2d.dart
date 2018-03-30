part of grizzly.series.array2d;

class Bool2DFix extends Object
    with Bool2DViewMixin, Array2DViewMixin<bool>
    implements Array2DFix<bool>, Bool2DView {
  final List<Bool1DFix> _data;

  Bool2DFix(Iterable<Iterable<bool>> data)
      : _data = new List<Bool1DFix>(data.length) {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<bool> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        Iterable<bool> item = data.elementAt(i);
        _data[i] = new Bool1DFix(item);
      }
    }
  }

  /// Create [Int2D] from column major
  factory Bool2DFix.columns(Iterable<Iterable<bool>> columns) {
    if (columns.length == 0) return new Bool2DFix.sized(0, 0);

    int numRows = columns.first.length;
    for (int i = 0; i < columns.length; i++) {
      int curLen = columns.elementAt(i).length;
      if (columns.elementAt(i).length != numRows)
        throw lengthMismatch(
            expected: numRows, found: curLen, subject: 'columns');
    }

    final ret = new Bool2DFix.sized(numRows, columns.length);
    for (int c = 0; c < ret.numCols; c++) {
      final Iterator<bool> col = columns.elementAt(c).iterator;
      col.moveNext();
      for (int r = 0; r < ret.numRows; r++) {
        ret[r][c] = col.current;
        col.moveNext();
      }
    }
    return ret;
  }

  Bool2DFix.from(Iterable<IterView<bool>> data)
      : _data = new List<Bool1DFix>(data.length) {
    if (data.length != 0) {
      final int len = data.first.length;
      for (IterView item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        IterView<bool> item = data.elementAt(i);
        _data[i] = new Bool1DFix.copy(item);
      }
    }
  }

  Bool2DFix.copy(Array2DView<bool> data)
      : _data = new List<Bool1DFix>(data.numRows) {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = new Bool1DFix.copy(data[i]);
    }
  }

  Bool2DFix.own(this._data) {
    // TODO check that all rows are of same length
  }

  Bool2DFix.sized(int rows, int cols, {bool data: false})
      : _data = new List<Bool1DFix>.generate(
            rows, (_) => new Bool1DFix.sized(cols, data: data),
            growable: false);

  Bool2DFix.shaped(Index2D shape, {bool data: false})
      : _data = new List<Bool1DFix>.generate(
            shape.row, (_) => new Bool1DFix.sized(shape.col, data: data),
            growable: false);

  factory Bool2DFix.shapedLike(Array2DView like, {bool data: false}) =>
      new Bool2DFix.sized(like.numRows, like.numCols, data: data);

  factory Bool2DFix.diagonal(IterView<bool> diagonal) {
    final ret = new Bool2DFix.sized(diagonal.length, diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      ret[i][i] = diagonal[i];
    }
    return ret;
  }

  Bool2DFix.repeatRow(IterView<bool> row, [int numRows = 1])
      : _data = new List<Bool1DFix>(numRows) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Bool1DFix.copy(row);
    }
  }

  Bool2DFix.repeatCol(IterView<bool> column, [int numCols = 1])
      : _data = new List<Bool1DFix>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Bool1DFix.sized(numCols, data: column[i]);
    }
  }

  Bool2DFix.aRow(IterView<bool> row) : _data = new List<Bool1DFix>(1) {
    _data[0] = new Bool1DFix.copy(row);
  }

  Bool2DFix.aCol(IterView<bool> column)
      : _data = new List<Bool1DFix>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Bool1DFix.single(column[i]);
    }
  }

  factory Bool2DFix.genRows(int numRows, Iterable<bool> rowMaker(int index)) {
    final rows = <Bool1DFix>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Bool1DFix(v));
    }
    return new Bool2DFix.own(rows);
  }

  factory Bool2DFix.genCols(int numCols, Iterable<bool> colMaker(int index)) {
    final List<Iterable<bool>> cols = <Iterable<bool>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Bool2DFix.columns(cols);
  }

  factory Bool2DFix.gen(Index2D shape, bool maker(int row, int col)) {
    final ret = new Bool2DFix.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret;
  }

  static Bool2DFix buildRows<T>(
      Iterable<T> iterable, Iterable<bool> rowMaker(T v)) {
    final rows = <Bool1DFix>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Bool1DFix(v));
    }
    return new Bool2DFix.own(rows);
  }

  static Bool2DFix buildCols<T>(
      Iterable<T> iterable, Iterable<bool> colMaker(T v)) {
    final List<Iterable<bool>> cols = <Iterable<bool>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Bool2DFix.columns(cols);
  }

  static Bool2DFix build<T>(Iterable<Iterable<T>> data, bool maker(T v)) {
    if (data.length == 0) {
      return new Bool2DFix.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Bool2DFix.sized(data.length, data.first.length);
    for (int r = 0; r < ret.numRows; r++) {
      final Iterator<T> row = data.elementAt(r).iterator;
      row.moveNext();
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(row.current);
        row.moveNext();
      }
    }
    return ret;
  }

  covariant Bool2DColFix _col;

  Bool2DColFix get col => _col ??= new Bool2DColFix(this);

  covariant Bool2DRowFix _row;

  Bool2DRowFix get row => _row ??= new Bool2DRowFix(this);

  Bool1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, IterView<bool> val) {
    if (i >= numRows) {
      throw new RangeError.range(i, 0, numRows - 1, 'i', 'Out of range!');
    }

    if (numRows == 0) {
      final arr = new Bool1D.copy(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) {
      throw new Exception('Invalid size!');
    }

    final arr = new Bool1D.copy(val);

    _data[i] = arr;
  }

  /// Sets all elements in the array to given value [v]
  void set(bool v) {
    for (int c = 0; c < numRows; c++) {
      for (int r = 0; r < numCols; r++) {
        _data[c][r] = v;
      }
    }
  }

  @override
  void assign(Array2DView<bool> other) {
    if (other.shape != shape)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = other[r][c];
      }
    }
  }

  Bool2DView _view;

  Bool2DView get view => _view ??= new Bool2DView.own(_data);

  Bool2DFix get fixed => this;

  @override
  Iterable<ArrayFix<bool>> get rows => _data;

  @override
  Iterable<ArrayFix<bool>> get cols => new ColsListFix<bool>(this);
}
