part of grizzly.series.array2d;

/*
class Dynamic2DFix extends Object
    with
        Array2DViewMixin<dynamic>,
        Array2DFixMixin<dynamic>,
        IterableMixin<Iterable<dynamic>>,
        Dynamic2DMixin
    implements Array2DFix<dynamic>, Dynamic2DView {
  final List<Dynamic1DFix> _data;

  final String1DFix names;

  Dynamic2DFix(Iterable<Iterable<dynamic>> rows, [Iterable<String> names])
      : _data = List<Dynamic1DFix>(rows.length),
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
      _data[i] = Dynamic1DFix(rows.elementAt(i));
    }
  }

  Dynamic2DFix.own(this._data, [Iterable<String> names])
      : names = names != null
            ? String1DFix(names, "Names")
            : String1DFix.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory Dynamic2DFix.sized(int rows, int cols,
      {dynamic fill, Iterable<String> names}) {
    final data = List<Dynamic1DFix>(rows);
    for (int i = 0; i < rows; i++) {
      data[i] = Dynamic1DFix.sized(cols, fill: fill);
    }
    return Dynamic2DFix.own(data, names);
  }

  factory Dynamic2DFix.shaped(Index2D shape,
          {dynamic fill, Iterable<String> names}) =>
      Dynamic2DFix.sized(shape.row, shape.col, fill: fill, names: names);

  factory Dynamic2DFix.shapedLike(Array2DView like,
          {dynamic fill, Iterable<String> names}) =>
      Dynamic2DFix.sized(like.numRows, like.numCols, fill: fill, names: names);

  /// Create [Int2D] from column major
  factory Dynamic2DFix.columns(Iterable<Iterable<dynamic>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return Dynamic2DFix.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<Dynamic1DFix>(numRows);
    for (int i = 0; i < numRows; i++) {
      final row = List<dynamic>(numCols);
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = Dynamic1DFix.own(row);
    }
    return Dynamic2DFix.own(data, names);
  }

  factory Dynamic2DFix.diagonal(Iterable<dynamic> diagonal,
      {Iterable<String> names, dynamic fill}) {
    final ret = List<Dynamic1DFix>(diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      final row = List<dynamic>.filled(diagonal.length, fill);
      row[i] = diagonal.elementAt(i);
      ret[i] = Dynamic1DFix.own(row);
    }
    return Dynamic2DFix.own(ret, names);
  }

  factory Dynamic2DFix.aRow(Iterable<dynamic> row,
          {int repeat = 1, Iterable<String> names}) =>
      Dynamic2DFix(
          List<Dynamic1DView>.filled(repeat, Dynamic1DView(row)), names);

  factory Dynamic2DFix.aCol(Iterable<dynamic> column,
          {int repeat = 1, Iterable<String> names}) =>
      Dynamic2DFix.columns(
          ranger.ConstantIterable<Iterable<dynamic>>(column, repeat), names);

  factory Dynamic2DFix.genRows(
      int numRows, Iterable<dynamic> rowMaker(int index)) {
    final rows = <Dynamic1DFix>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Dynamic1DFix(v));
    }
    return Dynamic2DFix.own(rows);
  }

  factory Dynamic2DFix.genCols(
      int numCols, Iterable<dynamic> colMaker(int index)) {
    final List<Iterable<dynamic>> cols = <Iterable<dynamic>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Dynamic2DFix.columns(cols);
  }

  factory Dynamic2DFix.gen(Index2D shape, String maker(int row, int col)) {
    final ret = Dynamic2DFix.shaped(shape);
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
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Dynamic1DFix(v));
    }
    return Dynamic2DFix.own(rows);
  }

  static Dynamic2DFix buildCols<T>(
      Iterable<T> iterable, Iterable<dynamic> colMaker(T v)) {
    final List<Iterable<dynamic>> cols = <Iterable<dynamic>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Dynamic2DFix.columns(cols);
  }

  static Dynamic2DFix build<T>(Iterable<Iterable<T>> data, String maker(T v)) {
    if (data.length == 0) {
      return Dynamic2DFix.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw Exception('Size mismatch!');
    }

    final ret = Dynamic2DFix.sized(data.length, data.first.length);
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

  Iterator<Dynamic1DView> get iterator => _data.iterator;

  covariant Dynamic2DColFix _col;

  Dynamic2DColFix get col => _col ??= Dynamic2DColFix(this);

  covariant Dynamic2DRowFix _row;

  Dynamic2DRowFix get row => _row ??= Dynamic2DRowFix(this);

  Dynamic1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, Iterable<dynamic> val) {
    if (i >= numRows) {
      throw RangeError.range(i, 0, numRows - 1, 'i');
    }

    if (numRows == 0) {
      final arr = Dynamic1D(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw Exception('Invalid size!');

    final arr = Dynamic1D(val);

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
      throw ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = other[r][c];
      }
    }
  }

  Dynamic2DView _view;

  Dynamic2DView get view => _view ??= Dynamic2DView.own(_data);

  @override
  Iterable<ArrayFix<dynamic>> get rows => _data;

  @override
  Iterable<ArrayFix<dynamic>> get cols => ColsListFix<dynamic>(this);

  Dynamic2DFix get fixed => this;
}
*/
