part of grizzly.series.array2d;

class String2D extends Object
    with String2DMixin, Array2DViewMixin<String>
    implements Array2D<String>, String2DFix {
  final List<String1D> _data;

  String2D(Iterable<Iterable<String>> data) : _data = <String1D>[] {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<String> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (Iterable<String> item in data) {
        _data.add(new String1D(item));
      }
    }
  }

  /// Create [Int2D] from column major
  factory String2D.columns(Iterable<Iterable<String>> columns) {
    if (columns.length == 0) {
      return new String2D.sized(0, 0);
    }

    if (!columns.every((i) => i.length == columns.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new String2D.sized(columns.first.length, columns.length);
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

  String2D.from(Iterable<IterView<String>> data)
      : _data = new List<String1D>()..length = data.length {
    if (data.length != 0) {
      final int len = data.first.length;
      for (IterView<String> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        IterView<String> item = data.elementAt(i);
        _data[i] = new String1D.copy(item);
      }
    }
  }

  String2D.copy(Array2DView<String> data)
      : _data = new List<String1D>()..length = data.numRows {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = data[i].clone();
    }
  }

  String2D.own(this._data) {
    // TODO check that all rows are of same length
  }

  String2D.sized(int numRows, int numCols, {String data: ''})
      : _data = new List<String1D>.generate(
            numRows, (_) => new String1D.sized(numCols, data: data));

  String2D.shaped(Index2D shape, {String data: ''})
      : _data = new List<String1D>.generate(
            shape.row, (_) => new String1D.sized(shape.col, data: data));

  factory String2D.shapedLike(Array2DView like, {String data: ''}) =>
      new String2D.sized(like.numRows, like.numCols, data: data);

  factory String2D.diagonal(
      /* IterView<String> | Iterable<String> */ diagonal) {
    if (diagonal is IterView<String>) {
      diagonal = diagonal.asIterable;
    }
    if (diagonal is Iterable<String>) {
      final ret = new String2D.sized(diagonal.length, diagonal.length);
      for (int i = 0; i < diagonal.length; i++) {
        ret[i][i] = diagonal.elementAt(i);
      }
      return ret;
    }
    throw new UnsupportedError('Type');
  }

  String2D.repeatRow(ArrayView<String> row, [int numRows = 1])
      : _data = new List<String1D>()..length = numRows {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new String1D.copy(row);
    }
  }

  String2D.repeatCol(ArrayView<String> column, [int numCols = 1])
      : _data = new List<String1D>()..length = column.length {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new String1D.sized(numCols, data: column[i]);
    }
  }

  String2D.aRow(ArrayView<String> row)
      : _data = new List<String1D>()..length = 1 {
    _data[0] = new String1D.copy(row);
  }

  String2D.aCol(ArrayView<String> column)
      : _data = new List<String1D>()..length = column.length {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new String1D.single(column[i]);
    }
  }

  factory String2D.genRows(int numRows, Iterable<String> rowMaker(int index)) {
    final rows = <String1D>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new String1D(v));
    }
    return new String2D.own(rows);
  }

  factory String2D.genCols(int numCols, Iterable<String> colMaker(int index)) {
    final List<Iterable<String>> cols = <Iterable<String>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new String2D.columns(cols);
  }

  factory String2D.gen(Index2D shape, String maker(int row, int col)) {
    final ret = new String2D.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret;
  }

  static String2D buildRows<T>(
      Iterable<T> iterable, Iterable<String> rowMaker(T v)) {
    final rows = <String1D>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new String1D(v));
    }
    return new String2D.own(rows);
  }

  static String2D buildCols<T>(
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
    return new String2D.columns(cols);
  }

  static String2D build<T>(Iterable<Iterable<T>> data, String maker(T v)) {
    if (data.length == 0) {
      return new String2D.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new String2D.sized(data.length, data.first.length);
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

  covariant String2DCol _col;

  String2DCol get col => _col ??= new String2DCol(this);

  covariant String2DRow _row;

  String2DRow get row => _row ??= new String2DRow(this);

  String1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, final IterView<String> val) {
    if (i > numRows) {
      throw new RangeError.range(i, 0, numRows - 1, 'i');
    }

    if (numRows == 0) {
      final arr = new String1D.copy(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw new Exception('Invalid size!');

    final arr = new String1D.copy(val);

    if (i == numRows) {
      _data.add(arr);
      return;
    }

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

  @override
  void add(IterView<String> row) => this[numRows] = row;

  @override
  void addScalar(String v) => _data.add(new String1D.sized(numCols, data: v));

  @override
  void insert(int index, IterView<String> row) {
    if (index > numRows) throw new RangeError.range(index, 0, numRows);
    if (row.length != numCols)
      throw new ArgumentError.value(row, 'row', 'Size mismatch!');
    _data.insert(index, new String1D.copy(row));
  }

  String2DView _view;

  String2DView get view => _view ??= new String2DView.own(_data);

  String2DFix _fixed;

  String2DFix get fixed => _fixed ??= new String2DFix.own(_data);

  @override
  Iterable<ArrayFix<String>> get rows => _data;

  @override
  Iterable<ArrayFix<String>> get cols => new ColsListFix<String>(this);

  void reshape(Index2D newShape, {String def}) {
    if (shape == newShape) return;

    if (shape.row > newShape.row) {
      _data.removeRange(newShape.row, shape.row);
    } else {
      for (int i = shape.row; i < newShape.row; i++) {
        _data.add(new String1D.sized(newShape.col, data: def));
      }
    }

    if (shape.col > newShape.col) {
      for (String1D r in _data) {
        r.removeRange(newShape.col, r.length);
      }
    } else {
      for (String1D r in _data) {
        r.addAll(new String1D.sized(newShape.col - r.length, data: def));
      }
    }
  }
}
