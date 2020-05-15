part of grizzly.series.array2d;

abstract class Dynamic2DMixin implements Array2D<dynamic> {
  List<Dynamic1DView> get _data;

  Dynamic2D make(Iterable<Iterable<dynamic>> newData) => Dynamic2D(newData);

  @override
  Array<dynamic> makeArray(Iterable<dynamic> newData) => Dynamic1D(newData);

  int get numCols {
    if (numRows == 0) return 0;
    return _data.first.length;
  }

  int get numRows => _data.length;

  Index2D get shape => Index2D(numRows, numCols);

  bool get isSquare => numRows == numCols;

  Dynamic2D slice(Index2D start, [Index2D end]) {
    final Index2D myShape = shape;
    if (end == null) {
      end = myShape;
    } else {
      if (end < Index2D.zero)
        throw ArgumentError.value(end, 'end', 'Index out of range!');
      if (end >= myShape)
        throw ArgumentError.value(end, 'end', 'Index out of range!');
      if (start > end)
        throw ArgumentError.value(end, 'end', 'Must be greater than start!');
    }
    if (start < Index2D.zero)
      throw ArgumentError.value(start, 'start', 'Index out of range!');
    if (start >= myShape)
      throw ArgumentError.value(start, 'start', 'Index out of range!');

    final list = <Dynamic1D>[];

    for (int c = start.row; c < end.row; c++) {
      list.add(_data[c].slice(start.col, end.col));
    }

    return Dynamic2D.own(list);
  }

  dynamic get min {
    dynamic min;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final dynamic d = _data[i][j];
        if (d == null) continue;
        if (min == null || d.compareTo(min) < 0) min = d; // TODO
      }
    }
    return min;
  }

  dynamic get max {
    dynamic max;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final dynamic d = _data[i][j];
        if (d == null) continue;
        if (max == null || d.compareTo(max) > 0) max = d; // TODO
      }
    }
    return max;
  }

  Index2D get argMin {
    Index2D ret;
    dynamic min;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final dynamic d = _data[i][j];
        if (d == null) continue;
        if (min == null || d.compareTo(min) < 0) {
          // TODO
          min = d;
          ret = idx2D(i, j);
        }
      }
    }
    return ret;
  }

  Index2D get argMax {
    Index2D ret;
    dynamic max;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final dynamic d = _data[i][j];
        if (d == null) continue;
        if (max == null || d.compareTo(max) > 0) {
          // TODO
          max = d;
          ret = idx2D(i, j);
        }
      }
    }
    return ret;
  }

  Dynamic2D get transpose {
    final ret = Dynamic2D.sized(numCols, numRows);
    for (int j = 0; j < _data.first.length; j++) {
      for (int i = 0; i < numRows; i++) {
        ret[j][i] = _data[i][j];
      }
    }
    return ret;
  }

  Dynamic1D get diagonal {
    int dim = numCols;
    if (dim > numRows) dim = numRows;

    final ret = Dynamic1D.sized(dim);
    for (int i = 0; i < dim; i++) {
      ret[i] = _data[i][i];
    }
    return ret;
  }

  Dynamic2D reshaped(Index2D newShape, {dynamic def}) =>
      clone()..reshape(newShape, def: def);

  Dynamic2D clone() => Dynamic2D(this);
}
