part of grizzly.series.array2d;

class Dynamic2DView extends Object
    with Dynamic2DMixin, Array2DViewMixin<dynamic>
    implements DynamicArray2DView {
  final List<Dynamic1DView> _data;

  Dynamic2DView(Iterable<Iterable<dynamic>> data) : _data = <Dynamic1DView>[] {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<dynamic> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (Iterable<dynamic> item in data) {
        _data.add(new Dynamic1D(item));
      }
    }
  }

  /// Create [Int2D] from column major
  factory Dynamic2DView.columns(Iterable<Iterable<dynamic>> columns) {
    if (columns.length == 0) {
      return new Dynamic2DView.sized(0, 0);
    }

    if (!columns.every((i) => i.length == columns.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Dynamic2DFix.sized(columns.first.length, columns.length);
    for (int c = 0; c < ret.numCols; c++) {
      final Iterator<dynamic> col = columns.elementAt(c).iterator;
      col.moveNext();
      for (int r = 0; r < ret.numRows; r++) {
        ret[r][c] = col.current;
        col.moveNext();
      }
    }
    return ret.view;
  }

  Dynamic2DView.from(Iterable<IterView<dynamic>> data)
      : _data = new List<Dynamic1DView>(data.length) {
    if (data.length != 0) {
      final int len = data.first.length;
      for (IterView item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        IterView<dynamic> item = data.elementAt(i);
        _data[i] = new Dynamic1DView.copy(item);
      }
    }
  }

  Dynamic2DView.copy(Array2DView<dynamic> data)
      : _data = new List<Dynamic1DView>(data.numRows) {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = new Dynamic1DView.copy(data[i]);
    }
  }

  Dynamic2DView.own(this._data) {
    // TODO check that all rows are of same length
  }

  Dynamic2DView.sized(int numRows, int numCols, {String data: ''})
      : _data = new List<Dynamic1DView>.generate(
            numRows, (_) => new Dynamic1DView.sized(numCols, data: data),
            growable: false);

  Dynamic2DView.shaped(Index2D shape, {String data: ''})
      : _data = new List<Dynamic1DView>.generate(
            shape.row, (_) => new Dynamic1DView.sized(shape.col, data: data),
            growable: false);

  factory Dynamic2DView.shapedLike(Array2DView like, {String data: ''}) =>
      new Dynamic2DView.sized(like.numRows, like.numCols, data: data);

  factory Dynamic2DView.diagonal(Iterable<dynamic> diagonal) {
    final ret = new List<Dynamic1DView>(diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      final row = new List<dynamic>.filled(diagonal.length, '');
      row[i] = diagonal.elementAt(i);
      ret[i] = new Dynamic1DView.own(row);
    }
    return new Dynamic2DView.own(ret);
  }

  Dynamic2DView.repeatRow(IterView<dynamic> row, [int numRows = 1])
      : _data = new List<Dynamic1DView>(numRows) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Dynamic1DView.copy(row);
    }
  }

  Dynamic2DView.repeatCol(IterView<dynamic> column, [int numCols = 1])
      : _data = new List<Dynamic1DView>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Dynamic1DView.sized(numCols, data: column[i]);
    }
  }

  Dynamic2DView.aRow(IterView<dynamic> row)
      : _data = new List<Dynamic1DView>(1) {
    _data[0] = new Dynamic1DView.copy(row);
  }

  Dynamic2DView.aCol(IterView<dynamic> column)
      : _data = new List<Dynamic1DView>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Dynamic1DView.single(column[i]);
    }
  }

  factory Dynamic2DView.genRows(
      int numRows, Iterable<dynamic> rowMaker(int index)) {
    final rows = <Dynamic1DView>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Dynamic1DView(v));
    }
    return new Dynamic2DView.own(rows);
  }

  factory Dynamic2DView.genCols(
      int numCols, Iterable<dynamic> colMaker(int index)) {
    final List<Iterable<dynamic>> cols = <Iterable<dynamic>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Dynamic2DView.columns(cols);
  }

  factory Dynamic2DView.gen(Index2D shape, String maker(int row, int col)) {
    final ret = new Dynamic2DFix.shaped(shape);
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
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Dynamic1DView(v));
    }
    return new Dynamic2DView.own(rows);
  }

  static Dynamic2DView buildCols<T>(
      Iterable<T> iterable, Iterable<dynamic> colMaker(T v)) {
    final List<Iterable<dynamic>> cols = <Iterable<dynamic>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Dynamic2DView.columns(cols);
  }

  static Dynamic2DView build<T>(Iterable<Iterable<T>> data, String maker(T v)) {
    if (data.length == 0) {
      return new Dynamic2DView.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Dynamic2DFix.sized(data.length, data.first.length);
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

  Iterator<ArrayView<dynamic>> get iterator => _data.iterator;

  covariant Dynamic2DColView _col;

  Dynamic2DColView get col => _col ??= new Dynamic2DColView(this);

  covariant Dynamic2DRowView _row;

  Dynamic2DRowView get row => _row ??= new Dynamic2DRowView(this);

  @override
  Iterable<ArrayView<dynamic>> get rows => _data;

  @override
  Iterable<ArrayView<dynamic>> get cols => new ColsListView<dynamic>(this);

  Dynamic2DView get view => this;
}
