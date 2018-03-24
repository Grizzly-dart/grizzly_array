part of grizzly.series.array2d;

class Dynamic2D extends Object
    with Dynamic2DMixin, Array2DViewMixin<dynamic>
    implements Array2D<dynamic>, Dynamic2DFix {
  final List<Dynamic1D> _data;

  Dynamic2D(Iterable<Iterable<dynamic>> data) : _data = <Dynamic1D>[] {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<dynamic> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (Iterable<dynamic> item in data) {
        _data.add(new Dynamic1D(item));
      }
    }
  }

  /// Create [Int2D] from column major
  factory Dynamic2D.columns(Iterable<Iterable<dynamic>> columns) {
    if (columns.length == 0) {
      return new Dynamic2D.sized(0, 0);
    }

    if (!columns.every((i) => i.length == columns.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Dynamic2D.sized(columns.first.length, columns.length);
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

  Dynamic2D.from(Iterable<IterView<dynamic>> data)
      : _data = new List<Dynamic1D>()..length = data.length {
    if (data.length != 0) {
      final int len = data.first.length;
      for (IterView<dynamic> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        IterView item = data.elementAt(i);
        _data[i] = new Dynamic1D.copy(item);
      }
    }
  }

  Dynamic2D.copy(Array2DView<dynamic> data)
      : _data = new List<Dynamic1D>()..length = data.numRows {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = data[i].clone();
    }
  }

  Dynamic2D.own(this._data) {
    // TODO check that all rows are of same length
  }

  Dynamic2D.sized(int numRows, int numCols, {String data: ''})
      : _data = new List<Dynamic1D>.generate(
            numRows, (_) => new Dynamic1D.sized(numCols, data: data));

  Dynamic2D.shaped(Index2D shape, {String data: ''})
      : _data = new List<Dynamic1D>.generate(
            shape.row, (_) => new Dynamic1D.sized(shape.col, data: data));

  factory Dynamic2D.shapedLike(Array2DView like, {String data: ''}) =>
      new Dynamic2D.sized(like.numRows, like.numCols, data: data);

  factory Dynamic2D.diagonal(Iterable<dynamic> diagonal) {
    final ret = new Dynamic2D.sized(diagonal.length, diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      ret[i][i] = diagonal.elementAt(i);
    }
    return ret;
  }

  Dynamic2D.repeatRow(ArrayView<dynamic> row, [int numRows = 1])
      : _data = new List<Dynamic1D>()..length = numRows {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Dynamic1D.copy(row);
    }
  }

  Dynamic2D.repeatCol(ArrayView<dynamic> column, [int numCols = 1])
      : _data = new List<Dynamic1D>()..length = column.length {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Dynamic1D.sized(numCols, data: column[i]);
    }
  }

  Dynamic2D.aRow(ArrayView<dynamic> row)
      : _data = new List<Dynamic1D>()..length = 1 {
    _data[0] = new Dynamic1D.copy(row);
  }

  Dynamic2D.aCol(ArrayView<dynamic> column)
      : _data = new List<Dynamic1D>()..length = column.length {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Dynamic1D.single(column[i]);
    }
  }

  factory Dynamic2D.genRows(
      int numRows, Iterable<dynamic> rowMaker(int index)) {
    final rows = <Dynamic1D>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Dynamic1D(v));
    }
    return new Dynamic2D.own(rows);
  }

  factory Dynamic2D.genCols(
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
    return new Dynamic2D.columns(cols);
  }

  factory Dynamic2D.gen(Index2D shape, String maker(int row, int col)) {
    final ret = new Dynamic2D.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret;
  }

  static Dynamic2D buildRows<T>(
      Iterable<T> iterable, Iterable<dynamic> rowMaker(T v)) {
    final rows = <Dynamic1D>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Dynamic1D(v));
    }
    return new Dynamic2D.own(rows);
  }

  static Dynamic2D buildCols<T>(
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
    return new Dynamic2D.columns(cols);
  }

  static Dynamic2D build<T>(Iterable<Iterable<T>> data, String maker(T v)) {
    if (data.length == 0) {
      return new Dynamic2D.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Dynamic2D.sized(data.length, data.first.length);
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

  covariant Dynamic2DCol _col;

  Dynamic2DCol get col => _col ??= new Dynamic2DCol(this);

  covariant Dynamic2DRow _row;

  Dynamic2DRow get row => _row ??= new Dynamic2DRow(this);

  Iterator<Dynamic1D> get iterator => _data.iterator;

  Dynamic1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, final ArrayView<dynamic> val) {
    if (i > numRows) {
      throw new RangeError.range(i, 0, numRows - 1, 'i');
    }

    if (numRows == 0) {
      final arr = new Dynamic1D.copy(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw new Exception('Invalid size!');

    final arr = new Dynamic1D.copy(val);

    if (i == numRows) {
      _data.add(arr);
      return;
    }

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

  @override
  void add(ArrayView<dynamic> row) => this[numRows] = row;

  @override
  void addScalar(dynamic v) => _data.add(new Dynamic1D.sized(numCols, data: v));

  @override
  void insert(int index, ArrayView<dynamic> row) {
    if (index > numRows) throw new RangeError.range(index, 0, numRows);
    if (row.length != numCols)
      throw new ArgumentError.value(row, 'row', 'Size mismatch!');
    _data.insert(index, new Dynamic1D.copy(row));
  }

  Dynamic2DView _view;

  Dynamic2DView get view => _view ??= new Dynamic2DView.own(_data);

  Dynamic2DFix _fixed;

  Dynamic2DFix get fixed => _fixed ??= new Dynamic2DFix.own(_data);

  @override
  Iterable<ArrayFix<dynamic>> get rows => _data;

  @override
  Iterable<ArrayFix<dynamic>> get cols => new ColsListFix<dynamic>(this);
}
