part of grizzly.array2d;

abstract class Int2DViewMixin implements Numeric2D<int> {
  List<Int1DView> get _data;

  Int2D make(Iterable<Iterable<int>> newData) => Int2D(newData);

  @override
  Array<int> makeArray(Iterable<int> newData) => Int1D(newData);

  int get numCols {
    if (numRows == 0) return 0;
    return _data.first.length;
  }

  int get numRows => _data.length;

  Int2D slice(Index2D start, [Index2D end]) {
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

    final list = <Int1D>[];

    for (int c = start.row; c < end.row; c++) {
      list.add(_data[c].slice(start.col, end.col));
    }

    return Int2D.own(list);
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

  ranger.Extent<int> get extent {
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
    return ranger.Extent<int>(min, max);
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
          ret = Index2D(i, j);
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
          ret = Index2D(i, j);
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
      throw ArgumentError.value(weights, 'weights', 'Size mismatch');
    if (numRows == 0) return 0.0;

    final int yL = numCols;

    double sum = 0.0;
    num denom = 0.0;
    for (int i = 0; i < numRows; i++) {
      final weightsI = weights.elementAt(i);

      if (weightsI.length != yL) {
        throw Exception('Weights have mismatching length!');
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

  Int2D operator +(
          /* num | Iterable<num> | Numeric2D<int> */ other) =>
      toInt()..addition(other);

  Int2D operator -(/* int | Numeric1DView<int> | Int2DArray */ other) =>
      toInt()..subtract(other);

  Int2D operator *(/* int | Numeric1DView<int> | Int2DArray */ other) =>
      toInt()..multiply(other);

  Double2D operator /(/* int | Numeric1DView | Int2DArray */ other) =>
      toDouble()..divide(other);

  Int2D operator ~/(/* int | Numeric1DView | Int2DArray */ other) =>
      toInt()..truncDiv(other);

  Double2D rdiv(/* num | Iterable<num> | Numeric2DArray */ other) =>
      toDouble()..rdivMe(other);

  int get sum {
    if (numRows == 0) return 0;
    int sum = 0;
    for (int i = 0; i < numRows; i++) {
      sum += _data[i].sum;
    }
    return sum;
  }

  Int2D operator -() {
    final ret = Int2D.sized(numRows, numCols);
    for (int r = 0; r < numRows; r++)
      for (int c = 0; c < numCols; c++) ret[r][c] = -_data[r][c];
    return ret;
  }

  Double2D get log {
    final ret = Double2D.sized(numRows, numCols);
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) ret[r][c] = math.log(_data[r][c]);
    }
    return ret;
  }

  Double2D get log10 {
    final ret = Double2D.sized(numRows, numCols);
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++)
        ret[r][c] = math.log(_data[r][c]) / math.ln10;
    }
    return ret;
  }

  Double2D logN(double n) {
    final ret = Double2D.sized(numRows, numCols);
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++)
        ret[r][c] = math.log(_data[r][c]) / math.log(n);
    }
    return ret;
  }

  Double2D get exp {
    final ret = Double2D.sized(numRows, numCols);
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) ret[r][c] = math.exp(_data[r][c]);
    }
    return ret;
  }

  Int1D dot(Iterable<num> other) {
    if (numCols != other.length)
      throw ArgumentError.value(other, 'other', 'Invalid shape!');

    final ret = Int1D.sized(numRows);
    for (int r = 0; r < numRows; r++) {
      ret[r] = _data[r].dot(other).toInt();
    }
    return ret;
  }

  Int2D get transpose {
    final Int2D ret = Int2D.sized(numCols, numRows);
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

    final ret = Int1D.sized(dim);
    for (int i = 0; i < dim; i++) {
      ret[i] = _data[i][i];
    }
    return ret;
  }

  Int2D toInt() => Int2D(_data);

  Double2D toDouble() => Double2D.fromNums(_data);

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
    final groups = Map<int, List<int>>();
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        final int v = _data[r][c];
        if (!groups.containsKey(v)) groups[v] = <int>[0];
        groups[v][0]++;
      }
    }
    final ret = IntSeries<int>.fromMap(groups, name: name);
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
    final ret = Double2D.sized(numCols, numCols);
    for (int c = 0; c < numCols; c++) {
      ret[c] = col[c].stats.covMatrix(this);
    }
    return ret;
  }

  Double2D get corrcoefMatrix {
    final ret = Double2D.sized(numCols, numCols);
    for (int c = 0; c < numCols; c++) {
      ret[c] = col[c].stats.corrcoefMatrix(this);
    }
    return ret;
  }

  Int2D reshaped(Index2D newShape, {int def: 0}) =>
      clone()..reshape(newShape, def: def);

  Int2D clone() => Int2D(this);

  Int2D matmul(Array2D<int> other) {
    if (numCols != other.numRows) throw Exception('Invalid size!');

    Int2D ret = Int2D.sized(numRows, other.numCols);

    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < other.numCols; j++) {
        int v = 0;
        for (int ri = 0; ri < numCols; ri++) {
          v += this[i][ri] * other[ri][j];
        }
        ret[i][j] = v;
      }
    }
    return ret;
  }

  Int2D matmulDiag(ArrayView<int> other) {
    if (numCols != other.length) throw Exception('Invalid size!');

    Int2D ret = Int2D.sized(numRows, other.length);

    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < other.length; j++) {
        ret[i][j] = this[i][j] * other[j];
      }
    }
    return ret;
  }

  bool operator ==(/* Numeric2D */ other) {
    if (other is Numeric2D) {
      if (shape != other.shape) return false;
      for (int i = 0; i < numRows; i++) {
        if (this[i] != other[i]) return false;
      }
      return true;
    }
    return false;
  }

  Double2D sin() {
    final ret = toDouble();
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) ret[i][j] = math.sin(ret[i][j]);
    }
    return ret;
  }
}
