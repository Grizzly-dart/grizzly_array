part of grizzly.series.array2d;

abstract class Int2DFixMixin implements Numeric2DFix<int> {
  set diagonal(/* num | Iterable<num> | Array2DView<num> */ val) {
    int d = math.min(numRows, numCols);
    if (val is int) {
      for (int r = 0; r < d; r++) this[r][r] = val;
    } else if (val is num) {
      val = val.toInt();
      for (int r = 0; r < d; r++) this[r][r] = val;
    } else if (val is Iterable<int>) {
      if (val.length != d)
        throw lengthMismatch(expected: d, found: val.length, subject: 'val');
      for (int r = 0; r < d; r++) this[r][r] = val.elementAt(r);
    } else if (val is Iterable<num>) {
      if (val.length != d)
        throw lengthMismatch(expected: d, found: val.length, subject: 'val');
      for (int r = 0; r < d; r++) this[r][r] = val.elementAt(r)?.toInt();
    } else if (val is Array2DView<int>) {
      if (val.numRows < d || val.numCols < d) throw Exception();
      for (int r = 0; r < d; r++) this[r][r] = val[r][r];
    } else if (val is Array2DView<num>) {
      if (val.numRows < d || val.numCols < d) throw Exception();
      for (int r = 0; r < d; r++) this[r][r] = val[r][r]?.toInt();
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
      /* num | Iterable<num> | Numeric2D<int> */ other) {
    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] += other;
        }
      }
      return;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] += other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<int>) {
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
      /* num | Iterable<num> | Numeric2D<int> */ other) {
    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] -= other;
        }
      }
      return;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] -= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<int>) {
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
      /* num | Iterable<num> | Numeric2D<int> */ other) {
    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] *= other;
        }
      }
      return;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] *= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<int>) {
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
          /* num | Iterable<num> | Numeric2D<int> */ other) =>
      truncDiv(other);

  void truncDiv(
      /* num | Iterable<num> | Numeric2D<int> */ other) {
    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] ~/= other;
        }
      }
      return;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] ~/= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<int>) {
      if (shape != other.shape)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] ~/= other[r][c];
        }
      }
      return;
    } else if (other is num || other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] ~/= other;
      }
      return;
    }
    throw ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  void rdivMe(
      /* num | Iterable<num> | Numeric2D<int> */ other) {
    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] = other ~/ this[r][c];
        }
      }
      return;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] = other.elementAt(c) ~/ this[r][c];
        }
      }
      return;
    } else if (other is Numeric2D<int>) {
      if (shape != other.shape)
        throw ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] = other[r][c] ~/ this[r][c];
        }
      }
      return;
    } else if (other is num || other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] = other ~/ this[r];
      }
      return;
    }
    throw ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  void matmulMe(Array2DView<int> other) {
    if (!other.isSquare || numCols != other.numRows)
      throw Exception('Invalid size!');

    final temp = Int1DFix.sized(numCols);
    for (int i = 0; i < numRows; i++) {
      temp.set = 0;
      for (int j = 0; j < numCols; j++) {
        int v = 0;
        for (int ri = 0; ri < numCols; ri++) {
          v += this[i][ri] * other[ri][j];
        }
        temp[j] = v;
      }
      this[i] = temp;
    }
  }

  void matmulDiagMe(ArrayView<int> other) {
    if (numCols != other.length) throw Exception('Invalid size!');

    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < other.length; j++) {
        this[i][j] = this[i][j] * other[j];
      }
    }
  }
}

class Int2DFix extends Object
    with
        Array2DViewMixin<int>,
        Array2DFixMixin<int>,
        IterableMixin<Iterable<int>>,
        Int2DViewMixin,
        Int2DFixMixin
    implements Numeric2DFix<int>, Int2DView {
  final List<Int1DFix> _data;

  final String1DFix names;

  Int2DFix(Iterable<Iterable<int>> rows, [Iterable<String> names])
      : _data = List<Int1DFix>(rows.length),
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
      _data[i] = Int1DFix(rows.elementAt(i));
    }
  }

  Int2DFix.own(this._data, [Iterable<String> names])
      : names = names != null
            ? String1DFix(names, "Names")
            : String1DFix.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory Int2DFix.fromNums(Iterable<Iterable<num>> rows,
      [Iterable<String> names]) {
    final data = List<Int1DFix>()..length = rows.length;
    for (int i = 0; i < rows.length; i++)
      data[i] = Int1DFix.fromNums(rows.elementAt(i));
    return Int2DFix.own(data, names);
  }

  factory Int2DFix.sized(int rows, int cols,
      {int fill: 0, Iterable<String> names}) {
    final data = List<Int1DFix>(rows);
    for (int i = 0; i < rows; i++) {
      data[i] = Int1DFix.sized(cols, fill: fill);
    }
    return Int2DFix.own(data, names);
  }

  factory Int2DFix.shaped(Index2D shape,
          {int fill: 0, Iterable<String> names}) =>
      Int2DFix.sized(shape.row, shape.col, fill: fill, names: names);

  factory Int2DFix.shapedLike(Array2DView like,
          {int fill: 0, Iterable<String> names}) =>
      Int2DFix.sized(like.numRows, like.numCols, fill: fill, names: names);

  /// Create [Int2D] from column major
  factory Int2DFix.columns(Iterable<Iterable<int>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return Int2DFix.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<Int1DFix>(numRows);
    for (int i = 0; i < numRows; i++) {
      final row = List<int>(numCols);
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = Int1DFix.own(row);
    }
    return Int2DFix.own(data, names);
  }

  factory Int2DFix.diagonal(Iterable<int> diagonal,
      {Index2D shape, Iterable<String> names, int fill: 0}) {
    shape ??= Index2D(diagonal.length, diagonal.length);
    final ret = Int2DFix.shaped(shape, fill: fill, names: names);
    int length = math.min(math.min(shape.row, shape.col), diagonal.length);
    for (int i = 0; i < length; i++) {
      ret[i][i] = diagonal.elementAt(i);
    }
    return ret;
  }

  factory Int2DFix.aRow(Iterable<int> row,
      {int repeat = 1, Iterable<String> names}) {
    final data = List<Int1DFix>.filled(repeat, null, growable: true);
    if (row is Iterable<int>) {
      for (int i = 0; i < repeat; i++) data[i] = Int1DFix(row);
    } else {
      final temp = Int1DFix.fromNums(row);
      data[0] = temp;
      for (int i = 1; i < repeat; i++) data[i] = Int1DFix(temp);
    }
    return Int2DFix.own(data, names);
  }

  factory Int2DFix.aCol(Iterable<int> column,
      {int repeat = 1, Iterable<String> names}) {
    if (column is Iterable<int>) {
      return Int2DFix.columns(
          ranger.ConstantIterable<Iterable<int>>(column, repeat), names);
    }
    return Int2DFix.columns(
        ranger.ConstantIterable<Iterable<int>>(Int1DView.fromNums(column), repeat),
        names);
  }

  factory Int2DFix.genRows(int numRows, Iterable<int> rowMaker(int index)) {
    final rows = <Int1DFix>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Int1DFix(v));
    }
    return Int2DFix.own(rows);
  }

  factory Int2DFix.genCols(int numCols, Iterable<int> colMaker(int index)) {
    final List<Iterable<int>> cols = <Iterable<int>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Int2DFix.columns(cols);
  }

  factory Int2DFix.gen(Index2D shape, int colMaker(int row, int col)) {
    final ret = Int2DFix.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = colMaker(r, c);
      }
    }
    return ret;
  }

  static Int2DFix buildRows<T>(
      Iterable<T> iterable, Iterable<int> rowMaker(T v)) {
    final rows = <Int1DFix>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Int1DFix(v));
    }
    return Int2DFix.own(rows);
  }

  static Int2DFix buildCols<T>(
      Iterable<T> iterable, Iterable<int> colMaker(T v)) {
    final List<Iterable<int>> cols = <Iterable<int>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw Exception('Size mismatch!');
      cols.add(v);
    }
    return Int2DFix.columns(cols);
  }

  static Int2DFix build<T>(Iterable<Iterable<T>> data, int colMaker(T v)) {
    if (data.length == 0) {
      return Int2DFix.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw Exception('Size mismatch!');
    }

    final ret = Int2DFix.sized(data.length, data.first.length);
    for (int r = 0; r < ret.numRows; r++) {
      final Iterator<T> row = data.elementAt(r).iterator;
      row.moveNext();
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = colMaker(row.current);
        row.moveNext();
      }
    }
    return ret;
  }

  Iterator<Int1DView> get iterator => _data.iterator;

  covariant Int2DColFix _col;

  Int2DColFix get col => _col ??= Int2DColFix(this);

  covariant Int2DRowFix _row;

  Int2DRowFix get row => _row ??= Int2DRowFix(this);

  @override
  Iterable<ArrayFix<int>> get rows => _data;

  @override
  Iterable<ArrayFix<int>> get cols => ColsListFix<int>(this);

  Int1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, Iterable<int> val) {
    if (i >= numRows)
      throw RangeError.range(i, 0, numRows - 1, 'i', 'Out of range!');

    if (numRows == 0) {
      final arr = Int1D(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw Exception('Invalid size!');
    final arr = Int1D(val);
    _data[i] = arr;
  }

  /// Sets all elements in the array to given value [v]
  void set(int v) {
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = v;
      }
    }
  }

  @override
  void assign(Array2DView<int> other) {
    if (other.shape != shape)
      throw ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = other[r][c];
      }
    }
  }

  void clip({int min, int max}) {
    if (numRows == 0) return;

    if (min != null && max != null) {
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < _data.first.length; j++) {
          final int d = _data[i][j];

          if (d < min) _data[i][j] = min;
          if (d > max) _data[i][j] = max;
        }
      }
      return;
    }
    if (min != null) {
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < _data.first.length; j++) {
          final int d = _data[i][j];

          if (d < min) _data[i][j] = min;
        }
      }
      return;
    }
    if (max != null) {
      for (int j = 0; j < _data.first.length; j++) {
        for (int i = 0; i < numRows; i++) {
          final int d = _data[i][j];

          if (d > max) _data[i][j] = max;
        }
      }
      return;
    }
  }

  Int2DView _view;

  Int2DView get view => _view ??= Int2DView.own(_data);

  Int2DFix get fixed => this;

  Int1D unique() => super.unique();
}
