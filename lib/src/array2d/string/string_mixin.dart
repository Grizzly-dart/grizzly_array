part of grizzly.series.array2d;

abstract class String2DMixin implements Array2DView<String> {
  List<String1DView> get _data;

  String2DColView get col;

  String2DRowView get row;

  String2DView get view;

  String2DView makeView(Iterable<Iterable<String>> newData) =>
      new String2DView(newData);

  String2DFix makeFix(Iterable<Iterable<String>> newData) =>
      new String2DFix(newData);

  String2D make(Iterable<Iterable<String>> newData) => new String2D(newData);

  @override
  Array<String> makeArray(Iterable<String> newData) => new String1D(newData);

  Iterable<Iterable<String>> get iterable => _data.map((a) => a.asIterable);

  Iterator<ArrayView<String>> get iterator => _data.iterator;

  int get numCols {
    if (numRows == 0) return 0;
    return _data.first.length;
  }

  int get numRows => _data.length;

  Index2D get shape => new Index2D(numRows, numCols);

  bool get isSquare => numRows == numCols;

  String1DView operator [](int i) => _data[i].view;

  String2D slice(Index2D start, [Index2D end]) {
    final Index2D myShape = shape;
    if (end == null) {
      end = myShape;
    } else {
      if (end < Index2D.zero)
        throw new ArgumentError.value(end, 'end', 'Index out of range!');
      if (end >= myShape)
        throw new ArgumentError.value(end, 'end', 'Index out of range!');
      if (start > end)
        throw new ArgumentError.value(
            end, 'end', 'Must be greater than start!');
    }
    if (start < Index2D.zero)
      throw new ArgumentError.value(start, 'start', 'Index out of range!');
    if (start >= myShape)
      throw new ArgumentError.value(start, 'start', 'Index out of range!');

    final list = <String1D>[];

    for (int c = start.row; c < end.row; c++) {
      list.add(_data[c].slice(start.col, end.col));
    }

    return new String2D.own(list);
  }

  String get min {
    String min;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final String d = _data[i][j];
        if (d == null) continue;
        if (min == null || d.compareTo(min) < 0) min = d;
      }
    }
    return min;
  }

  String get max {
    String max;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final String d = _data[i][j];
        if (d == null) continue;
        if (max == null || d.compareTo(max) > 0) max = d;
      }
    }
    return max;
  }

  Index2D get argMin {
    Index2D ret;
    String min;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final String d = _data[i][j];
        if (d == null) continue;
        if (min == null || d.compareTo(min) < 0) {
          min = d;
          ret = idx2D(i, j);
        }
      }
    }
    return ret;
  }

  Index2D get argMax {
    Index2D ret;
    String max;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final String d = _data[i][j];
        if (d == null) continue;
        if (max == null || d.compareTo(max) > 0) {
          max = d;
          ret = idx2D(i, j);
        }
      }
    }
    return ret;
  }

  Array2D<String> head([int count = 10]) {
    // TODO
    throw new UnimplementedError();
  }

  Array2D<String> tail([int count = 10]) {
    //TODO
    throw new UnimplementedError();
  }

  Array2D<String> sample([int count = 10]) {
    //TODO
    throw new UnimplementedError();
  }

  String2D get transpose {
    final ret = new String2D.sized(numCols, numRows);
    for (int j = 0; j < _data.first.length; j++) {
      for (int i = 0; i < numRows; i++) {
        ret[j][i] = _data[i][j];
      }
    }
    return ret;
  }

  String1D get diagonal {
    int dim = numCols;
    if (dim > numRows) dim = numRows;

    final ret = new String1D.sized(dim);
    for (int i = 0; i < dim; i++) {
      ret[i] = _data[i][i];
    }
    return ret;
  }

  String2D reshaped(Index2D newShape, {String def}) =>
      clone()..reshape(newShape, def: def);

  String2D clone() => new String2D.copy(this);
}
