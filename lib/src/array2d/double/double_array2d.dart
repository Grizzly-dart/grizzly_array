part of grizzly.series.array2d;

class Double2D extends Object
    with
        Array2DViewMixin<double>,
        Array2DFixMixin<double>,
        IterableMixin<Iterable<double>>,
        Double2DViewMixin,
        Double2DFixMixin
    implements Numeric2D<double>, Double2DFix {
  final List<Double1D> _data;

  final String1D _names;

  String1DFix get names => _names;

  Double2D(Iterable<Iterable<double>> rows, [Iterable<String> names])
      : _data = <Double1D>[],
        _names = names != null
            ? new String1D(names, "Names")
            : new String1D.sized(rows.isNotEmpty ? rows.first.length : 0,
                name: 'Names') {
    if (rows.isEmpty) {
      Exceptions.labelLen(0, this.names.length);
      return;
    }
    Exceptions.labelLen(rows.first.length, this.names.length);
    Exceptions.rowsLen(rows);
    _data.length = rows.length;
    for (int i = 0; i < rows.length; i++) {
      _data[i] = new Double1D(rows.elementAt(i));
    }
  }

  Double2D.own(this._data, [Iterable<String> names])
      : _names = names != null
            ? new String1D(names, "Names")
            : new String1D.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory Double2D.fromNums(Iterable<Iterable<num>> rows,
      [Iterable<String> names]) {
    final data = new List<Double1D>()..length = rows.length;
    for (int i = 0; i < rows.length; i++)
      data[i] = new Double1D.fromNums(rows.elementAt(i));
    return new Double2D.own(data, names);
  }

  factory Double2D.sized(int rows, int cols,
      {double fill: 0.0, Iterable<String> names}) {
    final data = new List<Double1D>()..length = rows;
    for (int i = 0; i < rows; i++) {
      data[i] = new Double1D.sized(cols, fill: fill);
    }
    return new Double2D.own(data, names);
  }

  factory Double2D.shaped(Index2D shape,
          {double fill: 0.0, Iterable<String> names}) =>
      new Double2D.sized(shape.row, shape.col, fill: fill, names: names);

  factory Double2D.shapedLike(Array2DView like,
          {double fill: 0.0, Iterable<String> names}) =>
      new Double2DFix.sized(like.numRows, like.numCols,
          fill: fill, names: names);

  /// Create [Int2D] from column major
  factory Double2D.columns(Iterable<Iterable<double>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return new Double2D.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = new List<Double1D>()..length = numRows;
    for (int i = 0; i < numRows; i++) {
      final row = new List<double>(numCols);
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = new Double1D.own(row);
    }
    return new Double2D.own(data, names);
  }

  factory Double2D.diagonal(Iterable<double> diagonal,
      {Index2D shape, Iterable<String> names, double fill: 0.0}) {
    shape ??= new Index2D(diagonal.length, diagonal.length);
    final ret = new Double2D.shaped(shape, fill: fill, names: names);
    int length = math.min(math.min(shape.row, shape.col), diagonal.length);
    for (int i = 0; i < length; i++) {
      ret[i][i] = diagonal.elementAt(i);
    }
    return ret;
  }

  factory Double2D.aRow(Iterable<num> row,
      {int repeat = 1, Iterable<String> names}) {
    final data = new List<Double1D>.filled(repeat, null, growable: true);
    if (row is Iterable<double>) {
      for (int i = 0; i < repeat; i++) data[i] = new Double1D(row);
    } else {
      final temp = new Double1D.fromNums(row);
      data[0] = temp;
      for (int i = 1; i < repeat; i++) data[i] = new Double1D(temp);
    }
    return new Double2D.own(data, names);
  }

  factory Double2D.aCol(Iterable<num> column,
      {int repeat = 1, Iterable<String> names}) {
    if (column is Iterable<double>) {
      return new Double2D.columns(
          new ConstantIterable<Iterable<double>>(column, repeat), names);
    }
    return new Double2D.columns(
        new ConstantIterable<Iterable<double>>(
            new Double1DView.fromNums(column), repeat),
        names);
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

  Iterator<Double1DView> get iterator => _data.iterator;

  covariant Double2DCol _col;

  Double2DCol get col => _col ??= new Double2DCol(this);

  covariant Double2DRow _row;

  Double2DRow get row => _row ??= new Double2DRow(this);

  Double1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, final Iterable<double> val) {
    if (i > numRows) {
      throw new RangeError.range(i, 0, numRows - 1, 'i', 'Out of range!');
    }

    if (numRows == 0) {
      final arr = new Double1D(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw new Exception('Invalid size!');

    final arr = new Double1D(val);
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
  void add(Iterable<double> row) => this[numRows] = row;

  @override
  void addScalar(double v) => _data.add(new Double1D.sized(numCols, fill: v));

  @override
  void insert(int index, Iterable<double> row) {
    if (index > numRows) throw new RangeError.range(index, 0, numRows);
    if (row.length != numCols) throw new ArgumentError.value(row, 'row');
    _data.insert(index, new Double1D(row));
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
        _data.add(new Double1D.sized(newShape.col, fill: def));
      }
    }

    if (shape.col > newShape.col) {
      for (Double1D r in _data) {
        r.removeRange(newShape.col, r.length);
      }
    } else {
      for (Double1D r in _data) {
        r.addAll(new Double1D.sized(newShape.col - r.length, fill: def));
      }
    }
  }

  Double1D unique() => super.unique();
}
