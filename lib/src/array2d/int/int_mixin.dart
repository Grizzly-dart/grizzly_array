part of grizzly.series.array2d;

abstract class Int2DMixin implements Numeric2DView<int> {
  List<Int1DView> get _data;

  Int2DView makeView(Iterable<Iterable<int>> newData) => new Int2DView(newData);

  Int2DFix makeFix(Iterable<Iterable<int>> newData) => new Int2DFix(newData);

  Int2D make(Iterable<Iterable<int>> newData) => new Int2D(newData);

  @override
  Array<int> makeArray(Iterable<int> newData) => new Int1D(newData);

  int get numCols {
    if (numRows == 0) return 0;
    return _data.first.length;
  }

  int get numRows => _data.length;

  Int1DView operator [](int i) => _data[i];

  Int2D slice(Index2D start, [Index2D end]) {
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

    final list = <Int1D>[];

    for (int c = start.row; c < end.row; c++) {
      list.add(_data[c].slice(start.col, end.col));
    }

    return new Int2D.own(list);
  }

  int get min {
    if (numRows == 0) return null;
    int min;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final int d = _data[i][j];
        if (d == null) continue;
        if (min == null || d < min) min = d;
      }
    }
    return min;
  }

  int get max {
    if (numRows == 0) return null;
    int max;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final int d = _data[i][j];
        if (d == null) continue;
        if (max == null || d > max) max = d;
      }
    }
    return max;
  }

  Extent<int> get extent {
    if (numRows == 0) return null;
    int min;
    int max;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final int d = _data[i][j];
        if (d == null) continue;
        if (max == null || d > max) max = d;
        if (min == null || d < min) min = d;
      }
    }
    return new Extent<int>(min, max);
  }

  Index2D get argMin {
    Index2D ret;
    int min;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final int d = _data[i][j];
        if (d == null) continue;
        if (min == null || d < min) {
          min = d;
          ret = idx2D(i, j);
        }
      }
    }
    return ret;
  }

  Index2D get argMax {
    Index2D ret;
    int max;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final int d = _data[i][j];
        if (d == null) continue;
        if (max == null || d > max) {
          max = d;
          ret = idx2D(i, j);
        }
      }
    }
    return ret;
  }

  double get mean {
    if (numRows == 0) return 0.0;
    int sum = 0;
    for (int i = 0; i < numRows; i++) {
      sum += _data[i].sum;
    }
    return sum / (numRows * numCols);
  }

  double average(Iterable<Iterable<num>> weights) {
    if (weights.length != numRows)
      throw new ArgumentError.value(weights, 'weights', 'Size mismatch');
    if (numRows == 0) return 0.0;

    final int yL = numCols;

    double sum = 0.0;
    num denom = 0.0;
    for (int i = 0; i < numRows; i++) {
      final weightsI = weights.elementAt(i);

      if (weightsI.length != yL) {
        throw new Exception('Weights have mismatching length!');
      }

      for (int j = 0; j < _data.first.length; j++) {
        final int d = _data[i][j];
        final num w = weightsI.elementAt(j);
        if (d == null) continue;
        if (w == null) continue;
        sum += d * w;
        denom += w;
      }
    }
    return sum / denom;
  }

  Int2D operator +(/* int | Numeric1DView<int> | Int2DArray */ other) {
    if (other is int) {
      Int2D ret = new Int2D.from(_data);
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          ret[r][c] += other;
        }
      }
      return ret;
    } else if (other is Numeric1DView<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.from(_data);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] + other;
      }
      return ret;
    } else if (other is Int2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.from(_data);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] + other[r];
      }
      return ret;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Int2D operator -(/* int | Numeric1DView<int> | Int2DArray */ other) {
    if (other is int) {
      Int2D ret = new Int2D.from(_data);
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          ret[r][c] -= other;
        }
      }
      return ret;
    } else if (other is Numeric1DView<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.from(_data);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] - other;
      }
      return ret;
    } else if (other is Int2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.from(_data);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] - other[r];
      }
      return ret;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Int2D operator *(/* int | Numeric1DView<int> | Int2DArray */ other) {
    if (other is int) {
      Int2D ret = new Int2D.from(_data);
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          ret[r][c] *= other;
        }
      }
      return ret;
    } else if (other is Numeric1DView<int>) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.from(_data);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] * other;
      }
      return ret;
    } else if (other is Int2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.from(_data);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] * other[r];
      }
      return ret;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Double2D operator /(/* int | Numeric1DView | Int2DArray */ other) {
    if (other is num) {
      Double2D ret = new Double2D.fromNum(_data);
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          ret[r][c] /= other;
        }
      }
      return ret;
    } else if (other is Numeric1DView) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Double2D ret = new Double2D.fromNum(_data);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] / other;
      }
      return ret;
    } else if (other is Numeric2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Double2D ret = new Double2D.shaped(shape);
      for (int r = 0; r < numRows; r++) {
        ret[r] = _data[r] / other[r];
      }
      return ret;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  Int2D operator ~/(/* int | Numeric1DView | Int2DArray */ other) {
    if (other is int) {
      Int2D ret = new Int2D.from(_data);
      for (int r = 0; r < numRows; r++) {
        for (int c = 0; c < numCols; c++) {
          ret[r][c] ~/= other;
        }
      }
      return ret;
    } else if (other is Numeric1DView) {
      if (other.length != numCols)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.from(_data);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] ~/ other;
      }
      return ret;
    } else if (other is Int2D) {
      if (shape != other.shape)
        throw new ArgumentError.value(other, 'other', 'Size mismatch!');
      Int2D ret = new Int2D.from(_data);
      for (int r = 0; r < numRows; r++) {
        ret[r] = ret[r] ~/ other[r];
      }
      return ret;
    }

    throw new ArgumentError.value(other, 'other', 'Unsupported type!');
  }

  int get sum {
    if (numRows == 0) return 0;
    int sum = 0;
    for (int i = 0; i < numRows; i++) {
      sum += _data[i].sum;
    }
    return sum;
  }

  Int2D operator -() {
    final ret = new Int2D.sized(numRows, numCols);
    for (int r = 0; r < numRows; r++)
      for (int c = 0; c < numCols; c++) ret[r][c] = -_data[r][c];
    return ret;
  }

  Double2D get log {
    final ret = new Double2D.sized(numRows, numCols);
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) ret[r][c] = math.log(_data[r][c]);
    }
    return ret;
  }

  Double2D get log10 {
    final ret = new Double2D.sized(numRows, numCols);
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++)
        ret[r][c] = math.log(_data[r][c]) / math.LN10;
    }
    return ret;
  }

  Double2D logN(double n) {
    final ret = new Double2D.sized(numRows, numCols);
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++)
        ret[r][c] = math.log(_data[r][c]) / math.log(n);
    }
    return ret;
  }

  Double2D get exp {
    final ret = new Double2D.sized(numRows, numCols);
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) ret[r][c] = math.exp(_data[r][c]);
    }
    return ret;
  }

  Int1D dot(Iterable<num> other) {
    if (numCols != other.length)
      throw new ArgumentError.value(other, 'other', 'Invalid shape!');

    final ret = new Int1D.sized(numRows);
    for (int r = 0; r < numRows; r++) {
      ret[r] = _data[r].dot(other).toInt();
    }
    return ret;
  }

  Int2D get transpose {
    final Int2D ret = new Int2D.sized(numCols, numRows);
    for (int j = 0; j < _data.first.length; j++) {
      for (int i = 0; i < numRows; i++) {
        ret[j][i] = _data[i][j];
      }
    }
    return ret;
  }

  Int1D get diagonal {
    int dim = numCols;
    if (dim > numRows) dim = numRows;

    final ret = new Int1D.sized(dim);
    for (int i = 0; i < dim; i++) {
      ret[i] = _data[i][i];
    }
    return ret;
  }

  Double2D get toDouble => new Double2D.fromNum(_data);

  String toString() {
    final sb = new StringBuffer();

    //TODO print as table
    sb.writeln('Int2D[$numRows][$numCols] [');
    for (int r = 0; r < numRows; r++) {
      sb.write('[');
      for (int c = 0; c < numCols; c++) {
        sb.write('${_data[r][c]}\t\t');
      }
      sb.writeln('],');
    }
    sb.writeln(']');

    return sb.toString();
  }

  double get variance {
    if (numRows == 0) return 0.0;
    final double mean = this.mean;
    double sum = 0.0;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        final double v = _data[i][j] - mean;
        sum += v * v;
      }
    }
    return sum / (numRows * numCols);
  }

  double get std => math.sqrt(variance);

  /* TODO
  IntSeries<int> valueCounts(
      {bool sortByValue: false,
      bool ascending: false,
      bool dropNull: false,
      dynamic name: ''}) {
    final groups = new Map<int, List<int>>();
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        final int v = _data[r][c];
        if (!groups.containsKey(v)) groups[v] = <int>[0];
        groups[v][0]++;
      }
    }
    final ret = new IntSeries<int>.fromMap(groups, name: name);
    // Sort
    if (sortByValue) {
      ret.sortByIndex(ascending: ascending, inplace: true);
    } else {
      ret.sortByValue(ascending: ascending, inplace: true);
    }
    return ret;
  }
  */

  Double2D get covMatrix {
    final ret = new Double2D.sized(numCols, numCols);
    for (int c = 0; c < numCols; c++) {
      ret[c] = col[c].covMatrix(view);
    }
    return ret;
  }

  Double2D get corrcoefMatrix {
    final ret = new Double2D.sized(numCols, numCols);
    for (int c = 0; c < numCols; c++) {
      ret[c] = col[c].corrcoefMatrix(view);
    }
    return ret;
  }
}
