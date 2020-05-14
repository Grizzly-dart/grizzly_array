part of grizzly.series.array2d;

class Dynamic2DView extends Object
    with
        Array2DViewMixin<dynamic>,
        IterableMixin<Iterable<dynamic>>,
        Dynamic2DMixin
    implements DynamicArray2DView {
  final List<Dynamic1DView> _data;

  final String1DView names;

  Dynamic2DView(Iterable<Iterable<dynamic>> rows, [Iterable<String> names])
      : _data = List<Dynamic1DView>(rows.length),
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
      _data[i] = Dynamic1DView(rows.elementAt(i));
    }
  }

  Dynamic2DView.own(this._data, [Iterable<String> names])
      : names = names != null
            ? String1DView(names, "Names")
            : String1DView.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory Dynamic2DView.sized(int numRows, int numCols,
      {dynamic fill, Iterable<String> names}) {
    final data = List<Dynamic1DView>(numRows);
    for (int i = 0; i < numRows; i++) {
      data[i] = Dynamic1DView.sized(numCols, fill: fill);
    }
    return Dynamic2DView.own(data, names);
  }

  factory Dynamic2DView.shaped(Index2D shape,
          {dynamic fill, Iterable<String> names}) =>
      Dynamic2DView.sized(shape.row, shape.col, fill: fill, names: names);

  factory Dynamic2DView.shapedLike(Array2DView like,
          {dynamic fill, Iterable<String> names}) =>
      Dynamic2DView.sized(like.numRows, like.numCols,
          fill: fill, names: names);

  /// Create [Dynamic2DView] from column major
  factory Dynamic2DView.columns(Iterable<Iterable<dynamic>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return Dynamic2DView.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<Dynamic1DView>(numRows);
    for (int i = 0; i < numRows; i++) {
      final row = List<dynamic>(numCols);
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = Dynamic1DView.own(row);
    }
    return Dynamic2DView.own(data, names);
  }

  factory Dynamic2DView.diagonal(Iterable<dynamic> diagonal,
      {Iterable<String> names, dynamic fill}) {
    final ret = List<Dynamic1DView>(diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      final row = List<dynamic>.filled(diagonal.length, fill);
      row[i] = diagonal.elementAt(i);
      ret[i] = Dynamic1DView.own(row);
    }
    return Dynamic2DView.own(ret, names);
  }

  factory Dynamic2DView.aRow(Iterable<dynamic> row,
          {int repeat = 1, Iterable<String> names}) =>
      Dynamic2DView.own(
          List<Dynamic1DView>.filled(repeat, Dynamic1DView(row)),
          names);

  factory Dynamic2DView.repeatCol(Iterable<dynamic> column,
          {int repeat = 1, Iterable<String> names}) =>
      Dynamic2DView.columns(
          ConstantIterable<Iterable<dynamic>>(column, repeat), names);

  factory Dynamic2DView.genRows(
      int numRows, Iterable<dynamic> rowMaker(int index)) {
    final rows = <Dynamic1DView>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Dynamic1DView(v));
    }
    return Dynamic2DView.own(rows);
  }

  factory Dynamic2DView.genCols(
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
    return Dynamic2DView.columns(cols);
  }

  factory Dynamic2DView.gen(Index2D shape, String maker(int row, int col)) {
    final ret = Dynamic2DFix.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret.view;
  }

  static Dynamic2DView buildRows<T>(
      Iterable<T> iterable, Iterable<dynamic> rowMaker(T v)) {
    final rows = <Dynamic1DView>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Dynamic1DView(v));
    }
    return Dynamic2DView.own(rows);
  }

  static Dynamic2DView buildCols<T>(
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
    return Dynamic2DView.columns(cols);
  }

  static Dynamic2DView build<T>(Iterable<Iterable<T>> data, String maker(T v)) {
    if (data.length == 0) {
      return Dynamic2DView.sized(0, 0);
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
    return ret.view;
  }

  Iterator<Dynamic1DView> get iterator => _data.iterator;

  covariant Dynamic2DColView _col;

  Dynamic2DColView get col => _col ??= Dynamic2DColView(this);

  covariant Dynamic2DRowView _row;

  Dynamic2DRowView get row => _row ??= Dynamic2DRowView(this);

  @override
  Iterable<ArrayView<dynamic>> get rows => _data;

  @override
  Iterable<ArrayView<dynamic>> get cols => ColsListView<dynamic>(this);

  Dynamic2DView get view => this;
}
