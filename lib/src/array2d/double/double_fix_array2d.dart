part of grizzly.array2d;

abstract class Double2DMixin implements Numeric2D<double> {
  set diagonal(val) {
    int d = math.min(numRows, numCols);
    if (val is double) {
      for (int r = 0; r < d; r++) this[r][r] = val;
    } else if (val is num) {
      val = val.toDouble();
      for (int r = 0; r < d; r++) this[r][r] = val;
    } else if (val is Iterable<double>) {
      if (val.length != d)
        throw lengthMismatch(expected: d, found: val.length, subject: 'val');
      for (int r = 0; r < d; r++) this[r][r] = val.elementAt(r);
    } else if (val is Iterable<num>) {
      if (val.length != d)
        throw lengthMismatch(expected: d, found: val.length, subject: 'val');
      for (int r = 0; r < d; r++) this[r][r] = val.elementAt(r)?.toDouble();
    } else if (val is Array2D<double>) {
      if (val.numRows < d || val.numCols < d) throw Exception();
      for (int r = 0; r < d; r++) this[r][r] = val[r][r];
    } else if (val is Array2D<num>) {
      if (val.numRows < d || val.numCols < d) throw Exception();
      for (int r = 0; r < d; r++) this[r][r] = val[r][r]?.toDouble();
    } else {
      throw UnsupportedError('Type!');
    }
  }

  void negate() {
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        this[r][c] = -this[r][c];
      }
    }
  }

  void addition(
      /* num | Iterable<num> | Numeric2D<double> */ other) {
    if (other is double) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] += other;
        }
      }
      return;
    } else if (other is Iterable<double>) {
      if (other.length != numCols)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] += other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<double>) {
      if (shape != other.shape)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] += other[r][c];
        }
      }
      return;
    } else if (other is num || other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] += other;
      }
      return;
    }
    throw ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  void subtract(
      /* num | Iterable<num> | Numeric2D<double> */ other) {
    if (other is double) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] -= other;
        }
      }
      return;
    } else if (other is Iterable<double>) {
      if (other.length != numCols)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] -= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<double>) {
      if (shape != other.shape)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] -= other[r][c];
        }
      }
      return;
    } else if (other is num || other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] -= other;
      }
      return;
    }
    throw ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  void multiply(
      /* num | Iterable<num> | Numeric2D<double> */ other) {
    if (other is double) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] *= other;
        }
      }
      return;
    } else if (other is Iterable<double>) {
      if (other.length != numCols)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] *= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<double>) {
      if (shape != other.shape)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] *= other[r][c];
        }
      }
      return;
    } else if (other is num || other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] *= other;
      }
      return;
    }
    throw ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  void divide(
      /* num | Iterable<num> | Numeric2D<double> */ other) {
    if (other is double) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other;
        }
      }
      return;
    } else if (other is Iterable<double>) {
      if (other.length != numCols)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<double>) {
      if (shape != other.shape)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other[r][c];
        }
      }
      return;
    } else if (other is num || other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] /= other;
      }
      return;
    }
    throw ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  void truncDiv(
      /* num | Iterable<num> | Numeric2D<double> */ other) {
    if (other is double) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other;
        }
      }
      return;
    } else if (other is Iterable<double>) {
      if (other.length != numCols)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<double>) {
      if (shape != other.shape)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] /= other[r][c];
        }
      }
      return;
    } else if (other is num || other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] /= other;
      }
      return;
    }
    throw ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  void rdivMe(
      /* num | Iterable<num> | Numeric2D<double> */ other) {
    if (other is double) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] = other / this[r][c];
        }
      }
      return;
    } else if (other is Iterable<double>) {
      if (other.length != numCols)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] = other.elementAt(c) / this[r][c];
        }
      }
      return;
    } else if (other is Numeric2D<double>) {
      if (shape != other.shape)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] = other[r][c] / this[r][c];
        }
      }
      return;
    } else if (other is num || other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] = other / this[r];
      }
      return;
    }
    throw ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  void matmulMe(Array2D<num> other) {
    if (!other.isSquare || numCols != other.numRows)
      throw Exception('Invalid size!');

    final temp = Double1DFix.sized(numCols);
    for (int i = 0; i < numRows; i++) {
      temp.set = 0.0;
      for (int j = 0; j < numCols; j++) {
        double v = 0.0;
        for (int ri = 0; ri < numCols; ri++) {
          v += this[i][ri] * other[ri][j];
        }
        temp[j] = v;
      }
      this[i] = temp;
    }
  }

  void matmulDiagMe(ArrayView<num> other) {
    if (numCols != other.length) throw Exception('Invalid size!');

    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < other.length; j++) {
        this[i][j] = this[i][j] * other[j];
      }
    }
  }
}

/*


class Double2DFix extends Object
    with
        Array2DViewMixin<double>,
        Array2DFixMixin<double>,
        IterableMixin<Iterable<double>>,
        Double2DViewMixin,
        Double2DFixMixin
    implements Numeric2DFix<double>, Double2DView {
  final List<Double1DFix> _data;

  final String1DFix names;

  Double2DFix(Iterable<Iterable<double>> rows, [Iterable<String> names])
      : _data = List<Double1DFix>(rows.length),
        names = names != null
            ? String1DFix(names, "Names")
            : String1DFix.sized(rows.isNotEmpty ? rows.first.length : 0,
                name: 'Names') {
    if (rows.isEmpty) {
      Exceptions.labelLen(0, this.names.length);
      return;
    }
    Exceptions.labelLen(rows.first.length, this.names.length);
    Exceptions.rowsLen(rows);
    for (int i = 0; i < rows.length; i++) {
      _data[i] = Double1DFix(rows.elementAt(i));
    }
  }

  Double2DFix.own(this._data, [Iterable<String> names])
      : names = names != null
            ? String1DFix(names, "Names")
            : String1DFix.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory Double2DFix.fromNums(Iterable<Iterable<num>> rows,
      [Iterable<String> names]) {
    final data = List<Double1DFix>(rows.length);
    for (int i = 0; i < rows.length; i++)
      data[i] = Double1DFix.fromNums(rows.elementAt(i));
    return Double2DFix.own(data, names);
  }

  factory Double2DFix.sized(int rows, int cols,
      {double fill: 0.0, Iterable<String> names}) {
    final data = List<Double1DFix>(rows);
    for (int i = 0; i < rows; i++) {
      data[i] = Double1DFix.sized(cols, fill: fill);
    }
    return Double2DFix.own(data, names);
  }

  factory Double2DFix.shaped(Index2D shape,
          {double fill: 0.0, Iterable<String> names}) =>
      Double2DFix.sized(shape.row, shape.col, fill: fill, names: names);

  factory Double2DFix.shapedLike(Array2DView like,
          {double fill: 0.0, Iterable<String> names}) =>
      Double2DFix.sized(like.numRows, like.numCols, fill: fill, names: names);

  /// Create [Int2D] from column major
  factory Double2DFix.columns(Iterable<Iterable<double>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return Double2DFix.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<Double1DFix>(numRows);
    for (int i = 0; i < numRows; i++) {
      final row = List<double>(numCols);
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = Double1DFix.own(row);
    }
    return Double2DFix.own(data, names);
  }

  factory Double2DFix.diagonal(Iterable<double> diagonal,
      {Index2D shape, Iterable<String> names, double fill: 0.0}) {
    shape ??= Index2D(diagonal.length, diagonal.length);
    final ret = Double2DFix.shaped(shape, fill: fill, names: names);
    int length = math.min(math.min(shape.row, shape.col), diagonal.length);
    for (int i = 0; i < length; i++) {
      ret[i][i] = diagonal.elementAt(i);
    }
    return ret;
  }

  factory Double2DFix.aRow(Iterable<double> row,
      {int repeat = 1, Iterable<String> names}) {
    final data = List<Double1DFix>.filled(repeat, null, growable: true);
    if (row is Iterable<double>) {
      for (int i = 0; i < repeat; i++) data[i] = Double1DFix(row);
    } else {
      final temp = Double1DFix.fromNums(row);
      data[0] = temp;
      for (int i = 1; i < repeat; i++) data[i] = Double1DFix(temp);
    }
    return Double2DFix.own(data, names);
  }

  factory Double2DFix.aCol(Iterable<double> column,
      {int repeat = 1, Iterable<String> names}) {
    if (column is Iterable<double>) {
      return Double2DFix.columns(
          ranger.ConstantIterable<Iterable<double>>(column, repeat), names);
    }
    return Double2DFix.columns(
        ranger.ConstantIterable<Iterable<double>>(
            Double1DView.fromNums(column), repeat),
        names);
  }

  factory Double2DFix.genRows(
      int numRows, Iterable<double> rowMaker(int index)) {
    final rows = <Double1DFix>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Double1DFix(v));
    }
    return Double2DFix.own(rows);
  }

  factory Double2DFix.genCols(
      int numCols, Iterable<double> colMaker(int index)) {
    final List<Iterable<double>> cols = <Iterable<double>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Double2DFix.columns(cols);
  }

  factory Double2DFix.gen(Index2D shape, double maker(int row, int col)) {
    final ret = Double2DFix.shaped(shape);
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
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Double1DFix(v));
    }
    return Double2DFix.own(rows);
  }

  static Double2DFix buildCols<T>(
      Iterable<T> iterable, Iterable<double> colMaker(T v)) {
    final List<Iterable<double>> cols = <Iterable<double>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Double2DFix.columns(cols);
  }

  static Double2DFix build<T>(Iterable<Iterable<T>> data, double maker(T v)) {
    if (data.length == 0) {
      return Double2DFix.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw Exception('Size mismatch!');
    }

    final ret = Double2DFix.sized(data.length, data.first.length);
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

  Iterator<Double1DView> get iterator => _data.iterator;

  covariant Double2DColFix _col;

  Double2DColFix get col => _col ??= Double2DColFix(this);

  covariant Double2DRowFix _row;

  Double2DRowFix get row => _row ??= Double2DRowFix(this);

  Double1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, Iterable<double> val) {
    if (i >= numRows) {
      throw RangeError.range(i, 0, numRows - 1, 'i');
    }

    if (numRows == 0) {
      final arr = Double1D(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw Exception('Invalid size!');
    final arr = Double1D(val);
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
      throw ArgumentError.value(other, 'other', 'Size mismatch!');

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

  Double2DView get view => _view ??= Double2DView.own(_data);

  Double2DFix get fixed => this;

  @override
  Iterable<ArrayFix<double>> get rows => _data;

  @override
  Iterable<ArrayFix<double>> get cols => ColsListFix<double>(this);

  Double1D unique() => super.unique();
}
*/
