part of grizzly.series.array2d;

class Double2DView extends Object
    with Double2DViewMixin, Array2DViewMixin<double>
    implements Numeric2DView<double> {
  final List<Double1DView> _data;

  Double2DView(Iterable<Iterable<double>> data) : _data = <Double1DFix>[] {
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

  Double2DView.from(Iterable<IterView<double>> data)
      : _data = new List<Double1DView>(data.length) {
    if (data.length != 0) {
      final int len = data.first.length;
      for (IterView item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        IterView<double> item = data.elementAt(i);
        _data[i] = new Double1DView.copy(item);
      }
    }
  }

  Double2DView.copy(Array2DView<double> data)
      : _data = new List<Double1DView>(data.numRows) {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = new Double1DView.copy(data[i]);
    }
  }

  Double2DView.own(this._data) {
    // TODO check that all rows are of same length
  }

  Double2DView.sized(int numRows, int numCols, {double data: 0.0})
      : _data = new List<Double1DFix>.generate(
            numRows, (_) => new Double1D.sized(numCols, data: data),
            growable: false);

  Double2DView.shaped(Index2D shape, {double data: 0.0})
      : _data = new List<Double1DFix>.generate(
            shape.row, (_) => new Double1D.sized(shape.col, data: data),
            growable: false);

  factory Double2DView.shapedLike(Array2DView like, {double data: 0.0}) =>
      new Double2DView.sized(like.numRows, like.numCols, data: data);

  factory Double2DView.diagonal(Iterable<double> diagonal) {
    final ret = new List<Double1DView>(diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      final row = new List<double>.filled(diagonal.length, 0.0);
      row[i] = diagonal.elementAt(i);
      ret[i] = new Double1DView.own(row);
    }
    return new Double2DView.own(ret);
  }

  Double2DView.fromNum(Iterable<Iterable<num>> data)
      : _data = new List<Double1DView>(data.length) {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<num> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        Iterable<num> item = data.elementAt(i);
        _data[i] = new Double1DView.fromNum(item);
      }
    }
  }

  Double2DView.repeatRow(IterView<double> row, [int numRows = 1])
      : _data = new List<Double1DView>(numRows) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Double1DView.copy(row);
    }
  }

  Double2DView.repeatCol(IterView<double> column, [int numCols = 1])
      : _data = new List<Double1DView>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Double1DView.sized(numCols, data: column[i]);
    }
  }

  Double2DView.aRow(IterView<double> row) : _data = new List<Double1DFix>(1) {
    _data[0] = new Double1DView.copy(row);
  }

  Double2DView.aCol(IterView<double> column)
      : _data = new List<Double1DView>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Double1DView.single(column[i]);
    }
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
    return new Double2DView.own(rows);
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
    return new Double2DView.own(rows);
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

  @override
  Iterable<ArrayView<double>> get rows => _data;

  @override
  Iterable<ArrayView<double>> get cols => new ColsListView<double>(this);
}
