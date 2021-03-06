part of grizzly.array2d;

abstract class Bool2DViewMixin implements Array2D<bool> {
  List<Bool1DView> get _data;

  Bool2D make(Iterable<Iterable<bool>> newData) => Bool2D(newData);

  @override
  Array<bool> makeArray(Iterable<bool> newData) => Bool1D(newData);

  int get numCols {
    if (numRows == 0) return 0;
    return _data.first.length;
  }

  int get numRows => _data.length;

  Index2D get shape => Index2D(numRows, numCols);

  bool get isSquare => numRows == numCols;

  Bool2D slice(Index2D start, [Index2D end]) {
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

    final list = <Bool1D>[];

    for (int c = start.row; c < end.row; c++) {
      list.add(_data[c].slice(start.col, end.col));
    }

    return Bool2D.own(list);
  }

  bool get min {
    bool min;
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        final bool d = _data[r][c];
        if (d == null) continue;
        if (!d)
          return false;
        else
          min = true;
      }
    }
    return min;
  }

  bool get max {
    bool max;
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        final bool d = _data[r][c];
        if (d == null) continue;
        if (d)
          return true;
        else
          max = false;
      }
    }
    return max;
  }

  Index2D get argMin {
    Index2D ret;
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        final bool d = _data[r][c];
        if (d == null) continue;
        if (!d)
          return Index2D(r, c);
        else
          ret ??= Index2D(r, c);
      }
    }
    return ret;
  }

  Index2D get argMax {
    Index2D ret;
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        final bool d = _data[r][c];
        if (d == null) continue;
        if (d)
          return Index2D(r, c);
        else
          ret ??= Index2D(r, c);
      }
    }
    return ret;
  }

  double get mean {
    if (numRows == 0) return 0.0;
    double sum = 0.0;
    for (int i = 0; i < numRows; i++) {
      sum += _data[i].sum;
    }
    return sum / (numRows * numCols);
  }

  double get sum {
    if (numRows == 0) return 0.0;
    double sum = 0.0;
    for (int i = 0; i < numRows; i++) {
      sum += _data[i].sum;
    }
    return sum;
  }

  Array2D<bool> head([int count = 10]) {
    // TODO
    throw UnimplementedError();
  }

  Array2D<bool> tail([int count = 10]) {
    //TODO
    throw UnimplementedError();
  }

  Array2D<bool> sample([int count = 10]) {
    //TODO
    throw UnimplementedError();
  }

  Bool2D get transpose {
    final ret = Bool2D.sized(numCols, numRows);
    for (int j = 0; j < _data.first.length; j++) {
      for (int i = 0; i < numRows; i++) {
        ret[j][i] = _data[i][j];
      }
    }
    return ret;
  }

  Bool1D get diagonal {
    int dim = numCols;
    if (dim > numRows) dim = numRows;

    final ret = Bool1D.sized(dim);
    for (int i = 0; i < dim; i++) {
      ret[i] = _data[i][i];
    }
    return ret;
  }

  bool get isTrue {
    for (int i = 0; i < numRows; i++) {
      if (!_data[i].isTrue) return false;
    }
    return true;
  }

  bool get isFalse {
    for (int i = 0; i < numRows; i++) {
      if (!_data[i].isFalse) return false;
    }
    return true;
  }

  Bool2D reshaped(Index2D newShape, {bool def = false}) =>
      clone()..reshape(newShape, def: def);

  Bool2D clone() => Bool2D(this);
}
