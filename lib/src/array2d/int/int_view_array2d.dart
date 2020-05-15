part of grizzly.series.array2d;

class Int2DView extends Object
    with Array2DViewMixin<int>, IterableMixin<Iterable<int>>, Int2DViewMixin
    implements Numeric2DView<int>, Array2DView<int> {
  final List<Int1DView> _data;

  final String1DView names;

  Int2DView(Iterable<Iterable<int>> rows, [Iterable<String> names])
      : _data = List<Int1DView>(rows.length),
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
      _data[i] = Int1DView(rows.elementAt(i));
    }
  }

  Int2DView.own(this._data, [Iterable<String> names])
      : names = names != null
            ? String1DView(names, "Names")
            : String1DView.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory Int2DView.fromNums(Iterable<Iterable<num>> rows,
      [Iterable<String> names]) {
    final data = List<Int1DView>()..length = rows.length;
    for (int i = 0; i < rows.length; i++)
      data[i] = Int1DView.fromNums(rows.elementAt(i));
    return Int2DView.own(data, names);
  }

  factory Int2DView.sized(int numRows, int numCols,
      {int fill: 0, Iterable<String> names}) {
    final data = List<Int1DView>(numRows);
    for (int i = 0; i < numRows; i++) {
      data[i] = Int1DView.sized(numCols, fill: fill);
    }
    return Int2DView.own(data, names);
  }

  factory Int2DView.shaped(Index2D shape,
          {int fill: 0, Iterable<String> names}) =>
      Int2DView.sized(shape.row, shape.col, fill: fill, names: names);

  factory Int2DView.shapedLike(Array2DView like,
          {int fill: 0, Iterable<String> names}) =>
      Int2DView.sized(like.numRows, like.numCols, fill: fill, names: names);

  /// Create [Int2DView] from column major
  factory Int2DView.columns(Iterable<Iterable<int>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return Int2DView.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<Int1DView>(numRows);
    for (int i = 0; i < numRows; i++) {
      final row = List<int>(numCols);
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = Int1DView.own(row);
    }
    return Int2DView.own(data, names);
  }

  factory Int2DView.diagonal(Iterable<int> diagonal,
      {Index2D shape, Iterable<String> names, int fill: 0}) {
    shape ??= Index2D(diagonal.length, diagonal.length);
    final ret = Int2DFix.shaped(shape, fill: fill, names: names);
    int length = math.min(math.min(shape.row, shape.col), diagonal.length);
    for (int i = 0; i < length; i++) {
      ret[i][i] = diagonal.elementAt(i);
    }
    return ret.view;
  }

  factory Int2DView.aRow(Iterable<int> row,
      {int repeat = 1, Iterable<String> names}) {
    final data = List<Int1DView>.filled(repeat, null, growable: true);
    if (row is Iterable<int>) {
      for (int i = 0; i < repeat; i++) data[i] = Int1DView(row);
    } else {
      final temp = Int1DView.fromNums(row);
      data[0] = temp;
      for (int i = 1; i < repeat; i++) data[i] = Int1DView(temp);
    }
    return Int2DView.own(data, names);
  }

  factory Int2DView.aCol(Iterable<int> column,
      {int repeat = 1, Iterable<String> names}) {
    if (column is Iterable<int>) {
      return Int2DView.columns(
          ranger.ConstantIterable<Iterable<int>>(column, repeat), names);
    }
    return Int2DView.columns(
        ranger.ConstantIterable<Iterable<int>>(Int1DView.fromNums(column), repeat),
        names);
  }

  factory Int2DView.genRows(int numRows, Iterable<int> rowMaker(int index),
      {Iterable<String> names}) {
    final rows = <Int1DView>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Int1DView(v));
    }
    return Int2DView.own(rows, names);
  }

  factory Int2DView.genCols(int numCols, Iterable<int> colMaker(int index),
      {Iterable<String> names}) {
    final List<Iterable<int>> cols = <Iterable<int>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Int2DView.columns(cols, names);
  }

  factory Int2DView.gen(Index2D shape, int colMaker(int row, int col),
      {Iterable<String> names}) {
    final ret = Int2D.shaped(shape, names: names);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = colMaker(r, c);
      }
    }
    return ret.view;
  }

  static Int2DView buildRows<T>(
      Iterable<T> iterable, Iterable<int> rowMaker(T v),
      {Iterable<String> names}) {
    final rows = <Int1DView>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Int1DView(v));
    }
    return Int2DView.own(rows, names);
  }

  static Int2DView buildCols<T>(
      Iterable<T> iterable, Iterable<int> colMaker(T v),
      {Iterable<String> names}) {
    final List<Iterable<int>> cols = <Iterable<int>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Int2DView.columns(cols, names);
  }

  static Int2DView build<T>(Iterable<Iterable<T>> data, int maker(T v),
      {Iterable<String> names}) {
    if (data.length == 0) {
      return Int2DView.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw Exception('Size mismatch!');
    }

    final ret = Int2D.sized(data.length, data.first.length, names: names);
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

  Iterator<Int1DView> get iterator => _data.iterator;

  Int2DColView _col;

  Int2DColView get col => _col ??= Int2DColView(this);

  Int2DRowView _row;

  Int2DRowView get row => _row ??= Int2DRowView(this);

  Int2DView get view => this;

  @override
  Iterable<ArrayView<int>> get rows => _data;

  @override
  Iterable<ArrayView<int>> get cols => ColsListView<int>(this);

  Int1D unique() => super.unique();
}
