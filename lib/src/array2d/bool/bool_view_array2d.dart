part of grizzly.series.array2d;

class Exceptions {
  static void labelLen(int data, int labels) {
    if (data != labels)
      throw Exception(
          "Labels have length $labels. But data have length $data.");
  }

  static void columnsLen(Iterable<Iterable> columns) {
    if (columns.isEmpty) return;
    int size = columns.first.length;

    for (int i = 1; i < columns.length; i++) {
      int curSize = columns.elementAt(i).length;
      if (size != curSize)
        throw Exception("Column $i has length $curSize. $size expected!");
    }
  }

  static void rowsLen(Iterable<Iterable> rows) {
    if (rows.isEmpty) return;
    int size = rows.first.length;

    for (int i = 1; i < rows.length; i++) {
      int curSize = rows.elementAt(i).length;
      if (size != curSize)
        throw Exception("Row $i has length $curSize. $size expected!");
    }
  }
}

class Bool2DView extends Object
    with Array2DViewMixin<bool>, IterableMixin<Iterable<bool>>, Bool2DViewMixin
    implements BoolArray2DView {
  final List<Bool1DView> _data;

  final String1DView names;

  Bool2DView(Iterable<Iterable<bool>> rows, [Iterable<String> names])
      : _data = List<Bool1DView>(rows.length),
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
      _data[i] = Bool1DView(rows.elementAt(i));
    }
  }

  Bool2DView.own(this._data, [Iterable<String> names])
      : names = names != null
            ? String1DView(names, "Names")
            : String1DView.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory Bool2DView.sized(int numRows, int numCols,
      {bool fill: false, Iterable<String> names}) {
    final data = List<Bool1DView>(numRows);
    for (int i = 0; i < numRows; i++) {
      data[i] = Bool1DView.sized(numCols, fill: fill);
    }
    return Bool2DView.own(data, names);
  }

  factory Bool2DView.shaped(Index2D shape,
          {bool fill: false, Iterable<String> names}) =>
      Bool2DView.sized(shape.row, shape.col, fill: fill, names: names);

  factory Bool2DView.shapedLike(Array2DView like,
          {bool fill: false, Iterable<String> names}) =>
      Bool2DView.sized(like.numRows, like.numCols, fill: fill, names: names);

  /// Create [Bool2DView] from column major
  factory Bool2DView.columns(Iterable<Iterable<bool>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return Bool2DView.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<Bool1DView>(numRows);
    for (int i = 0; i < numRows; i++) {
      final row = List<bool>(numCols);
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = Bool1DView.own(row);
    }
    return Bool2DView.own(data, names);
  }

  factory Bool2DView.diagonal(Iterable<bool> diagonal,
      {Iterable<String> names, bool fill: false}) {
    final ret = List<Bool1DView>(diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      final row = List<bool>.filled(diagonal.length, fill);
      row[i] = diagonal.elementAt(i);
      ret[i] = Bool1DView.own(row);
    }
    return Bool2DView.own(ret, names);
  }

  factory Bool2DView.aRow(Iterable<bool> row,
          {int repeat = 1, Iterable<String> names}) =>
      Bool2DView.own(List<Bool1DView>.filled(repeat, Bool1DView(row)), names);

  factory Bool2DView.repeatCol(Iterable<bool> column,
          {int repeat = 1, Iterable<String> names}) =>
      Bool2DView.columns(
          ranger.ConstantIterable<Iterable<bool>>(column, repeat), names);

  factory Bool2DView.genRows(int numRows, Iterable<bool> rowMaker(int index)) {
    final rows = <Bool1DView>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Bool1DView(v));
    }
    return Bool2DView.own(rows);
  }

  factory Bool2DView.genCols(int numCols, Iterable<bool> colMaker(int index)) {
    final List<Iterable<bool>> cols = <Iterable<bool>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Bool2DView.columns(cols);
  }

  factory Bool2DView.gen(Index2D shape, bool maker(int row, int col)) {
    final ret = Bool2DFix.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret.view;
  }

  static Bool2DView buildRows<T>(
      Iterable<T> iterable, Iterable<bool> rowMaker(T v)) {
    final rows = <Bool1DView>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Bool1DView(v));
    }
    return Bool2DView.own(rows);
  }

  static Bool2DView buildCols<T>(
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
    return Bool2DView.columns(cols);
  }

  static Bool2DView build<T>(Iterable<Iterable<T>> data, bool maker(T v)) {
    if (data.length == 0) {
      return Bool2DView.sized(0, 0);
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
    return ret.view;
  }

  Iterator<Bool1DView> get iterator => _data.iterator;

  Bool1DView operator [](int i) => _data[i].view;

  covariant Bool2DColView _col;

  Bool2DColView get col => _col ??= Bool2DColView(this);

  covariant Bool2DRowView _row;

  Bool2DRowView get row => _row ??= Bool2DRowView(this);

  Bool2DView get view => this;

  @override
  Iterable<ArrayView<bool>> get rows => _data;

  @override
  Iterable<ArrayView<bool>> get cols => ColsListView<bool>(this);
}
