part of grizzly.series.array2d;

class Bool2DFix extends Object
    with
        Array2DViewMixin<bool>,
        Array2DFixMixin<bool>,
        IterableMixin<Iterable<bool>>,
        Bool2DViewMixin
    implements Array2DFix<bool>, Bool2DView {
  final List<Bool1DFix> _data;

  final String1DFix names;

  Bool2DFix(Iterable<Iterable<bool>> rows, [Iterable<String> names])
      : _data = List<Bool1DFix>(rows.length),
        names = names != null
            ? String1DFix(names, "Names")
            : String1DFix.sized(rows.isNotEmpty ? rows.first.length : 0,
                name: 'Names') {
    if (rows.isEmpty) {
      Exceptions.labelLen(0, this.names.length);
      return;
    }
    Exceptions.labelLen(rows.first.length, this.names.length);
    Exceptions.rowsLen(rows);
    for (int i = 0; i < rows.length; i++) {
      _data[i] = Bool1DFix(rows.elementAt(i));
    }
  }

  Bool2DFix.own(this._data, [Iterable<String> names])
      : names = names != null
            ? String1DFix(names, "Names")
            : String1DFix.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory Bool2DFix.sized(int rows, int cols,
      {bool fill: false, Iterable<String> names}) {
    final data = List<Bool1DFix>(rows);
    for (int i = 0; i < rows; i++) {
      data[i] = Bool1DFix.sized(cols, fill: fill);
    }
    return Bool2DFix.own(data, names);
  }

  factory Bool2DFix.shaped(Index2D shape,
          {bool fill: false, Iterable<String> names}) =>
      Bool2DFix.sized(shape.row, shape.col, fill: fill, names: names);

  factory Bool2DFix.shapedLike(Array2DView like,
          {bool fill: false, Iterable<String> names}) =>
      Bool2DFix.sized(like.numRows, like.numCols, fill: fill, names: names);

  /// Create [Int2D] from column major
  factory Bool2DFix.columns(Iterable<Iterable<bool>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return Bool2DFix.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<Bool1DFix>(numRows);
    for (int i = 0; i < numRows; i++) {
      final row = List<bool>(numCols);
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = Bool1DFix.own(row);
    }
    return Bool2DFix.own(data, names);
  }

  factory Bool2DFix.diagonal(Iterable<bool> diagonal,
      {Iterable<String> names, bool fill: false}) {
    final ret = List<Bool1DFix>(diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      final row = List<bool>.filled(diagonal.length, fill);
      row[i] = diagonal.elementAt(i);
      ret[i] = Bool1DFix.own(row);
    }
    return Bool2DFix.own(ret, names);
  }

  factory Bool2DFix.aRow(Iterable<bool> row,
          {int repeat = 1, Iterable<String> names}) =>
      Bool2DFix(
          List<Bool1DView>.filled(repeat, Bool1DView(row)), names);

  factory Bool2DFix.aCol(Iterable<bool> column,
          {int repeat = 1, Iterable<String> names}) =>
      Bool2DFix.columns(
          ConstantIterable<Iterable<bool>>(column, repeat), names);

  factory Bool2DFix.genRows(int numRows, Iterable<bool> rowMaker(int index)) {
    final rows = <Bool1DFix>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Bool1DFix(v));
    }
    return Bool2DFix.own(rows);
  }

  factory Bool2DFix.genCols(int numCols, Iterable<bool> colMaker(int index)) {
    final List<Iterable<bool>> cols = <Iterable<bool>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Bool2DFix.columns(cols);
  }

  factory Bool2DFix.gen(Index2D shape, bool maker(int row, int col)) {
    final ret = Bool2DFix.shaped(shape);
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
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Bool1DFix(v));
    }
    return Bool2DFix.own(rows);
  }

  static Bool2DFix buildCols<T>(
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
    return Bool2DFix.columns(cols);
  }

  static Bool2DFix build<T>(Iterable<Iterable<T>> data, bool maker(T v)) {
    if (data.length == 0) {
      return Bool2DFix.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw Exception('Size mismatch!');
    }

    final ret = Bool2DFix.sized(data.length, data.first.length);
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

  covariant Bool2DColFix _col;

  Bool2DColFix get col => _col ??= Bool2DColFix(this);

  covariant Bool2DRowFix _row;

  Bool2DRowFix get row => _row ??= Bool2DRowFix(this);

  Bool1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, Iterable<bool> val) {
    if (i >= numRows)
      throw RangeError.range(i, 0, numRows - 1, 'i', 'Out of range!');

    if (numRows == 0) {
      final arr = Bool1D(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) {
      throw Exception('Invalid size!');
    }

    final arr = Bool1D(val);

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
      throw ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = other[r][c];
      }
    }
  }

  Bool2DView _view;

  Bool2DView get view => _view ??= Bool2DView.own(_data);

  Bool2DFix get fixed => this;

  @override
  Iterable<ArrayFix<bool>> get rows => _data;

  @override
  Iterable<ArrayFix<bool>> get cols => ColsListFix<bool>(this);
}
