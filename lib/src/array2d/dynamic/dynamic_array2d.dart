part of grizzly.series.array2d;

class Dynamic2D extends Object
    with
        Array2DViewMixin<dynamic>,
        Array2DFixMixin<dynamic>,
        IterableMixin<Iterable<dynamic>>,
        Dynamic2DMixin
    implements Array2D<dynamic>, Dynamic2DFix {
  final List<Dynamic1D> _data;

  final String1D _names;

  String1DFix get names => _names;

  Dynamic2D(Iterable<Iterable<dynamic>> rows, [Iterable<String> names])
      : _data = <Dynamic1D>[],
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
      _data[i] = Dynamic1D(rows.elementAt(i));
    }
  }

  Dynamic2D.own(this._data, [Iterable<String> names])
      : _names = names != null
            ? String1D(names, "Names")
            : String1D.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory Dynamic2D.sized(int rows, int cols,
      {dynamic fill, Iterable<String> names}) {
    final data = List<Dynamic1D>()..length = rows;
    for (int i = 0; i < rows; i++) {
      data[i] = Dynamic1D.sized(cols, fill: fill);
    }
    return Dynamic2D.own(data, names);
  }

  factory Dynamic2D.shaped(Index2D shape,
          {dynamic fill, Iterable<String> names}) =>
      Dynamic2D.sized(shape.row, shape.col, fill: fill, names: names);

  factory Dynamic2D.shapedLike(Array2DView like,
          {dynamic fill, Iterable<String> names}) =>
      Dynamic2D.sized(like.numRows, like.numCols, fill: fill, names: names);

  /// Create [Int2D] from column major
  factory Dynamic2D.columns(Iterable<Iterable<dynamic>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return Dynamic2D.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<Dynamic1D>()..length = numRows;
    for (int i = 0; i < numRows; i++) {
      final row = List<dynamic>()..length = numCols;
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = Dynamic1D.own(row);
    }
    return Dynamic2D.own(data, names);
  }

  factory Dynamic2D.diagonal(Iterable<dynamic> diagonal,
      {Iterable<String> names, dynamic fill}) {
    final ret = List<Dynamic1D>()..length = diagonal.length;
    for (int i = 0; i < diagonal.length; i++) {
      final row = List<dynamic>.filled(diagonal.length, fill, growable: true);
      row[i] = diagonal.elementAt(i);
      ret[i] = Dynamic1D.own(row);
    }
    return Dynamic2D.own(ret, names);
  }

  factory Dynamic2D.aRow(Iterable<dynamic> row,
          {int repeat = 1, Iterable<String> names}) =>
      Dynamic2D(
          List<Dynamic1DView>.filled(repeat, Dynamic1DView(row),
              growable: true),
          names);

  factory Dynamic2D.aCol(Iterable<dynamic> column,
          {int repeat = 1, Iterable<String> names}) =>
      Dynamic2D.columns(
          ranger.ConstantIterable<Iterable<dynamic>>(column, repeat), names);

  factory Dynamic2D.genRows(
      int numRows, Iterable<dynamic> rowMaker(int index)) {
    final rows = <Dynamic1D>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Dynamic1D(v));
    }
    return Dynamic2D.own(rows);
  }

  factory Dynamic2D.genCols(
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
    return Dynamic2D.columns(cols);
  }

  factory Dynamic2D.gen(Index2D shape, String maker(int row, int col)) {
    final ret = Dynamic2D.shaped(shape);
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
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Dynamic1D(v));
    }
    return Dynamic2D.own(rows);
  }

  static Dynamic2D buildCols<T>(
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
    return Dynamic2D.columns(cols);
  }

  static Dynamic2D build<T>(Iterable<Iterable<T>> data, String maker(T v)) {
    if (data.length == 0) {
      return Dynamic2D.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw Exception('Size mismatch!');
    }

    final ret = Dynamic2D.sized(data.length, data.first.length);
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

  covariant Dynamic2DCol _col;

  Dynamic2DCol get col => _col ??= Dynamic2DCol(this);

  covariant Dynamic2DRow _row;

  Dynamic2DRow get row => _row ??= Dynamic2DRow(this);

  Dynamic1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, final Iterable<dynamic> val) {
    if (i > numRows) {
      throw RangeError.range(i, 0, numRows - 1, 'i');
    }

    if (numRows == 0) {
      final arr = Dynamic1D(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw Exception('Invalid size!');

    final arr = Dynamic1D(val);

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
      throw ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = other[r][c];
      }
    }
  }

  @override
  void add(Iterable<dynamic> row) => this[numRows] = row;

  @override
  void addScalar(dynamic v) => _data.add(Dynamic1D.sized(numCols, fill: v));

  @override
  void insert(int index, Iterable<dynamic> row) {
    if (index > numRows) throw RangeError.range(index, 0, numRows);
    if (row.length != numCols)
      throw ArgumentError.value(row, 'row', 'Size mismatch!');
    _data.insert(index, Dynamic1D(row));
  }

  Dynamic2DView _view;

  Dynamic2DView get view => _view ??= Dynamic2DView.own(_data);

  Dynamic2DFix _fixed;

  Dynamic2DFix get fixed => _fixed ??= Dynamic2DFix.own(_data);

  @override
  Iterable<ArrayFix<dynamic>> get rows => _data;

  @override
  Iterable<ArrayFix<dynamic>> get cols => ColsListFix<dynamic>(this);

  void reshape(Index2D newShape, {dynamic def}) {
    if (shape == newShape) return;

    if (shape.row > newShape.row) {
      _data.removeRange(newShape.row, shape.row);
    } else {
      for (int i = shape.row; i < newShape.row; i++) {
        _data.add(Dynamic1D.sized(newShape.col, fill: def));
      }
    }

    if (shape.col > newShape.col) {
      for (Dynamic1D r in _data) {
        r.removeRange(newShape.col, r.length);
      }
    } else {
      for (Dynamic1D r in _data) {
        r.addAll(Dynamic1D.sized(newShape.col - r.length, fill: def));
      }
    }
  }
}
