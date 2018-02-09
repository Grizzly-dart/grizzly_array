part of grizzly.series.array2d;

class Double2D extends Object
    with Double2DMixin, Array2DViewMixin<double>
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

  Double2D.from(Iterable<ArrayView<double>> data)
      : _data = new List<Double1D>()..length = data.length {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Double1DView item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        Double1DView item = data.elementAt(i);
        _data[i] = item.clone();
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

  factory Double2D.diagonal(IterView<double> diagonal) {
    final ret = new Double2D.sized(diagonal.length, diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      ret[i][i] = diagonal[i];
    }
    return ret;
  }

  Double2D.fromNum(data) : _data = <Double1D>[] {
    if (data is Iterable) {
      if (data.length != 0) {
        final int len = data.first.length;
        for (dynamic item in data) {
          if (item.length != len) {
            throw new Exception('All rows must have same number of columns!');
          }
        }

        for (Numeric1DView item in data) {
          _data.add(new Double1D.fromNum(item));
        }
      }
    } else if (data is Array2DView<num>) {
      for (ArrayView<num> item in data.rows) {
        _data.add(new Double1D.fromNum(item));
      }
    }
  }

  Double2D.repeatRow(ArrayView<double> row, [int numRows = 1])
      : _data = new List<Double1D>()..length = numRows {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Double1D.copy(row);
    }
  }

  Double2D.repeatCol(ArrayView<double> column, [int numCols = 1])
      : _data = new List<Double1D>()..length = column.length {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Double1D.sized(numCols, data: column[i]);
    }
  }

  Double2D.aRow(ArrayView<double> row)
      : _data = new List<Double1D>()..length = 1 {
    _data[0] = new Double1D.copy(row);
  }

  Double2D.aCol(ArrayView<double> column)
      : _data = new List<Double1D>()..length = column.length {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Double1D.single(column[i]);
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

  operator []=(final int i, final ArrayView<double> val) {
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
  void add(ArrayView<double> row) => this[numRows] = row;

  @override
  void addScalar(double v) => _data.add(new Double1D.sized(numCols, data: v));

  @override
  void insert(int index, ArrayView<double> row) {
    if (index > numRows) throw new RangeError.range(index, 0, numRows);
    if (row.length != numCols) throw new ArgumentError.value(row, 'row');
    _data.insert(index, new Double1D.copy(row));
  }

  Iterator<Double1D> get iterator => _data.iterator;

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
        _data[r][c] = math.log(_data[r][c]) / math.LN10;
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

  Double2D addition(/* int | Iterable<int> | Numeric2DArray */ other,
      {bool self: false}) {
    if (!self) return this + other;

    if (other is num) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          _data[r][c] += other;
        }
      }
      return this;
    } else if (other is Iterable<num>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] += other;
      }
      return this;
    } else if (other is Numeric2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] += other[r];
      }
      return this;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Double2D subtract(/* int | Iterable<int> | Numeric2DArray */ other,
      {bool self: false}) {
    if (!self) return this - other;

    if (other is num) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          _data[r][c] -= other;
        }
      }
      return this;
    } else if (other is Iterable<num>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] -= other;
      }
      return this;
    } else if (other is Numeric2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] -= other[r];
      }
      return this;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Double2D multiply(/* int | Iterable<int> | Numeric2DArray */ other,
      {bool self: false}) {
    if (!self) return this * other;

    if (other is num) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          _data[r][c] *= other;
        }
      }
      return this;
    } else if (other is Iterable<num>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] *= other;
      }
      return this;
    } else if (other is Numeric2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] *= other[r];
      }
      return this;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Double2D divide(/* int | Iterable<int> | Numeric2DArray */ other,
      {bool self: false}) {
    if (!self) return this / other;

    if (other is num) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          _data[r][c] /= other;
        }
      }
      return this;
    } else if (other is Iterable<num>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] /= other;
      }
      return this;
    } else if (other is Numeric2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] /= other[r];
      }
      return this;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Int2D truncDiv(/* int | Iterable<int> | Int2DArray */ other,
      {bool self: false}) {
    if (!self) return this ~/ other;

    throw new Exception('self not allowed!');
  }

  @override
  Iterable<ArrayFix<double>> get rows => _data;

  @override
  Iterable<ArrayFix<double>> get cols => new ColsListFix<double>(this);
}
