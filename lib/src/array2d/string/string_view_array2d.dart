part of grizzly.series.array2d;

class String2DView extends Object
    with String2DMixin, Array2DViewMixin<String>
    implements Array2DView<String> {
  final List<String1DView> _data;

  String2DView(Iterable<Iterable<String>> data) : _data = <String1DView>[] {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<String> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (Iterable<String> item in data) {
        _data.add(new String1D(item));
      }
    }
  }

  /// Create [Int2D] from column major
  factory String2DView.columns(Iterable<Iterable<String>> columns) {
    if (columns.length == 0) {
      return new String2DView.sized(0, 0);
    }

    if (!columns.every((i) => i.length == columns.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new String2DFix.sized(columns.first.length, columns.length);
    for (int c = 0; c < ret.numCols; c++) {
      final Iterator<String> col = columns.elementAt(c).iterator;
      col.moveNext();
      for (int r = 0; r < ret.numRows; r++) {
        ret[r][c] = col.current;
        col.moveNext();
      }
    }
    return ret.view;
  }

  String2DView.from(Iterable<IterView<String>> data)
      : _data = new List<String1DView>(data.length) {
    if (data.length != 0) {
      final int len = data.first.length;
      for (IterView item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        IterView<String> item = data.elementAt(i);
        _data[i] = new String1DView.copy(item);
      }
    }
  }

  String2DView.copy(Array2DView<String> data)
      : _data = new List<String1DView>(data.numRows) {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = new String1DView.copy(data[i]);
    }
  }

  String2DView.own(this._data) {
    // TODO check that all rows are of same length
  }

  String2DView.sized(int numRows, int numCols, {String data: ''})
      : _data = new List<String1DView>.generate(
            numRows, (_) => new String1DView.sized(numCols, data: data),
            growable: false);

  String2DView.shaped(Index2D shape, {String data: ''})
      : _data = new List<String1DView>.generate(
            shape.row, (_) => new String1DView.sized(shape.col, data: data),
            growable: false);

  factory String2DView.shapedLike(Array2DView like, {String data: ''}) =>
      new String2DView.sized(like.numRows, like.numCols, data: data);

  factory String2DView.diagonal(Iterable<String> diagonal) {
    final ret = new List<String1DView>(diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      final row = new List<String>.filled(diagonal.length, '');
      row[i] = diagonal.elementAt(i);
      ret[i] = new String1DView.own(row);
    }
    return new String2DView.own(ret);
  }

  String2DView.repeatRow(IterView<String> row, [int numRows = 1])
      : _data = new List<String1DView>(numRows) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new String1DView.copy(row);
    }
  }

  String2DView.repeatCol(IterView<String> column, [int numCols = 1])
      : _data = new List<String1DView>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new String1DView.sized(numCols, data: column[i]);
    }
  }

  String2DView.aRow(IterView<String> row) : _data = new List<String1DView>(1) {
    _data[0] = new String1DView.copy(row);
  }

  String2DView.aCol(IterView<String> column)
      : _data = new List<String1DView>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new String1DView.single(column[i]);
    }
  }

  factory String2DView.genRows(
      int numRows, Iterable<String> rowMaker(int index)) {
    final rows = <String1DView>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new String1DView(v));
    }
    return new String2DView.own(rows);
  }

  factory String2DView.genCols(
      int numCols, Iterable<String> colMaker(int index)) {
    final List<Iterable<String>> cols = <Iterable<String>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new String2DView.columns(cols);
  }

  factory String2DView.gen(Index2D shape, String maker(int row, int col)) {
    final ret = new String2DFix.shaped(shape);
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
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new String1DView(v));
    }
    return new String2DView.own(rows);
  }

  static String2DView buildCols<T>(
      Iterable<T> iterable, Iterable<String> colMaker(T v)) {
    final List<Iterable<String>> cols = <Iterable<String>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new String2DView.columns(cols);
  }

  static String2DView build<T>(Iterable<Iterable<T>> data, String maker(T v)) {
    if (data.length == 0) {
      return new String2DView.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new String2DFix.sized(data.length, data.first.length);
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

  covariant String2DColView _col;

  String2DColView get col => _col ??= new String2DColView(this);

  covariant String2DRowView _row;

  String2DRowView get row => _row ??= new String2DRowView(this);

  @override
  Iterable<ArrayView<String>> get rows => _data;

  @override
  Iterable<ArrayView<String>> get cols => new ColsListView<String>(this);

  String2DView get view => this;
}
