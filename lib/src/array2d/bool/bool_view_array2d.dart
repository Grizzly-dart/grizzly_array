part of grizzly.series.array2d;

class Bool2DView extends Object
    with Bool2DViewMixin, Array2DViewMixin<bool>
    implements BoolArray2DView {
  final List<Bool1DView> _data;

  Bool2DView(Iterable<Iterable<bool>> data) : _data = <Bool1DView>[] {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<bool> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (Iterable<bool> item in data) {
        _data.add(new Bool1DView(item));
      }
    }
  }

  /// Create [Int2D] from column major
  factory Bool2DView.columns(Iterable<Iterable<bool>> columns) {
    if (columns.length == 0) {
      return new Bool2DView.sized(0, 0);
    }

    if (!columns.every((i) => i.length == columns.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Bool2DFix.sized(columns.first.length, columns.length);
    for (int c = 0; c < ret.numCols; c++) {
      final Iterator<bool> col = columns.elementAt(c).iterator;
      col.moveNext();
      for (int r = 0; r < ret.numRows; r++) {
        ret[r][c] = col.current;
        col.moveNext();
      }
    }
    return ret.view;
  }

  Bool2DView.from(Iterable<IterView<bool>> data)
      : _data = new List<Bool1DView>(data.length) {
    if (data.length != 0) {
      final int len = data.first.length;
      for (IterView item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        IterView<bool> item = data.elementAt(i);
        _data[i] = new Bool1DView.copy(item);
      }
    }
  }

  Bool2DView.copy(Array2DView<bool> data)
      : _data = new List<Bool1DView>(data.numRows) {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = new Bool1DView.copy(data[i]);
    }
  }

  Bool2DView.own(this._data) {
    // TODO check that all rows are of same length
  }

  Bool2DView.sized(int numRows, int numCols, {bool data: false})
      : _data = new List<Bool1DView>.generate(
            numRows, (_) => new Bool1DView.sized(numCols, data: data),
            growable: false);

  Bool2DView.shaped(Index2D shape, {bool data: false})
      : _data = new List<Bool1DView>.generate(
            shape.row, (_) => new Bool1DView.sized(shape.col, data: data),
            growable: false);

  factory Bool2DView.shapedLike(Array2DView like, {bool data: false}) =>
      new Bool2DView.sized(like.numRows, like.numCols, data: data);

  factory Bool2DView.diagonal(IterView<bool> diagonal) {
    final ret = new List<Bool1DView>(diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      final row = new List<bool>.filled(diagonal.length, false);
      row[i] = diagonal[i];
      ret[i] = new Bool1DView.own(row);
    }
    return new Bool2DView.own(ret);
  }

  Bool2DView.repeatRow(IterView<bool> row, [int numRows = 1])
      : _data = new List<Bool1DView>(numRows) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Bool1DView.copy(row);
    }
  }

  Bool2DView.repeatCol(IterView<bool> column, [int numCols = 1])
      : _data = new List<Bool1DView>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Bool1DView.sized(numCols, data: column[i]);
    }
  }

  Bool2DView.aRow(IterView<bool> row) : _data = new List<Bool1DView>(1) {
    _data[0] = new Bool1DView.copy(row);
  }

  Bool2DView.aCol(IterView<bool> column)
      : _data = new List<Bool1DView>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Bool1DView.single(column[i]);
    }
  }

  factory Bool2DView.genRows(int numRows, Iterable<bool> rowMaker(int index)) {
    final rows = <Bool1DView>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Bool1DView(v));
    }
    return new Bool2DView.own(rows);
  }

  factory Bool2DView.genCols(int numCols, Iterable<bool> colMaker(int index)) {
    final List<Iterable<bool>> cols = <Iterable<bool>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Bool2DView.columns(cols);
  }

  factory Bool2DView.gen(Index2D shape, bool maker(int row, int col)) {
    final ret = new Bool2DFix.shaped(shape);
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
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Bool1DView(v));
    }
    return new Bool2DView.own(rows);
  }

  static Bool2DView buildCols<T>(
      Iterable<T> iterable, Iterable<bool> colMaker(T v)) {
    final List<Iterable<bool>> cols = <Iterable<bool>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Bool2DView.columns(cols);
  }

  static Bool2DView build<T>(Iterable<Iterable<T>> data, bool maker(T v)) {
    if (data.length == 0) {
      return new Bool2DView.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Bool2DFix.sized(data.length, data.first.length);
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

  covariant Bool2DColView _col;

  Bool2DColView get col => _col ??= new Bool2DColView(this);

  covariant Bool2DRowView _row;

  Bool2DRowView get row => _row ??= new Bool2DRowView(this);

  Bool2DView get view => this;

  @override
  Iterable<ArrayView<bool>> get rows => _data;

  @override
  Iterable<ArrayView<bool>> get cols => new ColsListView<bool>(this);
}
