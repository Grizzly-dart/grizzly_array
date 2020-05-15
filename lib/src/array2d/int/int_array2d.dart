part of grizzly.series.array2d;

class Int2D extends Object
    with
        Array2DViewMixin<int>,
        Array2DFixMixin<int>,
        IterableMixin<Iterable<int>>,
        Int2DViewMixin,
        Int2DFixMixin
    implements Numeric2D<int>, Int2DFix {
  final List<Int1D> _data;

  final String1D _names;

  String1DFix get names => _names;

  Int2D(Iterable<Iterable<int>> rows, [Iterable<String> names])
      : _data = <Int1D>[],
        _names = names != null
            ? String1D(names, "Names")
            : String1D.sized(rows.isNotEmpty ? rows.first.length : 0,
                name: 'Names') {
    if (rows.isEmpty) {
      Exceptions.labelLen(0, this.names.length);
      return;
    }
    Exceptions.labelLen(rows.first.length, this.names.length);
    Exceptions.rowsLen(rows);
    _data.length = rows.length;
    for (int i = 0; i < rows.length; i++) {
      _data[i] = Int1D(rows.elementAt(i));
    }
  }

  Int2D.own(this._data, [Iterable<String> names])
      : _names = names != null
            ? String1D(names, "Names")
            : String1D.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory Int2D.fromNums(Iterable<Iterable<num>> rows,
      [Iterable<String> names]) {
    final data = List<Int1D>()..length = rows.length;
    for (int i = 0; i < rows.length; i++)
      data[i] = Int1D.fromNums(rows.elementAt(i));
    return Int2D.own(data, names);
  }

  factory Int2D.sized(int rows, int cols,
      {int fill: 0, Iterable<String> names}) {
    final data = List<Int1D>()..length = rows;
    for (int i = 0; i < rows; i++) {
      data[i] = Int1D.sized(cols, fill: fill);
    }
    return Int2D.own(data, names);
  }

  factory Int2D.shaped(Index2D shape, {int fill: 0, Iterable<String> names}) =>
      Int2D.sized(shape.row, shape.col, fill: fill, names: names);

  factory Int2D.shapedLike(Array2DView like,
          {int fill: 0, Iterable<String> names}) =>
      Int2D.sized(like.numRows, like.numCols, fill: fill, names: names);

  /// Create [Int2D] from column major
  factory Int2D.columns(Iterable<Iterable<int>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return Int2D.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<Int1D>()..length = numRows;
    for (int i = 0; i < numRows; i++) {
      final row = List<int>()..length = numCols;
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = Int1D.own(row);
    }
    return Int2D.own(data, names);
  }

  factory Int2D.diagonal(Iterable<int> diagonal,
      {Index2D shape, Iterable<String> names, int fill: 0}) {
    shape ??= Index2D(diagonal.length, diagonal.length);
    final ret = Int2D.shaped(shape, fill: fill, names: names);
    int length = math.min(math.min(shape.row, shape.col), diagonal.length);
    for (int i = 0; i < length; i++) {
      ret[i][i] = diagonal.elementAt(i);
    }
    return ret;
  }

  factory Int2D.aRow(Iterable<int> row,
      {int repeat = 1, Iterable<String> names}) {
    final data = List<Int1D>.filled(repeat, null, growable: true);
    if (row is Iterable<int>) {
      for (int i = 0; i < repeat; i++) data[i] = Int1D(row);
    } else {
      final temp = Int1D.fromNums(row);
      data[0] = temp;
      for (int i = 1; i < repeat; i++) data[i] = Int1D(temp);
    }
    return Int2D.own(data, names);
  }

  factory Int2D.aCol(Iterable<int> column,
      {int repeat = 1, Iterable<String> names}) {
    if (column is Iterable<int>) {
      return Int2D.columns(
          ranger.ConstantIterable<Iterable<int>>(column, repeat), names);
    }
    return Int2D.columns(
        ranger.ConstantIterable<Iterable<int>>(Int1DView.fromNums(column), repeat),
        names);
  }

  factory Int2D.genRows(int numRows, Iterable<int> rowMaker(int index)) {
    final rows = <Int1D>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Int1D(v));
    }
    return Int2D.own(rows);
  }

  factory Int2D.genCols(int numCols, Iterable<int> colMaker(int index)) {
    final List<Iterable<int>> cols = <Iterable<int>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Int2D.columns(cols);
  }

  factory Int2D.gen(Index2D shape, int colMaker(int row, int col)) {
    final ret = Int2D.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = colMaker(r, c);
      }
    }
    return ret;
  }

  static Int2D buildRows<T>(Iterable<T> iterable, Iterable<int> rowMaker(T v)) {
    final rows = <Int1D>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Int1D(v));
    }
    return Int2D.own(rows);
  }

  static Int2D buildCols<T>(Iterable<T> iterable, Iterable<int> colMaker(T v)) {
    final List<Iterable<int>> cols = <Iterable<int>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Int2D.columns(cols);
  }

  static Int2D build<T>(Iterable<Iterable<T>> data, int colMaker(T v)) {
    if (data.length == 0) {
      return Int2D.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw Exception('Size mismatch!');
    }

    final ret = Int2D.sized(data.length, data.first.length);
    for (int r = 0; r < ret.numRows; r++) {
      final Iterator<T> row = data.elementAt(r).iterator;
      row.moveNext();
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = colMaker(row.current);
        row.moveNext();
      }
    }
    return ret;
  }

  Iterator<Int1DView> get iterator => _data.iterator;

  covariant Int2DCol _col;

  Int2DCol get col => _col ??= Int2DCol(this);

  covariant Int2DRow _row;

  Int2DRow get row => _row ??= Int2DRow(this);

  @override
  Iterable<ArrayFix<int>> get rows => _data;

  @override
  Iterable<ArrayFix<int>> get cols => ColsListFix<int>(this);

  Int1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, Iterable<int> val) {
    if (i > numRows) throw RangeError.range(i, 0, numRows - 1, 'i');

    if (numRows == 0) {
      final arr = Int1D(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw Exception('Invalid size!');

    final arr = Int1D(val);
    if (i == numRows) {
      _data.add(arr);
      return;
    }
    _data[i] = arr;
  }

  /// Sets all elements in the array to given value [v]
  void set(int v) {
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = v;
      }
    }
  }

  @override
  void assign(Array2DView<int> other) {
    if (other.shape != shape)
      throw ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = other[r][c];
      }
    }
  }

  @override
  void add(Iterable<int> row) => this[numRows] = row;

  @override
  void addScalar(int v) => _data.add(Int1D.sized(numCols, fill: v));

  @override
  void insert(int index, Iterable<int> row) {
    if (index > numRows) throw RangeError.range(index, 0, numRows);
    if (row.length != numCols)
      throw ArgumentError.value(row, 'row', 'Size mismatch!');
    _data.insert(index, Int1D(row));
  }

  void clip({int min, int max}) {
    if (numRows == 0) return;

    if (min != null && max != null) {
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < _data.first.length; j++) {
          final int d = _data[i][j];

          if (d < min) _data[i][j] = min;
          if (d > max) _data[i][j] = max;
        }
      }
      return;
    }
    if (min != null) {
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < _data.first.length; j++) {
          final int d = _data[i][j];

          if (d < min) _data[i][j] = min;
        }
      }
      return;
    }
    if (max != null) {
      for (int j = 0; j < _data.first.length; j++) {
        for (int i = 0; i < numRows; i++) {
          final int d = _data[i][j];

          if (d > max) _data[i][j] = max;
        }
      }
      return;
    }
  }

  // TODO return lazy
  // TODO return view
  IntPair<Int1D> pairAt(int index) => intPair<Int1D>(index, _data[index]);

  // TODO return lazy
  // TODO return view
  Iterable<IntPair<Int1D>> enumerate() =>
      ranger.indices(numRows).map((i) => intPair<Int1D>(i, _data[i]));

  Int2DView _view;

  Int2DView get view => _view ??= Int2DView.own(_data);

  Int2DFix _fixed;

  Int2DFix get fixed => _fixed ??= Int2DFix.own(_data);

  void reshape(Index2D newShape, {int def: 0}) {
    if (shape == newShape) return;

    if (shape.row > newShape.row) {
      _data.removeRange(newShape.row, shape.row);
    } else {
      for (int i = shape.row; i < newShape.row; i++) {
        _data.add(Int1D.sized(newShape.col, fill: def));
      }
    }

    if (shape.col > newShape.col) {
      for (Int1D r in _data) {
        r.removeRange(newShape.col, r.length);
      }
    } else {
      for (Int1D r in _data) {
        r.addAll(Int1D.sized(newShape.col - r.length, fill: def));
      }
    }
  }

  Int1D unique() => super.unique();
}
