part of grizzly.series.array2d;

/*
class String2DView extends Object
    with
        Array2DViewMixin<String>,
        IterableMixin<Iterable<String>>,
        String2DMixin
    implements Array2DView<String> {
  final String1DView names;

  final List<String1DView> _data;

  String2DView(Iterable<Iterable<String>> rows, [Iterable<String> names])
      : _data = List<String1DView>(rows.length),
        names = names != null
            ? String1DView(names, "Names")
            : String1DView.sized(rows.isNotEmpty ? rows.first.length : 0,
                name: 'Names') {
    if (rows.isEmpty) {
      Exceptions.labelLen(0, this.names.length);
      return;
    }
    Exceptions.labelLen(rows.first.length, this.names.length);
    Exceptions.rowsLen(rows);
    for (int i = 0; i < rows.length; i++) {
      _data[i] = String1DView(rows.elementAt(i));
    }
  }

  String2DView.own(this._data, [Iterable<String> names])
      : names = names != null
            ? String1DView(names, "Names")
            : String1DView.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory String2DView.sized(int numRows, int numCols,
      {String fill, Iterable<String> names}) {
    final data = List<String1DView>(numRows);
    for (int i = 0; i < numRows; i++) {
      data[i] = String1DView.sized(numCols, fill: fill);
    }
    return String2DView.own(data, names);
  }

  factory String2DView.shaped(Index2D shape,
          {String fill, Iterable<String> names}) =>
      String2DView.sized(shape.row, shape.col, fill: fill, names: names);

  factory String2DView.shapedLike(Array2DView like,
          {String fill, Iterable<String> names}) =>
      String2DView.sized(like.numRows, like.numCols, fill: fill, names: names);

  /// Create [Int2D] from column major
  factory String2DView.columns(Iterable<Iterable<String>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return String2DView.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<String1DView>(numRows);
    for (int i = 0; i < numRows; i++) {
      final row = List<String>(numCols);
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = String1DView.own(row);
    }
    return String2DView.own(data, names);
  }

  factory String2DView.diagonal(Iterable<String> diagonal,
      {Iterable<String> names, String fill}) {
    final ret = List<String1DView>(diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      final row = List<String>.filled(diagonal.length, fill);
      row[i] = diagonal.elementAt(i);
      ret[i] = String1DView.own(row);
    }
    return String2DView.own(ret, names);
  }

  factory String2DView.aRow(Iterable<String> row,
          {int repeat = 1, Iterable<String> names}) =>
      String2DView.own(
          List<String1DView>.filled(repeat, String1DView(row)), names);

  factory String2DView.repeatCol(Iterable<String> column,
          {int repeat = 1, Iterable<String> names}) =>
      String2DView.columns(
          ranger.ConstantIterable<Iterable<String>>(column, repeat), names);

  factory String2DView.genRows(
      int numRows, Iterable<String> rowMaker(int index)) {
    final rows = <String1DView>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(String1DView(v));
    }
    return String2DView.own(rows);
  }

  factory String2DView.genCols(
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
    return String2DView.columns(cols);
  }

  factory String2DView.gen(Index2D shape, String maker(int row, int col)) {
    final ret = String2DFix.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret.view;
  }

  static String2DView buildRows<T>(
      Iterable<T> iterable, Iterable<String> rowMaker(T v)) {
    final rows = <String1DView>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(String1DView(v));
    }
    return String2DView.own(rows);
  }

  static String2DView buildCols<T>(
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
    return String2DView.columns(cols);
  }

  static String2DView build<T>(Iterable<Iterable<T>> data, String maker(T v)) {
    if (data.length == 0) {
      return String2DView.sized(0, 0);
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
    return ret.view;
  }

  Iterator<String1DView> get iterator => _data.iterator;

  covariant String2DColView _col;

  String2DColView get col => _col ??= String2DColView(this);

  covariant String2DRowView _row;

  String2DRowView get row => _row ??= String2DRowView(this);

  String1DView operator [](int i) => _data[i].view;

  @override
  Iterable<ArrayView<String>> get rows => _data;

  @override
  Iterable<ArrayView<String>> get cols => ColsListView<String>(this);

  String2DView get view => this;
}
*/
