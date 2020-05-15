part of grizzly.series.array2d;

/*
class Double2DView extends Object
    with
        Array2DViewMixin<double>,
        IterableMixin<Iterable<double>>,
        Double2DViewMixin
    implements Numeric2DView<double> {
  final List<Double1DView> _data;

  final String1DView names;

  Double2DView(Iterable<Iterable<double>> rows, [Iterable<String> names])
      : _data = List<Double1DView>(rows.length),
        names = names != null
            ? String1DView(names, "Names")
            : String1DView.sized(rows.isNotEmpty ? rows.first.length : 0,
                name: 'Names') {
    if (rows.isEmpty) {
      Exceptions.labelLen(0, this.names.length);
      return;
    }
    Exceptions.labelLen(rows.first.length, this.names.length);
    Exceptions.rowsLen(rows);
    for (int i = 0; i < rows.length; i++) {
      _data[i] = Double1DView(rows.elementAt(i));
    }
  }

  Double2DView.own(this._data, [Iterable<String> names])
      : names = names != null
            ? String1DView(names, "Names")
            : String1DView.sized(_data.isNotEmpty ? _data.first.length : 0,
                name: 'Names') {
    Exceptions.labelLen(numCols, this.names.length);
    Exceptions.rowsLen(rows);
  }

  factory Double2DView.fromNums(Iterable<Iterable<num>> rows,
      [Iterable<String> names]) {
    final data = List<Double1DView>(rows.length);
    for (int i = 0; i < rows.length; i++)
      data[i] = Double1DView.fromNums(rows.elementAt(i));
    return Double2DView.own(data, names);
  }

  factory Double2DView.sized(int numRows, int numCols,
      {double fill: 0.0, Iterable<String> names}) {
    final data = List<Double1DView>(numRows);
    for (int i = 0; i < numRows; i++) {
      data[i] = Double1DView.sized(numCols, fill: fill);
    }
    return Double2DView.own(data, names);
  }

  factory Double2DView.shaped(Index2D shape,
          {double fill: 0.0, Iterable<String> names}) =>
      Double2DView.sized(shape.row, shape.col, fill: fill, names: names);

  factory Double2DView.shapedLike(Array2DView like,
          {double fill: 0.0, Iterable<String> names}) =>
      Double2DView.sized(like.numRows, like.numCols, fill: fill, names: names);

  /// Create [Double2DView] from column major
  factory Double2DView.columns(Iterable<Iterable<double>> columns,
      [Iterable<String> names]) {
    if (columns.length == 0) return Double2DView.sized(0, 0, names: names);

    Exceptions.columnsLen(columns);

    final int numRows = columns.first.length;
    final int numCols = columns.length;

    final data = List<Double1DView>(numRows);
    for (int i = 0; i < numRows; i++) {
      final row = List<double>(numCols);
      for (int j = 0; j < numCols; j++) {
        row[j] = columns.elementAt(j).elementAt(i);
      }
      data[i] = Double1DView.own(row);
    }
    return Double2DView.own(data, names);
  }

  factory Double2DView.diagonal(Iterable<double> diagonal,
      {Index2D shape, Iterable<String> names, double fill: 0.0}) {
    shape ??= Index2D(diagonal.length, diagonal.length);
    final ret = Double2DFix.shaped(shape, fill: fill, names: names);
    int length = math.min(math.min(shape.row, shape.col), diagonal.length);
    for (int i = 0; i < length; i++) {
      ret[i][i] = diagonal.elementAt(i);
    }
    return ret.view;
  }

  factory Double2DView.aRow(Iterable<double> row,
      {int repeat = 1, Iterable<String> names}) {
    final data = List<Double1DView>.filled(repeat, null, growable: true);
    if (row is Iterable<double>) {
      for (int i = 0; i < repeat; i++) data[i] = Double1DView(row);
    } else {
      final temp = Double1DView.fromNums(row);
      data[0] = temp;
      for (int i = 1; i < repeat; i++) data[i] = Double1DView(temp);
    }
    return Double2DView.own(data, names);
  }

  factory Double2DView.aCol(Iterable<double> column,
      {int repeat = 1, Iterable<String> names}) {
    if (column is Iterable<double>) {
      return Double2DView.columns(
          ranger.ConstantIterable<Iterable<double>>(column, repeat), names);
    }
    return Double2DView.columns(
        ranger.ConstantIterable<Iterable<double>>(
            Double1DView.fromNums(column), repeat),
        names);
  }

  factory Double2DView.genRows(
      int numRows, Iterable<double> rowMaker(int index)) {
    final rows = <Double1DView>[];
    int colLen;
    for (int i = 0; i < numRows; i++) {
      final v = rowMaker(i);
      if (v == null) continue;
      colLen ??= v.length;
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Double1DView(v));
    }
    return Double2DView.own(rows);
  }

  factory Double2DView.genCols(
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
    return Double2DView.columns(cols);
  }

  factory Double2DView.gen(Index2D shape, double maker(int row, int col)) {
    final ret = Double2DFix.shaped(shape);
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
      if (colLen != v.length) throw Exception('Size mismatch!');
      rows.add(Double1DView(v));
    }
    return Double2DView.own(rows);
  }

  static Double2DView buildCols<T>(
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
    return Double2DView.columns(cols);
  }

  static Double2DView build<T>(Iterable<Iterable<T>> data, double maker(T v)) {
    if (data.length == 0) {
      return Double2DView.sized(0, 0);
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
    return ret.view;
  }

  Iterator<Double1DView> get iterator => _data.iterator;

  Double1DView operator [](int i) => _data[i];

  covariant Double2DColView _col;

  Double2DColView get col => _col ??= Double2DColView(this);

  covariant Double2DRowView _row;

  Double2DRowView get row => _row ??= Double2DRowView(this);

  Double2DView get view => this;

  @override
  Iterable<ArrayView<double>> get rows => _data;

  @override
  Iterable<ArrayView<double>> get cols => ColsListView<double>(this);

  Double1D unique() => super.unique();
}
*/
