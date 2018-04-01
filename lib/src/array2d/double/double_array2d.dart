part of grizzly.series.array2d;

class Double2D extends Object
    with
        Array2DViewMixin<double>,
        Array2DFixMixin<double>,
        Double2DViewMixin,
        Double2DFixMixin
    implements Numeric2D<double>, Double2DFix {
  final List<Double1D> _data;

  Double2D(Iterable<Iterable<double>> data) : _data = <Double1D>[] {
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
  factory Double2D.columns(Iterable<Iterable<double>> columns) {
    if (columns.length == 0) {
      return new Double2D.sized(0, 0);
    }

    if (!columns.every((i) => i.length == columns.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Double2D.sized(columns.first.length, columns.length);
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

  Double2D.from(Iterable<IterView<double>> data)
      : _data = new List<Double1D>()..length = data.length {
    if (data.length != 0) {
      final int len = data.first.length;
      for (IterView item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        IterView<double> item = data.elementAt(i);
        _data[i] = new Double1D.copy(item);
      }
    }
  }

  Double2D.copy(Array2DView<double> data)
      : _data = new List<Double1D>()..length = data.numRows {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = data[i].clone();
    }
  }

  Double2D.own(this._data) {
    // TODO check that all rows are of same length
  }

  Double2D.sized(int numRows, int numCols, {double data: 0.0})
      : _data = new List<Double1D>.generate(
            numRows, (_) => new Double1D.sized(numCols, data: data));

  Double2D.shaped(Index2D shape, {double data: 0.0})
      : _data = new List<Double1D>.generate(
            shape.row, (_) => new Double1D.sized(shape.col, data: data));

  factory Double2D.shapedLike(Array2DView like, {double data: 0.0}) =>
      new Double2D.sized(like.numRows, like.numCols, data: data);

  factory Double2D.diagonal(/* IterView<num> | Iterable<num> */ diagonal,
      {Index2D shape, double def: 0.0}) {
    if (diagonal is IterView<double>) {
      diagonal = diagonal.asIterable;
    } else if (diagonal is IterView<num>) {
      diagonal = diagonal.asIterable;
    }
    if (diagonal is Iterable<double>) {
      if (shape == null) shape = new Index2D(diagonal.length, diagonal.length);

      final ret = new Double2D.shaped(shape);
      int min = math.min(math.min(diagonal.length, shape.row), shape.col);
      for (int i = 0; i < min; i++) {
        ret[i][i] = diagonal.elementAt(i);
      }
      int max = math.min(shape.row, shape.col);
      if (def != 0) for (int i = min; i < max; i++) ret[i][i] = def;
      return ret;
    } else if (diagonal is Iterable<num>) {
      if (shape == null) shape = new Index2D(diagonal.length, diagonal.length);

      final ret = new Double2D.shaped(shape);
      int min = math.min(math.min(diagonal.length, shape.row), shape.col);
      for (int i = 0; i < min; i++) {
        ret[i][i] = diagonal.elementAt(i)?.toDouble();
      }
      int max = math.min(shape.row, shape.col);
      if (def != 0) for (int i = min; i < max; i++) ret[i][i] = def;
      return ret;
    }
    throw new UnsupportedError('Type');
  }

  Double2D.fromNum(data) : _data = <Double1D>[] {
    // TODO handle IterView<IterView<num>>
    // TODO handle IterView<IterView<String>>
    if (data is Iterable<Iterable<num>>) {
      if (data.length != 0) {
        final int len = data.first.length;
        for (dynamic item in data) {
          if (item.length != len) {
            throw new Exception('All rows must have same number of columns!');
          }
        }

        for (Iterable<num> item in data) {
          _data.add(new Double1D.nums(item));
        }
      }
    } else if (data is Iterable<IterView<num>>) {
      if (data.length != 0) {
        final int len = data.first.length;
        for (dynamic item in data) {
          if (item.length != len) {
            throw new Exception('All rows must have same number of columns!');
          }
        }

        for (IterView<num> item in data) {
          _data.add(new Double1D.copyNums(item));
        }
      }
    } else if (data is Array2DView<num>) {
      for (ArrayView<num> item in data.rows) {
        _data.add(new Double1D.copyNums(item));
      }
    } else {
      throw new UnsupportedError('Type');
    }
  }

  Double2D.repeatRow(/* IterView<num> | Iterable<num> */ row, [int numRows = 1])
      : _data = new List<Double1D>()..length = numRows {
    if (row is IterView<double>) {
      row = row.asIterable;
    }
    if (row is Iterable<double>) {
      for (int i = 0; i < numRows; i++) {
        _data[i] = new Double1D(row);
      }
    } else if (row is Iterable<num> || row is IterView<num>) {
      for (int i = 0; i < numRows; i++) {
        _data[i] = new Double1D.nums(row);
      }
    } else {
      throw new UnsupportedError('Type');
    }
  }

  Double2D.repeatCol(/* IterView<num> | Iterable<num> */ column,
      [int numCols = 1])
      : _data = new List<Double1D>()..length = column.length {
    if (column is IterView<double>) {
      column = column.asIterable;
    }
    if (column is Iterable<double>) {
      for (int i = 0; i < numRows; i++) {
        _data[i] = new Double1D.sized(numCols, data: column.elementAt(i));
      }
    } else if (column is IterView<num>) {
      for (int i = 0; i < numRows; i++) {
        _data[i] = new Double1D.sized(numCols, data: column[i]?.toDouble());
      }
    } else if (column is Iterable<num>) {
      for (int i = 0; i < numRows; i++) {
        _data[i] =
            new Double1D.sized(numCols, data: column.elementAt(i)?.toDouble());
      }
    } else {
      throw new UnsupportedError('Type');
    }
  }

  Double2D.aRow(/* IterView<num> | Iterable<num> */ row)
      : _data = new List<Double1D>()..length = 1 {
    if (row is IterView<double>) {
      _data[0] = new Double1D.copy(row);
    } else if (row is Iterable<double>) {
      _data[0] = new Double1D(row);
    } else if (row is Iterable<num> || row is IterView<num>) {
      _data[0] = new Double1D.nums(row);
    } else {
      throw new UnsupportedError('Type');
    }
  }

  Double2D.aCol(/* IterView<num> | Iterable<num> */ column)
      : _data = new List<Double1D>()..length = column.length {
    if (column is IterView<double>) {
      for (int i = 0; i < numRows; i++) {
        _data[i] = new Double1D.single(column[i]);
      }
    } else if (column is Iterable<double>) {
      for (int i = 0; i < numRows; i++) {
        _data[i] = new Double1D.single(column.elementAt(i));
      }
    } else if (column is Iterable<num>) {
      for (int i = 0; i < numRows; i++) {
        _data[i] = new Double1D.single(column.elementAt(i)?.toDouble());
      }
    } else if (column is IterView<num>) {
      for (int i = 0; i < numRows; i++) {
        _data[i] = new Double1D.single(column[i]?.toDouble());
      }
    } else {
      throw new UnsupportedError('Type');
    }
  }

  factory Double2D.genRows(int numRows, Iterable<double> rowMaker(int index)) {
    final rows = <Double1D>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Double1D(v));
    }
    return new Double2D.own(rows);
  }

  factory Double2D.genCols(int numCols, Iterable<double> colMaker(int index)) {
    final List<Iterable<double>> cols = <Iterable<double>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Double2D.columns(cols);
  }

  factory Double2D.gen(Index2D shape, double maker(int row, int col)) {
    final ret = new Double2D.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret;
  }

  static Double2D buildRows<T>(
      Iterable<T> iterable, Iterable<double> rowMaker(T v)) {
    final rows = <Double1D>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Double1D(v));
    }
    return new Double2D.own(rows);
  }

  static Double2D buildCols<T>(
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
    return new Double2D.columns(cols);
  }

  static Double2D build<T>(Iterable<Iterable<T>> data, double maker(T v)) {
    if (data.length == 0) {
      return new Double2D.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Double2D.sized(data.length, data.first.length);
    for (int r = 0; r < ret.numRows; r++) {
      final Iterator<T> row = data.elementAt(r).iterator;
      row.moveNext();
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(row.current);
        row.moveNext();
      }
    }
    return ret;
  }

  covariant Double2DCol _col;

  Double2DCol get col => _col ??= new Double2DCol(this);

  covariant Double2DRow _row;

  Double2DRow get row => _row ??= new Double2DRow(this);

  Double1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, final IterView<double> val) {
    if (i > numRows) {
      throw new RangeError.range(i, 0, numRows - 1, 'i', 'Out of range!');
    }

    if (numRows == 0) {
      final arr = new Double1D.copy(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) {
      throw new Exception('Invalid size!');
    }

    final arr = new Double1D.copy(val);

    if (i == numRows) {
      _data.add(arr);
      return;
    }

    _data[i] = arr;
  }

  /// Sets all elements in the array to given value [v]
  void set(double v) {
    for (int c = 0; c < numRows; c++) {
      for (int r = 0; r < numCols; r++) {
        _data[c][r] = v;
      }
    }
  }

  @override
  void assign(Array2DView<double> other) {
    if (other.shape != shape)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = other[r][c];
      }
    }
  }

  @override
  void add(IterView<double> row) => this[numRows] = row;

  @override
  void addScalar(double v) => _data.add(new Double1D.sized(numCols, data: v));

  @override
  void insert(int index, IterView<double> row) {
    if (index > numRows) throw new RangeError.range(index, 0, numRows);
    if (row.length != numCols) throw new ArgumentError.value(row, 'row');
    _data.insert(index, new Double1D.copy(row));
  }

  void clip({double min, double max}) {
    if (numRows == 0) return;

    if (min != null && max != null) {
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < _data.first.length; j++) {
          final double d = _data[i][j];
          if (d < min) _data[i][j] = min;
          if (d > max) _data[i][j] = max;
        }
      }
      return;
    }
    if (min != null) {
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < _data.first.length; j++) {
          final double d = _data[i][j];
          if (d < min) _data[i][j] = min;
        }
      }
      return;
    }
    if (max != null) {
      for (int j = 0; j < _data.first.length; j++) {
        for (int i = 0; i < numRows; i++) {
          final double d = _data[i][j];
          if (d > max) _data[i][j] = max;
        }
      }
      return;
    }
  }

  Double2D get logSelf {
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) _data[r][c] = math.log(_data[r][c]);
    }
    return this;
  }

  Double2D get log10Self {
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++)
        _data[r][c] = math.log(_data[r][c]) / math.ln10;
    }
    return this;
  }

  Double2D logNSelf(double n) {
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++)
        _data[r][c] = math.log(_data[r][c]) / math.log(n);
    }
    return this;
  }

  Double2D expSelf() {
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) _data[r][c] = math.exp(_data[r][c]);
    }
    return this;
  }

  Double2DView _view;

  Double2DView get view => _view ??= new Double2DView.own(_data);

  Double2DFix _fixed;

  Double2DFix get fixed => _fixed ??= new Double2DFix.own(_data);

  @override
  Iterable<ArrayFix<double>> get rows => _data;

  @override
  Iterable<ArrayFix<double>> get cols => new ColsListFix<double>(this);

  void reshape(Index2D newShape, {double def: 0.0}) {
    if (shape == newShape) return;

    if (shape.row > newShape.row) {
      _data.removeRange(newShape.row, shape.row);
    } else {
      for (int i = shape.row; i < newShape.row; i++) {
        _data.add(new Double1D.sized(newShape.col, data: def));
      }
    }

    if (shape.col > newShape.col) {
      for (Double1D r in _data) {
        r.removeRange(newShape.col, r.length);
      }
    } else {
      for (Double1D r in _data) {
        r.addAll(new Double1D.sized(newShape.col - r.length, data: def));
      }
    }
  }

  Double1D unique() => super.unique();
}
