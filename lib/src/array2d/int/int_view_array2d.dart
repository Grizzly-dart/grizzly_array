part of grizzly.series.array2d;

class Int2DView extends Object
    with Int2DMixin, Array2DViewMixin<int>
    implements Numeric2DView<int>, Array2DView<int> {
  final List<Int1DView> _data;

  Int2DView(Iterable<Iterable<int>> data) : _data = <Int1D>[] {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<int> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (Iterable<int> item in data) {
        _data.add(new Int1D(item));
      }
    }
  }

  Int2DView.make(this._data);

  Int2DView.sized(int rows, int columns, {int data: 0})
      : _data = new List<Int1D>.generate(rows, (_) => new Int1D.sized(columns),
            growable: false);

  Int2DView.shaped(Index2D shape, {int data: 0})
      : _data = new List<Int1D>.generate(
            shape.row, (_) => new Int1D.sized(shape.col, data: data),
            growable: false);

  factory Int2DView.shapedLike(Array2DView like, {int data: 0}) =>
      new Int2DView.sized(like.numRows, like.numCols, data: data);

  Int2DView.repeatRow(Iterable<int> row, [int numRows = 1])
      : _data = new List<Int1D>(numRows) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Int1D(row);
    }
  }

  Int2DView.repeatCol(Iterable<int> column, [int numCols = 1])
      : _data = new List<Int1D>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Int1D.sized(numCols, data: column.elementAt(i));
    }
  }

  Int2DView.aRow(Iterable<int> row) : _data = new List<Int1D>(1) {
    _data[0] = new Int1D(row);
  }

  Int2DView.aCol(Iterable<int> column)
      : _data = new List<Int1D>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Int1D.single(column.elementAt(i));
    }
  }

  /// Create [Int2D] from column major
  factory Int2DView.columns(Iterable<Iterable<int>> columns) {
    if (columns.length == 0) {
      return new Int2DView.sized(0, 0);
    }

    if (!columns.every((i) => i.length == columns.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Int2D.sized(columns.first.length, columns.length);
    for (int c = 0; c < ret.numCols; c++) {
      final Iterator<int> col = columns.elementAt(c).iterator;
      col.moveNext();
      for (int r = 0; r < ret.numRows; r++) {
        ret[r][c] = col.current;
        col.moveNext();
      }
    }
    return ret.view;
  }

  factory Int2DView.genRows(int numRows, Iterable<int> rowMaker(int index)) {
    final rows = <Int1DView>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Int1DView(v));
    }
    return new Int2DView.make(rows);
  }

  factory Int2DView.genCols(int numCols, Iterable<int> colMaker(int index)) {
    final List<Iterable<int>> cols = <Iterable<int>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Int2DView.columns(cols);
  }

  factory Int2DView.gen(Index2D shape, int colMaker(int row, int col)) {
    final ret = new Int2D.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = colMaker(r, c);
      }
    }
    return ret.view;
  }

  static Int2DView buildRows<T>(
      Iterable<T> iterable, Iterable<int> rowMaker(T v)) {
    final rows = <Int1DView>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Int1DView(v));
    }
    return new Int2DView.make(rows);
  }

  static Int2DView buildCols<T>(
      Iterable<T> iterable, Iterable<int> colMaker(T v)) {
    final List<Iterable<int>> cols = <Iterable<int>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Int2DView.columns(cols);
  }

  static Int2DView build<T>(Iterable<Iterable<T>> data, int colMaker(T v)) {
    if (data.length == 0) {
      return new Int2DView.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Int2D.sized(data.length, data.first.length);
    for (int r = 0; r < ret.numRows; r++) {
      final Iterator<T> row = data.elementAt(r).iterator;
      row.moveNext();
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = colMaker(row.current);
        row.moveNext();
      }
    }
    return ret.view;
  }

  Int2DColView _col;

  Int2DColView get col => _col ??= new Int2DColView(this);

  Int2DRowView _row;

  Int2DRowView get row => _row ??= new Int2DRowView(this);

  Int2DView get view => this;

  @override
  Iterable<ArrayView<int>> get rows => _data;

  @override
  Iterable<ArrayView<int>> get cols => new ColsListView<int>(this);

  Int2D addition(/* int | Iterable<int> | Int2DArray */ other) => this + other;

  Int2D subtract(/* int | Iterable<int> | Int2DArray */ other) => this - other;

  Int2D multiply(/* int | Iterable<int> | Int2DArray */ other) => this * other;

  Double2D divide(/* int | Iterable<int> | Int2DArray */ other) => this / other;

  Int2D truncDiv(/* int | Iterable<int> | Int2DArray */ other) => this ~/ other;
}
