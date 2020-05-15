part of grizzly.series.array2d;

/*
class String2DFix extends Object
    with
        Array2DViewMixin<String>,
        Array2DFixMixin<String>,
        IterableMixin<Iterable<String>>,
        String2DMixin
    implements Array2DFix<String>, String2DView {
  final List<String1DFix> _data;

  final String1DFix names;

  String2DFix(Iterable<Iterable<String>> rows, [Iterable<String> names])
      : _data = List<String1DFix>(rows.length),
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
      _data[i] = String1DFix(rows.elementAt(i));
    }
  }

  String2DFix.own(this._data, [Iterable<String> names])
      : names = names != null
            ? String1DFix(names, "Names")
            : String1DFix.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory String2DFix.sized(int rows, int cols,
      {String fill, Iterable<String> names}) {
    final data = List<String1DFix>(rows);
    for (int i = 0; i < rows; i++) {
      data[i] = String1DFix.sized(cols, fill: fill);
    }
    return String2DFix.own(data, names);
  }

  factory String2DFix.shaped(Index2D shape,
          {String fill, Iterable<String> names}) =>
      String2DFix.sized(shape.row, shape.col, fill: fill, names: names);

  factory String2DFix.shapedLike(Array2DView like,
          {String fill, Iterable<String> names}) =>
      String2DFix.sized(like.numRows, like.numCols, fill: fill, names: names);

  /// Create [Int2D] from column major
  factory String2DFix.columns(Iterable<Iterable<String>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return String2DFix.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<String1DFix>(numRows);
    for (int i = 0; i < numRows; i++) {
      final row = List<String>(numCols);
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = String1DFix.own(row);
    }
    return String2DFix.own(data, names);
  }

  factory String2DFix.diagonal(Iterable<String> diagonal,
      {Iterable<String> names, String fill}) {
    final ret = List<String1DFix>(diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      final row = List<String>.filled(diagonal.length, fill);
      row[i] = diagonal.elementAt(i);
      ret[i] = String1DFix.own(row);
    }
    return String2DFix.own(ret, names);
  }

  factory String2DFix.aRow(Iterable<String> row,
          {int repeat = 1, Iterable<String> names}) =>
      String2DFix(List<String1DView>.filled(repeat, String1DView(row)), names);

  factory String2DFix.aCol(Iterable<String> column,
          {int repeat = 1, Iterable<String> names}) =>
      String2DFix.columns(
          ranger.ConstantIterable<Iterable<String>>(column, repeat), names);

  factory String2DFix.genRows(
      int numRows, Iterable<String> rowMaker(int index)) {
    final rows = <String1DFix>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(String1DFix(v));
    }
    return String2DFix.own(rows);
  }

  factory String2DFix.genCols(
      int numCols, Iterable<String> colMaker(int index)) {
    final List<Iterable<String>> cols = <Iterable<String>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return String2DFix.columns(cols);
  }

  factory String2DFix.gen(Index2D shape, String maker(int row, int col)) {
    final ret = String2DFix.shaped(shape);
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
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(String1DFix(v));
    }
    return String2DFix.own(rows);
  }

  static String2DFix buildCols<T>(
      Iterable<T> iterable, Iterable<String> colMaker(T v)) {
    final List<Iterable<String>> cols = <Iterable<String>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return String2DFix.columns(cols);
  }

  static String2DFix build<T>(Iterable<Iterable<T>> data, String maker(T v)) {
    if (data.length == 0) {
      return String2DFix.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw Exception('Size mismatch!');
    }

    final ret = String2DFix.sized(data.length, data.first.length);
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

  Iterator<String1DView> get iterator => _data.iterator;

  covariant String2DColFix _col;

  String2DColFix get col => _col ??= String2DColFix(this);

  covariant String2DRowFix _row;

  String2DRowFix get row => _row ??= String2DRowFix(this);

  String1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, Iterable<String> val) {
    if (i >= numRows) {
      throw RangeError.range(i, 0, numRows - 1, 'i');
    }

    if (numRows == 0) {
      final arr = String1D(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw Exception('Invalid size!');

    final arr = String1D(val);

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
      throw ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = other[r][c];
      }
    }
  }

  String2DView _view;

  String2DView get view => _view ??= String2DView.own(_data);

  @override
  Iterable<ArrayFix<String>> get rows => _data;

  @override
  Iterable<ArrayFix<String>> get cols => ColsListFix<String>(this);

  String2DFix get fixed => this;
}
*/

