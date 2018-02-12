part of grizzly.series.array2d;

class Dynamic2DFix extends Object
    with Dynamic2DMixin, Array2DViewMixin<dynamic>
    implements Array2DFix<dynamic>, Dynamic2DView {
  final List<Dynamic1DFix> _data;

  Dynamic2DFix(Iterable<Iterable<dynamic>> data) : _data = <Dynamic1DFix>[] {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<dynamic> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (Iterable<dynamic> item in data) {
        _data.add(new Dynamic1DFix(item));
      }
    }
  }

  /// Create [Int2D] from column major
  factory Dynamic2DFix.columns(Iterable<Iterable<dynamic>> columns) {
    if (columns.length == 0) {
      return new Dynamic2DFix.sized(0, 0);
    }

    if (!columns.every((i) => i.length == columns.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Dynamic2DFix.sized(columns.first.length, columns.length);
    for (int c = 0; c < ret.numCols; c++) {
      final Iterator<dynamic> col = columns.elementAt(c).iterator;
      col.moveNext();
      for (int r = 0; r < ret.numRows; r++) {
        ret[r][c] = col.current;
        col.moveNext();
      }
    }
    return ret;
  }

  Dynamic2DFix.from(Iterable<IterView<dynamic>> data)
      : _data = new List<Dynamic1DFix>(data.length) {
    if (data.length != 0) {
      final int len = data.first.length;
      for (IterView item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        IterView<dynamic> item = data.elementAt(i);
        _data[i] = new Dynamic1DFix.copy(item);
      }
    }
  }

  Dynamic2DFix.copy(Array2DView<dynamic> data)
      : _data = new List<Dynamic1DFix>(data.numRows) {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = new Dynamic1DFix.copy(data[i]);
    }
  }

  Dynamic2DFix.own(this._data);

  Dynamic2DFix.sized(int numRows, int numCols, {String data: ''})
      : _data = new List<Dynamic1DFix>.generate(
            numRows, (_) => new Dynamic1DFix.sized(numCols, data: data),
            growable: false);

  Dynamic2DFix.shaped(Index2D shape, {String data: ''})
      : _data = new List<Dynamic1DFix>.generate(
            shape.row, (_) => new Dynamic1DFix.sized(shape.col, data: data),
            growable: false);

  factory Dynamic2DFix.shapedLike(Array2DView like, {String data: ''}) =>
      new Dynamic2DFix.sized(like.numRows, like.numCols, data: data);

  factory Dynamic2DFix.diagonal(Iterable<dynamic> diagonal) {
    final ret = new Dynamic2DFix.sized(diagonal.length, diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      ret[i][i] = diagonal.elementAt(i);
    }
    return ret;
  }

  Dynamic2DFix.repeatRow(IterView<dynamic> row, [int numRows = 1])
      : _data = new List<Dynamic1DFix>(numRows) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Dynamic1DFix.copy(row);
    }
  }

  Dynamic2DFix.repeatCol(IterView<dynamic> column, [int numCols = 1])
      : _data = new List<Dynamic1DFix>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Dynamic1DFix.sized(numCols, data: column[i]);
    }
  }

  Dynamic2DFix.aRow(IterView<dynamic> row) : _data = new List<Dynamic1DFix>(1) {
    _data[0] = new Dynamic1DFix.copy(row);
  }

  Dynamic2DFix.aCol(IterView<dynamic> column)
      : _data = new List<Dynamic1DFix>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Dynamic1DFix.single(column[i]);
    }
  }

  factory Dynamic2DFix.genRows(
      int numRows, Iterable<dynamic> rowMaker(int index)) {
    final rows = <Dynamic1DFix>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Dynamic1DFix(v));
    }
    return new Dynamic2DFix.own(rows);
  }

  factory Dynamic2DFix.genCols(
      int numCols, Iterable<dynamic> colMaker(int index)) {
    final List<Iterable<dynamic>> cols = <Iterable<dynamic>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Dynamic2DFix.columns(cols);
  }

  factory Dynamic2DFix.gen(Index2D shape, String maker(int row, int col)) {
    final ret = new Dynamic2DFix.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret;
  }

  static Dynamic2DFix buildRows<T>(
      Iterable<T> iterable, Iterable<dynamic> rowMaker(T v)) {
    final rows = <Dynamic1DFix>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Dynamic1DFix(v));
    }
    return new Dynamic2DFix.own(rows);
  }

  static Dynamic2DFix buildCols<T>(
      Iterable<T> iterable, Iterable<dynamic> colMaker(T v)) {
    final List<Iterable<dynamic>> cols = <Iterable<dynamic>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Dynamic2DFix.columns(cols);
  }

  static Dynamic2DFix build<T>(Iterable<Iterable<T>> data, String maker(T v)) {
    if (data.length == 0) {
      return new Dynamic2DFix.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Dynamic2DFix.sized(data.length, data.first.length);
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

  covariant Dynamic2DColFix _col;

  Dynamic2DColFix get col => _col ??= new Dynamic2DColFix(this);

  covariant Dynamic2DRowFix _row;

  Dynamic2DRowFix get row => _row ??= new Dynamic2DRowFix(this);

  Dynamic1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, ArrayView<dynamic> val) {
    if (i >= numRows) {
      throw new RangeError.range(i, 0, numRows - 1, 'i');
    }

    if (numRows == 0) {
      final arr = new Dynamic1D.copy(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw new Exception('Invalid size!');

    final arr = new Dynamic1D.copy(val);

    _data[i] = arr;
  }

  /// Sets all elements in the array to given value [v]
  void set(dynamic v) {
    for (int c = 0; c < numRows; c++) {
      for (int r = 0; r < numCols; r++) {
        _data[c][r] = v;
      }
    }
  }

  @override
  void assign(Array2DView<dynamic> other) {
    if (other.shape != shape)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = other[r][c];
      }
    }
  }

  Dynamic2DView _view;

  Dynamic2DView get view => _view ??= new Dynamic2DView.own(_data);

  @override
  Iterable<ArrayFix<dynamic>> get rows => _data;

  @override
  Iterable<ArrayFix<dynamic>> get cols => new ColsListFix<dynamic>(this);

  Dynamic2DFix get fixed => this;
}
