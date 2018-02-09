part of grizzly.series.array2d;

class Int2D extends Object
    with Int2DMixin, Array2DViewMixin<int>
    implements Numeric2D<int>, Int2DFix {
  final List<Int1D> _data;

  Int2D(Iterable<Iterable<int>> data) : _data = <Int1D>[] {
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

  /// Create [Int2D] from column major
  factory Int2D.columns(Iterable<Iterable<int>> columns) {
    if (columns.length == 0) {
      return new Int2D.sized(0, 0);
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
    return ret;
  }

  Int2D.from(Iterable<Int1DView> data)
      : _data = new List<Int1D>()..length = data.length {
    if (data.length != 0) {
      final int len = data.first.length;
      for (Int1DView item in data) {
        if (item.length != len) {
          throw new Exception('All rows must have same number of columns!');
        }
      }

      for (int i = 0; i < data.length; i++) {
        Int1DView item = data.elementAt(i);
        _data[i] = item.clone();
      }
    }
  }

  Int2D.copy(Array2DView<int> data)
      : _data = new List<Int1D>()..length = data.numRows {
    for (int i = 0; i < data.numRows; i++) {
      _data[i] = data[i].clone();
    }
  }

  Int2D.own(this._data) {
    // TODO check that all rows are of same length
  }

  Int2D.sized(int rows, int columns, {int data: 0})
      : _data = new List<Int1D>.generate(
            rows, (_) => new Int1D.sized(columns, data: data));

  Int2D.shaped(Index2D shape, {int data: 0})
      : _data = new List<Int1D>.generate(
            shape.row, (_) => new Int1D.sized(shape.col, data: data));

  factory Int2D.shapedLike(Array2DView like, {int data: 0}) =>
      new Int2D.sized(like.numRows, like.numCols, data: data);

  factory Int2D.diagonal(Iterable<int> diagonal) {
    final ret = new Int2D.sized(diagonal.length, diagonal.length);
    for (int i = 0; i < diagonal.length; i++) {
      ret[i][i] = diagonal.elementAt(i);
    }
    return ret;
  }

  Int2D.repeatRow(IterView<int> row, [int numRows = 1])
      : _data = new List<Int1D>()..length = numRows {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Int1D.copy(row);
    }
  }

  Int2D.repeatCol(IterView<int> column, [int numCols = 1])
      : _data = new List<Int1D>()..length = column.length {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Int1D.sized(numCols, data: column[i]);
    }
  }

  Int2D.aRow(IterView<int> row) : _data = new List<Int1D>()..length = 1 {
    _data[0] = new Int1D.copy(row);
  }

  Int2D.aCol(IterView<int> column)
      : _data = new List<Int1D>()..length = column.length {
    for (int i = 0; i < numRows; i++) {
      _data[i] = new Int1D.single(column[i]);
    }
  }

  factory Int2D.genRows(int numRows, Iterable<int> rowMaker(int index)) {
    final rows = <Int1D>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Int1D(v));
    }
    return new Int2D.own(rows);
  }

  factory Int2D.genCols(int numCols, Iterable<int> colMaker(int index)) {
    final List<Iterable<int>> cols = <Iterable<int>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Int2D.columns(cols);
  }

  factory Int2D.gen(Index2D shape, int colMaker(int row, int col)) {
    final ret = new Int2D.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = colMaker(r, c);
      }
    }
    return ret;
  }

  static Int2D buildRows<T>(Iterable<T> iterable, Iterable<int> rowMaker(T v)) {
    final rows = <Int1D>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new Int1D(v));
    }
    return new Int2D.own(rows);
  }

  static Int2D buildCols<T>(Iterable<T> iterable, Iterable<int> colMaker(T v)) {
    final List<Iterable<int>> cols = <Iterable<int>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new Int2D.columns(cols);
  }

  static Int2D build<T>(Iterable<Iterable<T>> data, int colMaker(T v)) {
    if (data.length == 0) {
      return new Int2D.sized(0, 0);
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
    return ret;
  }

  covariant Int2DCol _col;

  Int2DCol get col => _col ??= new Int2DCol(this);

  covariant Int2DRow _row;

  Int2DRow get row => _row ??= new Int2DRow(this);

  @override
  Iterable<ArrayFix<int>> get rows => _data;

  @override
  Iterable<ArrayFix<int>> get cols => new ColsListFix<int>(this);

  Int1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, ArrayView<int> val) {
    if (i > numRows) {
      throw new RangeError.range(i, 0, numRows - 1, 'i');
    }

    if (numRows == 0) {
      final arr = new Int1D.copy(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw new Exception('Invalid size!');

    final arr = new Int1D.copy(val);

    if (i == numRows) {
      _data.add(arr);
      return;
    }

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

  @override
  void add(ArrayView<int> row) => this[numRows] = row;

  @override
  void addScalar(int v) => _data.add(new Int1D.sized(numCols, data: v));

  @override
  void insert(int index, ArrayView<int> row) {
    if (index > numRows) throw new RangeError.range(index, 0, numRows);
    if (row.length != numCols)
      throw new ArgumentError.value(row, 'row', 'Size mismatch!');
    _data.insert(index, new Int1D.copy(row));
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

  // TODO return lazy
  // TODO return view
  IntPair<Int1D> pairAt(int index) => intPair<Int1D>(index, _data[index]);

  // TODO return lazy
  // TODO return view
  Iterable<IntPair<Int1D>> enumerate() =>
      Ranger.indices(numRows).map((i) => intPair<Int1D>(i, _data[i]));

  Int2D operator +(/* int | Iterable<int> | Numeric2DArray */ other) {
    if (other is int) {
      Int2D ret = new Int2D.copy(this);
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          ret[r][c] += other;
        }
      }
      return ret;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.copy(this);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] + other;
      }
      return ret;
    } else if (other is Numeric2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.copy(this);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] + other[r];
      }
      return ret;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Int2D operator -(/* int | Iterable<int> | Numeric2DArray */ other) {
    if (other is int) {
      Int2D ret = new Int2D.copy(this);
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          ret[r][c] -= other;
        }
      }
      return ret;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.copy(this);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] - other;
      }
      return ret;
    } else if (other is Numeric2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.copy(this);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] - other[r];
      }
      return ret;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Int2D operator *(/* int | Iterable<int> | Numeric2DArray */ other) {
    if (other is int) {
      Int2D ret = new Int2D.copy(this);
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          ret[r][c] *= other;
        }
      }
      return ret;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.copy(this);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] * other;
      }
      return ret;
    } else if (other is Numeric2D) {
      if (numCols != other.numRows)
        throw new ArgumentError.value(other, 'other', 'Invalid shape!');
      final ret = new Int2D.sized(numRows, other.numCols);
      for (int r = 0; r < ret.numRows; r++) {
        for (int c = 0; c < ret.numCols; c++) {
          ret[r][c] = _data[r].dot(other.col[c].asIterable);
        }
      }
      return ret;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Int2DView _view;

  Int2DView get view => _view ??= new Int2DView.own(_data);

  Int2DFix _fixed;

  Int2DFix get fixed => _fixed ??= new Int2DFix.own(_data);

  Int2D addition(/* int | Iterable<int> | Int2DArray */ other,
      {bool self: false}) {
    if (!self) return this + other;

    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          _data[r][c] += other;
        }
      }
      return this;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] += other;
      }
      return this;
    } else if (other is Int2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] += other[r];
      }
      return this;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Int2D subtract(/* int | Iterable<int> | Int2DArray */ other,
      {bool self: false}) {
    if (!self) return this - other;

    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          _data[r][c] -= other;
        }
      }
      return this;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] -= other;
      }
      return this;
    } else if (other is Int2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] -= other[r];
      }
      return this;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Int2D multiply(/* int | Iterable<int> | Int2DArray */ other,
      {bool self: false}) {
    if (!self) return this * other;

    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          _data[r][c] *= other;
        }
      }
      return this;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] *= other;
      }
      return this;
    } else if (other is Int2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] *= other[r];
      }
      return this;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Double2D divide(/* int | Iterable<int> | Int2DArray */ other,
      {bool self: false}) {
    if (!self) return this / other;

    throw new Exception('self not allowed!');
  }

  Int2D truncDiv(/* int | Iterable<int> | Int2DArray */ other,
      {bool self: false}) {
    if (!self) return this ~/ other;

    if (other is int) {
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          _data[r][c] ~/= other;
        }
      }
      return this;
    } else if (other is Iterable<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] ~/= other;
      }
      return this;
    } else if (other is Int2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      for (int r = 0; r < numRows; r++) {
        _data[r] ~/= other[r];
      }
      return this;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }
}
