part of grizzly.series.array2d;

abstract class Int2DFixMixin implements Numeric2DFix<int> {
  void negate() {
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        this[r][c] = -this[r][c];
      }
    }
  }

  void addition(
      /* num | IterView<num> | Iterable<num> | Numeric2D<int> */ other) {
    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] += other;
        }
      }
      return;
    } else if (other is IterView<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] += other[c];
        }
      }
      return;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] += other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<int>) {
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
      /* num | IterView<num> | Iterable<num> | Numeric2D<int> */ other) {
    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] -= other;
        }
      }
      return;
    } else if (other is IterView<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] -= other[c];
        }
      }
      return;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] -= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<int>) {
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
      /* num | IterView<num> | Iterable<num> | Numeric2D<int> */ other) {
    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] *= other;
        }
      }
      return;
    } else if (other is IterView<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] *= other[c];
        }
      }
      return;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] *= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<int>) {
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
          /* num | IterView<num> | Iterable<num> | Numeric2D<int> */ other) =>
      truncDiv(other);

  void truncDiv(
      /* num | IterView<num> | Iterable<num> | Numeric2D<int> */ other) {
    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] ~/= other;
        }
      }
      return;
    } else if (other is IterView<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] ~/= other[c];
        }
      }
      return;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] ~/= other.elementAt(c);
        }
      }
      return;
    } else if (other is Numeric2D<int>) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          this[r][c] ~/= other[r][c];
        }
      }
      return;
    } else if (other is num ||
        other is IterView<num> ||
        other is Iterable<num>) {
      for (int r = 0; r < numRows; r++) {
        this[r] ~/= other;
      }
      return;
    }
    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }
}

class Int2DFix extends Object
    with Array2DViewMixin<int>, Int2DViewMixin, Int2DFixMixin
    implements Numeric2DFix<int>, Int2DView {
  final List<Int1DFix> _data;

  Int2DFix(Iterable<Iterable<int>> data) : _data = <Int1DFix>[] {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Iterable<int> item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (Iterable<int> item in data) {
        _data.add(new Int1DFix(item));
      }
    }
  }

  /// Create [Int2D] from column major
  factory Int2DFix.columns(Iterable<Iterable<int>> columns) {
    if (columns.length == 0) {
      return new Int2DFix.sized(0, 0);
    }

    if (!columns.every((i) => i.length == columns.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Int2DFix.sized(columns.first.length, columns.length);
    for (int c = 0; c < ret.numCols; c++) {
      final Iterator<int> col = columns.elementAt(c).iterator;
      col.moveNext();
      for (int r = 0; r < ret.numRows; r++) {
        ret[r][c] = col.current;
        col.moveNext();
      }
    }
    return ret;
  }

  Int2DFix.from(Iterable<IterView<int>> data)
      : _data = new List<Int1DFix>(data.length) {
    if (data.length != 0) {
      final int len = data.first.length;
      for (IterView item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        IterView<int> item = data.elementAt(i);
        _data[i] = new Int1DFix.copy(item);
      }
    }
  }

  Int2DFix.copy(Array2DView<int> data)
      : _data = new List<Int1DView>(data.numRows) {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = new Int1DFix.copy(data[i]);
    }
  }

  Int2DFix.own(this._data) {
    // TODO check that all rows are of same length
  }

  Int2DFix.sized(int rows, int columns, {int data: 0})
      : _data = new List<Int1DFix>.generate(
            rows, (_) => new Int1DFix.sized(columns),
            growable: false);

  Int2DFix.shaped(Index2D shape, {int data: 0})
      : _data = new List<Int1DFix>.generate(
            shape.row, (_) => new Int1DFix.sized(shape.col, data: data),
            growable: false);

  factory Int2DFix.shapedLike(Array2DView like, {int data: 0}) =>
      new Int2DFix.sized(like.numRows, like.numCols, data: data);

  factory Int2DFix.diagonal(Iterable<int> diagonal) {
    final ret = new Int2DFix.sized(diagonal.length, diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      ret[i][i] = diagonal.elementAt(i);
    }
    return ret;
  }

  Int2DFix.repeatRow(IterView<int> row, [int numRows = 1])
      : _data = new List<Int1DFix>(numRows) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Int1DFix.copy(row);
    }
  }

  Int2DFix.repeatCol(IterView<int> column, [int numCols = 1])
      : _data = new List<Int1DFix>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Int1DFix.sized(numCols, data: column[i]);
    }
  }

  Int2DFix.aRow(IterView<int> row) : _data = new List<Int1DFix>(1) {
    _data[0] = new Int1DFix.copy(row);
  }

  Int2DFix.aCol(IterView<int> column)
      : _data = new List<Int1DFix>(column.length) {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Int1DFix.single(column[i]);
    }
  }

  factory Int2DFix.genRows(int numRows, Iterable<int> rowMaker(int index)) {
    final rows = <Int1DFix>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Int1DFix(v));
    }
    return new Int2DFix.own(rows);
  }

  factory Int2DFix.genCols(int numCols, Iterable<int> colMaker(int index)) {
    final List<Iterable<int>> cols = <Iterable<int>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Int2DFix.columns(cols);
  }

  factory Int2DFix.gen(Index2D shape, int colMaker(int row, int col)) {
    final ret = new Int2DFix.shaped(shape);
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
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Int1DFix(v));
    }
    return new Int2DFix.own(rows);
  }

  static Int2DFix buildCols<T>(
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
    return new Int2DFix.columns(cols);
  }

  static Int2DFix build<T>(Iterable<Iterable<T>> data, int colMaker(T v)) {
    if (data.length == 0) {
      return new Int2DFix.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new Int2DFix.sized(data.length, data.first.length);
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

  covariant Int2DColFix _col;

  Int2DColFix get col => _col ??= new Int2DColFix(this);

  covariant Int2DRowFix _row;

  Int2DRowFix get row => _row ??= new Int2DRowFix(this);

  @override
  Iterable<ArrayFix<int>> get rows => _data;

  @override
  Iterable<ArrayFix<int>> get cols => new ColsListFix<int>(this);

  Int1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, IterView<int> val) {
    if (i >= numRows) {
      throw new RangeError.range(i, 0, numRows - 1, 'i', 'Out of range!');
    }

    if (numRows == 0) {
      final arr = new Int1D.copy(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) {
      throw new Exception('Invalid size!');
    }

    final arr = new Int1D.copy(val);

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
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');

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

  Int2DView get view => _view ??= new Int2DView.own(_data);

  Int2DFix get fixed => this;

  Int1D unique() => super.unique();
}
