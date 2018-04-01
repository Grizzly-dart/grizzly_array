part of grizzly.series.array2d;

class String2DFix extends Object
    with Array2DViewMixin<String>, Array2DFixMixin<String>, String2DMixin
    implements Array2DFix<String>, String2DView {
  final List<String1DFix> _data;

  String2DFix(Iterable<Iterable<String>> data) : _data = <String1DFix>[] {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<String> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (Iterable<String> item in data) {
        _data.add(new String1DFix(item));
      }
    }
  }

  /// Create [Int2D] from column major
  factory String2DFix.columns(Iterable<Iterable<String>> columns) {
    if (columns.length == 0) {
      return new String2DFix.sized(0, 0);
    }

    if (!columns.every((i) => i.length == columns.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new String2DFix.sized(columns.first.length, columns.length);
    for (int c = 0; c < ret.numCols; c++) {
      final Iterator<String> col = columns.elementAt(c).iterator;
      col.moveNext();
      for (int r = 0; r < ret.numRows; r++) {
        ret[r][c] = col.current;
        col.moveNext();
      }
    }
    return ret;
  }

  String2DFix.from(Iterable<IterView<String>> data)
      : _data = new List<String1DFix>(data.length) {
    if (data.length != 0) {
      final int len = data.first.length;
      for (IterView item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        IterView<String> item = data.elementAt(i);
        _data[i] = new String1DFix.copy(item);
      }
    }
  }

  String2DFix.copy(Array2DView<String> data)
      : _data = new List<String1DFix>(data.numRows) {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = new String1DFix.copy(data[i]);
    }
  }

  String2DFix.own(this._data);

  String2DFix.sized(int numRows, int numCols, {String data: ''})
      : _data = new List<String1D>.generate(
            numRows, (_) => new String1D.sized(numCols, data: data),
            growable: false);

  String2DFix.shaped(Index2D shape, {String data: ''})
      : _data = new List<String1D>.generate(
            shape.row, (_) => new String1D.sized(shape.col, data: data),
            growable: false);

  factory String2DFix.shapedLike(Array2DView like, {String data: ''}) =>
      new String2DFix.sized(like.numRows, like.numCols, data: data);

  factory String2DFix.diagonal(Iterable<String> diagonal) {
    final ret = new String2DFix.sized(diagonal.length, diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      ret[i][i] = diagonal.elementAt(i);
    }
    return ret;
  }

  String2DFix.repeatRow(IterView<String> row, [int numRows = 1])
      : _data = new List<String1DFix>(numRows) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new String1DFix.copy(row);
    }
  }

  String2DFix.repeatCol(IterView<String> column, [int numCols = 1])
      : _data = new List<String1DFix>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new String1DFix.sized(numCols, data: column[i]);
    }
  }

  String2DFix.aRow(IterView<String> row) : _data = new List<String1DFix>(1) {
    _data[0] = new String1DFix.copy(row);
  }

  String2DFix.aCol(IterView<String> column)
      : _data = new List<String1DFix>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new String1DFix.single(column[i]);
    }
  }

  factory String2DFix.genRows(
      int numRows, Iterable<String> rowMaker(int index)) {
    final rows = <String1DFix>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new String1DFix(v));
    }
    return new String2DFix.own(rows);
  }

  factory String2DFix.genCols(
      int numCols, Iterable<String> colMaker(int index)) {
    final List<Iterable<String>> cols = <Iterable<String>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new String2DFix.columns(cols);
  }

  factory String2DFix.gen(Index2D shape, String maker(int row, int col)) {
    final ret = new String2DFix.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret;
  }

  static String2DFix buildRows<T>(
      Iterable<T> iterable, Iterable<String> rowMaker(T v)) {
    final rows = <String1DFix>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new String1DFix(v));
    }
    return new String2DFix.own(rows);
  }

  static String2DFix buildCols<T>(
      Iterable<T> iterable, Iterable<String> colMaker(T v)) {
    final List<Iterable<String>> cols = <Iterable<String>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new String2DFix.columns(cols);
  }

  static String2DFix build<T>(Iterable<Iterable<T>> data, String maker(T v)) {
    if (data.length == 0) {
      return new String2DFix.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new String2DFix.sized(data.length, data.first.length);
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

  covariant String2DColFix _col;

  String2DColFix get col => _col ??= new String2DColFix(this);

  covariant String2DRowFix _row;

  String2DRowFix get row => _row ??= new String2DRowFix(this);

  String1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, IterView<String> val) {
    if (i >= numRows) {
      throw new RangeError.range(i, 0, numRows - 1, 'i');
    }

    if (numRows == 0) {
      final arr = new String1D.copy(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw new Exception('Invalid size!');

    final arr = new String1D.copy(val);

    _data[i] = arr;
  }

  /// Sets all elements in the array to given value [v]
  void set(String v) {
    for (int c = 0; c < numRows; c++) {
      for (int r = 0; r < numCols; r++) {
        _data[c][r] = v;
      }
    }
  }

  @override
  void assign(Array2DView<String> other) {
    if (other.shape != shape)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = other[r][c];
      }
    }
  }

  String2DView _view;

  String2DView get view => _view ??= new String2DView.own(_data);

  @override
  Iterable<ArrayFix<String>> get rows => _data;

  @override
  Iterable<ArrayFix<String>> get cols => new ColsListFix<String>(this);

  String2DFix get fixed => this;
}
