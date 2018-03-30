part of grizzly.series.array2d;

abstract class Double2DFixMixin implements Numeric2DFix<double> {
  void negate() {
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        this[r][c] = -this[r][c];
      }
    }
  }

  void addition(
      /* num | IterView<num> | Iterable<num> | Numeric2D<double> */ other) {
    if (other is double) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] += other;
        }
      }
      return;
    } else if (other is IterView<double>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] += other[c];
        }
      }
      return;
    } else if (other is Iterable<double>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] += other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<double>) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] += other[r][c];
        }
      }
      return;
    } else if (other is num ||
        other is IterView<num> ||
        other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] += other;
      }
      return;
    }
    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  void subtract(
      /* num | IterView<num> | Iterable<num> | Numeric2D<double> */ other) {
    if (other is double) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] -= other;
        }
      }
      return;
    } else if (other is IterView<double>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] -= other[c];
        }
      }
      return;
    } else if (other is Iterable<double>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] -= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<double>) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] -= other[r][c];
        }
      }
      return;
    } else if (other is num ||
        other is IterView<num> ||
        other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] -= other;
      }
      return;
    }
    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  void multiply(
      /* num | IterView<num> | Iterable<num> | Numeric2D<double> */ other) {
    if (other is double) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] *= other;
        }
      }
      return;
    } else if (other is IterView<double>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] *= other[c];
        }
      }
      return;
    } else if (other is Iterable<double>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] *= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<double>) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] *= other[r][c];
        }
      }
      return;
    } else if (other is num ||
        other is IterView<num> ||
        other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] *= other;
      }
      return;
    }
    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  void divide(
      /* num | IterView<num> | Iterable<num> | Numeric2D<double> */ other) {
    if (other is double) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other;
        }
      }
      return;
    } else if (other is IterView<double>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other[c];
        }
      }
      return;
    } else if (other is Iterable<double>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<double>) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other[r][c];
        }
      }
      return;
    } else if (other is num ||
        other is IterView<num> ||
        other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] /= other;
      }
      return;
    }
    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  void truncDiv(
      /* num | IterView<num> | Iterable<num> | Numeric2D<double> */ other) {
    if (other is double) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other;
        }
      }
      return;
    } else if (other is IterView<double>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other[c];
        }
      }
      return;
    } else if (other is Iterable<double>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<double>) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other[r][c];
        }
      }
      return;
    } else if (other is num ||
        other is IterView<num> ||
        other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] /= other;
      }
      return;
    }
    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }
}

class Double2DFix extends Object
    with Array2DViewMixin<double>, Double2DViewMixin, Double2DFixMixin
    implements Numeric2DFix<double>, Double2DView {
  final List<Double1DFix> _data;

  Double2DFix(Iterable<Iterable<double>> data) : _data = <Double1DFix>[] {
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
  factory Double2DFix.columns(Iterable<Iterable<double>> columns) {
    if (columns.length == 0) {
      return new Double2DFix.sized(0, 0);
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

  Double2DFix.from(Iterable<IterView<double>> data)
      : _data = new List<Double1DFix>(data.length) {
    if (data.length != 0) {
      final int len = data.first.length;
      for (IterView item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        IterView<double> item = data.elementAt(i);
        _data[i] = new Double1DFix.copy(item);
      }
    }
  }

  Double2DFix.copy(Array2DView<double> data)
      : _data = new List<Double1DFix>(data.numRows) {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = new Double1DFix.copy(data[i]);
    }
  }

  Double2DFix.own(this._data);

  Double2DFix.sized(int numRows, int numCols, {double data: 0.0})
      : _data = new List<Double1DFix>.generate(
            numRows, (_) => new Double1DFix.sized(numCols, data: data),
            growable: false);

  Double2DFix.shaped(Index2D shape, {double data: 0.0})
      : _data = new List<Double1DFix>.generate(
            shape.row, (_) => new Double1DFix.sized(shape.col, data: data),
            growable: false);

  factory Double2DFix.shapedLike(Array2DView like, {double data: 0.0}) =>
      new Double2DFix.sized(like.numRows, like.numCols, data: data);

  factory Double2DFix.diagonal(IterView<double> diagonal) {
    final ret = new Double2DFix.sized(diagonal.length, diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      ret[i][i] = diagonal[i];
    }
    return ret;
  }

  Double2DFix.fromNum(Iterable<Iterable<num>> data)
      : _data = new List<Double1DFix>(data.length) {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<num> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        Iterable<num> item = data.elementAt(i);
        _data[i] = new Double1DFix.nums(item);
      }
    }
  }

  Double2DFix.repeatRow(IterView<double> row, [int numRows = 1])
      : _data = new List<Double1DFix>(numRows) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Double1DFix.copy(row);
    }
  }

  Double2DFix.repeatCol(IterView<double> column, [int numCols = 1])
      : _data = new List<Double1DFix>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Double1DFix.sized(numCols, data: column[i]);
    }
  }

  Double2DFix.aRow(IterView<double> row) : _data = new List<Double1DFix>(1) {
    _data[0] = new Double1DFix.copy(row);
  }

  Double2DFix.aCol(IterView<double> column)
      : _data = new List<Double1DFix>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Double1DFix.single(column[i]);
    }
  }

  factory Double2DFix.genRows(
      int numRows, Iterable<double> rowMaker(int index)) {
    final rows = <Double1DFix>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Double1DFix(v));
    }
    return new Double2DFix.own(rows);
  }

  factory Double2DFix.genCols(
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
    return new Double2DFix.columns(cols);
  }

  factory Double2DFix.gen(Index2D shape, double maker(int row, int col)) {
    final ret = new Double2DFix.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret;
  }

  static Double2DFix buildRows<T>(
      Iterable<T> iterable, Iterable<double> rowMaker(T v)) {
    final rows = <Double1DFix>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Double1DFix(v));
    }
    return new Double2DFix.own(rows);
  }

  static Double2DFix buildCols<T>(
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
    return new Double2DFix.columns(cols);
  }

  static Double2DFix build<T>(Iterable<Iterable<T>> data, double maker(T v)) {
    if (data.length == 0) {
      return new Double2DFix.sized(0, 0);
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
    return ret;
  }

  covariant Double2DColFix _col;

  Double2DColFix get col => _col ??= new Double2DColFix(this);

  covariant Double2DRowFix _row;

  Double2DRowFix get row => _row ??= new Double2DRowFix(this);

  Double1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, IterView<double> val) {
    if (i >= numRows) {
      throw new RangeError.range(i, 0, numRows - 1, 'i');
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

  Double2DFix get logSelf {
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) _data[r][c] = math.log(_data[r][c]);
    }
    return this;
  }

  Double2DFix get log10Self {
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++)
        _data[r][c] = math.log(_data[r][c]) / math.ln10;
    }
    return this;
  }

  Double2DFix logNSelf(double n) {
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

  Double2DFix get fixed => this;

  @override
  Iterable<ArrayFix<double>> get rows => _data;

  @override
  Iterable<ArrayFix<double>> get cols => new ColsListFix<double>(this);

  Double1D unique() => super.unique();
}
