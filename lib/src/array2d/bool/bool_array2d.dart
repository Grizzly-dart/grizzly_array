part of grizzly.series.array2d;

class Bool2D extends Object
    with Array2DMixin<bool>, IterableMixin<Iterable<bool>>, Bool2DViewMixin
    implements Array2D<bool> {
  final List<Bool1D> _data;

  final String1D _names;

  String1DFix get names => _names;

  Bool2D(Iterable<Iterable<bool>> rows, [Iterable<String> names])
      : _data = <Bool1D>[],
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
      _data[i] = Bool1D(rows.elementAt(i));
    }
  }

  Bool2D.own(this._data, [Iterable<String> names])
      : _names = names != null
            ? String1D(names, "Names")
            : String1D.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory Bool2D.sized(int rows, int cols,
      {bool fill: false, Iterable<String> names}) {
    final data = List<Bool1D>()..length = rows;
    for (int i = 0; i < rows; i++) {
      data[i] = Bool1D.sized(cols, fill: fill);
    }
    return Bool2D.own(data, names);
  }

  factory Bool2D.shaped(Index2D shape,
          {bool fill: false, Iterable<String> names}) =>
      Bool2D.sized(shape.row, shape.col, fill: fill, names: names);

  factory Bool2D.shapedLike(Array2D like,
          {bool fill: false, Iterable<String> names}) =>
      Bool2D.sized(like.numRows, like.numCols, fill: fill, names: names);

  /// Create [Int2D] from column major
  factory Bool2D.columns(Iterable<Iterable<bool>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return Bool2D.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<Bool1D>()..length = numRows;
    for (int i = 0; i < numRows; i++) {
      final row = List<bool>()..length = numCols;
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = Bool1D.own(row);
    }
    return Bool2D.own(data, names);
  }

  factory Bool2D.diagonal(Iterable<bool> diagonal,
      {Iterable<String> names, bool fill: false}) {
    final ret = List<Bool1D>()..length = diagonal.length;
    for (int i = 0; i < diagonal.length; i++) {
      final row = List<bool>.filled(diagonal.length, fill, growable: true);
      row[i] = diagonal.elementAt(i);
      ret[i] = Bool1D.own(row);
    }
    return Bool2D.own(ret, names);
  }

  factory Bool2D.aRow(Iterable<bool> row,
          {int repeat = 1, Iterable<String> names}) =>
      Bool2D(List<Bool1DView>.filled(repeat, Bool1DView(row), growable: true),
          names);

  factory Bool2D.aCol(Iterable<bool> column,
          {int repeat = 1, Iterable<String> names}) =>
      Bool2D.columns(
          ranger.ConstantIterable<Iterable<bool>>(column, repeat), names);

  factory Bool2D.genRows(int numRows, Iterable<bool> rowMaker(int index)) {
    final rows = <Bool1D>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Bool1D(v));
    }
    return Bool2D.own(rows);
  }

  factory Bool2D.genCols(int numCols, Iterable<bool> colMaker(int index)) {
    final List<Iterable<bool>> cols = <Iterable<bool>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Bool2D.columns(cols);
  }

  factory Bool2D.gen(Index2D shape, bool maker(int row, int col)) {
    final ret = Bool2D.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret;
  }

  static Bool2D buildRows<T>(
      Iterable<T> iterable, Iterable<bool> rowMaker(T v)) {
    final rows = <Bool1D>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Bool1D(v));
    }
    return Bool2D.own(rows);
  }

  static Bool2D buildCols<T>(
      Iterable<T> iterable, Iterable<bool> colMaker(T v)) {
    final List<Iterable<bool>> cols = <Iterable<bool>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Bool2D.columns(cols);
  }

  static Bool2D build<T>(Iterable<Iterable<T>> data, bool maker(T v)) {
    if (data.length == 0) {
      return Bool2D.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw Exception('Size mismatch!');
    }

    final ret = Bool2D.sized(data.length, data.first.length);
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

  Iterator<Bool1DView> get iterator => _data.iterator;

  covariant Bool2DCol _col;

  Bool2DCol get col => _col ??= Bool2DCol(this);

  covariant Bool2DRow _row;

  Bool2DRow get row => _row ??= Bool2DRow(this);

  Bool1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, final Iterable<bool> val) {
    if (i > numRows) {
      throw RangeError.range(i, 0, numRows - 1, 'i', 'Out of range!');
    }

    if (numRows == 0) {
      final arr = Bool1D(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) {
      throw Exception('Invalid size!');
    }

    final arr = Bool1D(val);

    if (i == numRows) {
      _data.add(arr);
      return;
    }

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
  void assign(Array2D<bool> other) {
    if (other.shape != shape)
      throw ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = other[r][c];
      }
    }
  }

  @override
  void add(Iterable<bool> row) => this[numRows] = row;

  @override
  void addScalar(bool v) => _data.add(Bool1D.sized(numCols, fill: v));

  @override
  void insert(int index, Iterable<bool> row) {
    if (index > numRows) throw RangeError.range(index, 0, numRows);
    if (row.length != numCols)
      throw ArgumentError.value(row, 'row', 'Size mismatch!');
    _data.insert(index, Bool1D(row));
  }

  @override
  Iterable<ArrayFix<bool>> get rows => _data;

  @override
  Iterable<ArrayFix<bool>> get cols => ColsList<bool>(this);

  void reshape(Index2D newShape, {bool def: false}) {
    if (shape == newShape) return;

    if (shape.row > newShape.row) {
      _data.removeRange(newShape.row, shape.row);
    } else {
      for (int i = shape.row; i < newShape.row; i++) {
        _data.add(Bool1D.sized(newShape.col, fill: def));
      }
    }

    if (shape.col > newShape.col) {
      for (Bool1D r in _data) {
        r.removeRange(newShape.col, r.length);
      }
    } else {
      for (Bool1D r in _data) {
        r.addAll(Bool1D.sized(newShape.col - r.length, fill: def));
      }
    }
  }
}
