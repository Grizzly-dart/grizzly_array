part of grizzly.series.array2d;

class String2D extends Object
    with
        Array2DViewMixin<String>,
        Array2DFixMixin<String>,
        IterableMixin<Iterable<String>>,
        String2DMixin
    implements Array2D<String>, String2DFix {
  final List<String1D> _data;

  final String1D _names;

  String1DFix get names => _names;

  String2D(Iterable<Iterable<String>> rows, [Iterable<String> names])
      : _data = <String1D>[],
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
      _data[i] = new String1D(rows.elementAt(i));
    }
  }

  String2D.own(this._data, [Iterable<String> names])
      : _names = names != null
            ? new String1D(names, "Names")
            : new String1D.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory String2D.sized(int rows, int cols,
      {String fill, Iterable<String> names}) {
    final data = new List<String1D>()..length = rows;
    for (int i = 0; i < rows; i++) {
      data[i] = new String1D.sized(cols, fill: fill);
    }
    return new String2D.own(data, names);
  }

  factory String2D.shaped(Index2D shape,
          {String fill, Iterable<String> names}) =>
      new String2D.sized(shape.row, shape.col, fill: fill, names: names);

  factory String2D.shapedLike(Array2DView like,
          {String fill, Iterable<String> names}) =>
      new String2D.sized(like.numRows, like.numCols,
          fill: fill, names: names);

  /// Create [Int2D] from column major
  factory String2D.columns(Iterable<Iterable<String>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return new String2D.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = new List<String1D>()..length = numRows;
    for (int i = 0; i < numRows; i++) {
      final row = new List<String>(numCols);
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = new String1D.own(row);
    }
    return new String2D.own(data, names);
  }

  factory String2D.diagonal(Iterable<String> diagonal,
      {Iterable<String> names, String fill}) {
    final ret = new List<String1D>()..length = diagonal.length;
    for (int i = 0; i < diagonal.length; i++) {
      final row = new List<String>.filled(diagonal.length, fill);
      row[i] = diagonal.elementAt(i);
      ret[i] = new String1D.own(row);
    }
    return new String2D.own(ret, names);
  }

  factory String2D.aRow(Iterable<String> row,
          {int repeat = 1, Iterable<String> names}) =>
      new String2D(
          new List<String1DView>.filled(repeat, new String1DView(row),
              growable: true),
          names);

  factory String2D.aCol(Iterable<String> column,
          {int repeat = 1, Iterable<String> names}) =>
      new String2D.columns(
          new ConstantIterable<Iterable<String>>(column, repeat), names);

  factory String2D.genRows(int numRows, Iterable<String> rowMaker(int index)) {
    final rows = <String1D>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new String1D(v));
    }
    return new String2D.own(rows);
  }

  factory String2D.genCols(int numCols, Iterable<String> colMaker(int index)) {
    final List<Iterable<String>> cols = <Iterable<String>>[];
    int rowLen;
    for (int i = 0; i < numCols; i++) {
      final v = colMaker(i);
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new String2D.columns(cols);
  }

  factory String2D.gen(Index2D shape, String maker(int row, int col)) {
    final ret = new String2D.shaped(shape);
    for (int r = 0; r < ret.numRows; r++) {
      for (int c = 0; c < ret.numCols; c++) {
        ret[r][c] = maker(r, c);
      }
    }
    return ret;
  }

  static String2D buildRows<T>(
      Iterable<T> iterable, Iterable<String> rowMaker(T v)) {
    final rows = <String1D>[];
    int colLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = rowMaker(iterable.elementAt(i));
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw new Exception('Size mismatch!');
      rows.add(new String1D(v));
    }
    return new String2D.own(rows);
  }

  static String2D buildCols<T>(
      Iterable<T> iterable, Iterable<String> colMaker(T v)) {
    final List<Iterable<String>> cols = <Iterable<String>>[];
    int rowLen;
    for (int i = 0; i < iterable.length; i++) {
      final v = colMaker(iterable.elementAt(i));
      if (v == null) continue;
      rowLen ??= v.length;
      if (rowLen != v.length) throw new Exception('Size mismatch!');
      cols.add(v);
    }
    return new String2D.columns(cols);
  }

  static String2D build<T>(Iterable<Iterable<T>> data, String maker(T v)) {
    if (data.length == 0) {
      return new String2D.sized(0, 0);
    }

    if (!data.every((i) => i.length == data.first.length)) {
      throw new Exception('Size mismatch!');
    }

    final ret = new String2D.sized(data.length, data.first.length);
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

  Iterator<String1DView> get iterator => _data.iterator;

  covariant String2DCol _col;

  String2DCol get col => _col ??= new String2DCol(this);

  covariant String2DRow _row;

  String2DRow get row => _row ??= new String2DRow(this);

  String1DFix operator [](int i) => _data[i].fixed;

  operator []=(final int i, final Iterable<String> val) {
    if (i > numRows) throw new RangeError.range(i, 0, numRows - 1, 'i');

    if (numRows == 0) {
      final arr = new String1D(val);
      _data.add(arr);
      return;
    }

    if (val.length != numCols) throw new Exception('Invalid size!');

    final arr = new String1D(val);
    if (i == numRows) {
      _data.add(arr);
      return;
    }
    _data[i] = arr;
  }

  /// Sets all elements in the array to given value [v]
  void set(String v) {
    for (int c = 0; c < numRows; c++) {
      for (int r = 0; r < numCols; r++) {
        _data[c][r] = v;
      }
    }
  }

  @override
  void assign(Array2DView<String> other) {
    if (other.shape != shape)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        _data[r][c] = other[r][c];
      }
    }
  }

  @override
  void add(Iterable<String> row) => this[numRows] = row;

  @override
  void addScalar(String v) => _data.add(new String1D.sized(numCols, fill: v));

  @override
  void insert(int index, Iterable<String> row) {
    if (index > numRows) throw new RangeError.range(index, 0, numRows);
    if (row.length != numCols)
      throw new ArgumentError.value(row, 'row', 'Size mismatch!');
    _data.insert(index, new String1D(row));
  }

  String2DView _view;

  String2DView get view => _view ??= new String2DView.own(_data);

  String2DFix _fixed;

  String2DFix get fixed => _fixed ??= new String2DFix.own(_data);

  @override
  Iterable<ArrayFix<String>> get rows => _data;

  @override
  Iterable<ArrayFix<String>> get cols => new ColsListFix<String>(this);

  void reshape(Index2D newShape, {String def}) {
    if (shape == newShape) return;

    if (shape.row > newShape.row) {
      _data.removeRange(newShape.row, shape.row);
    } else {
      for (int i = shape.row; i < newShape.row; i++) {
        _data.add(new String1D.sized(newShape.col, fill: def));
      }
    }

    if (shape.col > newShape.col) {
      for (String1D r in _data) {
        r.removeRange(newShape.col, r.length);
      }
    } else {
      for (String1D r in _data) {
        r.addAll(new String1D.sized(newShape.col - r.length, fill: def));
      }
    }
  }
}
