part of grizzly.series.array2d;

class Double2DView extends Object
    with Double2DMixin, Array2DViewMixin<double>
    implements Numeric2DView<double> {
  final List<Double1DView> _data;

  Double2DView(Iterable<Iterable<double>> data) : _data = <Double1D>[] {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<double> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (Iterable<double> item in data) {
        _data.add(new Double1D(item));
      }
    }
  }

  Double2DView.make(this._data);

  Double2DView.sized(int numRows, int numCols, {double data: 0.0})
      : _data = new List<Double1D>.generate(
            numRows, (_) => new Double1D.sized(numCols, data: data));

  Double2DView.shaped(Index2D shape, {double data: 0.0})
      : _data = new List<Double1D>.generate(
            shape.row, (_) => new Double1D.sized(shape.col, data: data));

  factory Double2DView.shapedLike(Array2DView like, {double data: 0.0}) =>
      new Double2DView.sized(like.numRows, like.numCols, data: data);

  factory Double2DView.diagonal(Iterable<double> diagonal) {
    final ret = new Double2DFix.sized(diagonal.length, diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      ret[i][i] = diagonal.elementAt(i);
    }
    return ret.view;
  }

  Double2DView.fromNum(Iterable<Iterable<num>> data) : _data = <Double1D>[] {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<num> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (Iterable<num> item in data) {
        _data.add(new Double1D.fromNum(item));
      }
    }
  }

  Double2DView.repeatRow(Iterable<double> row, [int numRows = 1])
      : _data = new List<Double1D>(numRows) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Double1D(row);
    }
  }

  Double2DView.repeatCol(Iterable<double> column, [int numCols = 1])
      : _data = new List<Double1D>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Double1D.sized(numCols, data: column.elementAt(i));
    }
  }

  Double2DView.aRow(Iterable<double> row) : _data = new List<Double1D>(1) {
    _data[0] = new Double1D(row);
  }

  Double2DView.aCol(Iterable<double> column)
      : _data = new List<Double1D>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Double1D.single(column.elementAt(i));
    }
  }

  /// Create [Int2D] from column major
  factory Double2DView.columns(Iterable<Iterable<double>> columns) {
    if (columns.length == 0) {
      return new Double2DView.sized(0, 0);
    }

    if (!columns.every((i) => i.length == columns.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Double2DFix.sized(columns.first.length, columns.length);
    for (int c = 0; c < ret.numCols; c++) {
      final Iterator<double> col = columns.elementAt(c).iterator;
      col.moveNext();
      for (int r = 0; r < ret.numRows; r++) {
        ret[r][c] = col.current;
        col.moveNext();
      }
    }
    return ret;
  }

  factory Double2DView.genRows(
      int numRows, Iterable<double> rowMaker(int index)) {
    final rows = <Double1DView>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Double1DView(v));
    }
    return new Double2DView.make(rows);
  }

  factory Double2DView.genCols(
      int numCols, Iterable<double> colMaker(int index)) {
    final List<Iterable<double>> cols = <Iterable<double>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Double2DView.columns(cols);
  }

  factory Double2DView.gen(Index2D shape, double maker(int row, int col)) {
    final ret = new Double2DFix.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret.view;
  }

  static Double2DView buildRows<T>(
      Iterable<T> iterable, Iterable<double> rowMaker(T v)) {
    final rows = <Double1DView>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Double1DView(v));
    }
    return new Double2DView.make(rows);
  }

  static Double2DView buildCols<T>(
      Iterable<T> iterable, Iterable<double> colMaker(T v)) {
    final List<Iterable<double>> cols = <Iterable<double>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Double2DView.columns(cols);
  }

  static Double2DView build<T>(Iterable<Iterable<T>> data, double maker(T v)) {
    if (data.length == 0) {
      return new Double2DView.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Double2DFix.sized(data.length, data.first.length);
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

  Iterator<Numeric1DView<double>> get iterator => _data.iterator;

  covariant Double2DColView _col;

  Double2DColView get col => _col ??= new Double2DColView(this);

  covariant Double2DRowView _row;

  Double2DRowView get row => _row ??= new Double2DRowView(this);

  Double2DView get view => this;

  Double2D addition(/* int | Iterable<int> | Numeric2DArray */ other) =>
      this + other;

  Double2D subtract(/* int | Iterable<int> | Numeric2DArray */ other) =>
      this - other;

  Double2D multiply(/* int | Iterable<int> | Numeric2DArray */ other) =>
      this * other;

  Double2D divide(/* int | Iterable<int> | Numeric2DArray */ other) =>
      this / other;

  Int2D truncDiv(/* int | Iterable<int> | Int2DArray */ other) => this ~/ other;
}
