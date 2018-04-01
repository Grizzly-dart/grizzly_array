part of grizzly.series.array2d;

abstract class Double2DViewMixin implements Numeric2DView<double> {
  List<Double1DView> get _data;

  Double2DView makeView(Iterable<Iterable<double>> newData) =>
      new Double2DView(newData);

  Double2DFix makeFix(Iterable<Iterable<double>> newData) =>
      new Double2DFix(newData);

  Double2D make(Iterable<Iterable<double>> newData) => new Double2D(newData);

  @override
  Array<double> makeArray(Iterable<double> newData) => new Double1D(newData);

  int get numCols {
    if (numRows == 0) return 0;
    return _data.first.length;
  }

  int get numRows => _data.length;

  Index2D get shape => new Index2D(numRows, numCols);

  bool get isSquare => numRows == numCols;

  Double1DView operator [](int i) => _data[i];

  Double2D slice(Index2D start, [Index2D end]) {
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

    final list = <Double1D>[];

    for (int c = start.row; c < end.row; c++) {
      list.add(_data[c].slice(start.col, end.col));
    }

    return new Double2D.own(list);
  }

  double get min {
    if (numRows == 0) return null;
    double min;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final double d = _data[i][j];

        if (d == null) continue;

        if (min == null || d < min) min = d;
      }
    }
    return min;
  }

  double get max {
    if (numRows == 0) return null;
    double max;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final double d = _data[i][j];

        if (d == null) continue;

        if (max == null || d > max) max = d;
      }
    }
    return max;
  }

  Extent<double> get extent {
    if (numRows == 0) return null;
    double min;
    double max;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final double d = _data[i][j];

        if (d == null) continue;

        if (max == null || d > max) max = d;
        if (min == null || d < min) min = d;
      }
    }
    return new Extent<double>(min, max);
  }

  Index2D get argMin {
    if (numRows == 0) return null;
    Index2D ret;
    double min;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final double d = _data[i][j];

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
    if (numRows == 0) return null;
    Index2D ret;
    double max;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < _data.first.length; j++) {
        final double d = _data[i][j];

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

    double sum = 0.0;
    for (int i = 0; i < numRows; i++) {
      sum += _data[i].sum;
    }

    return sum / (numRows * numCols);
  }

  double average(Iterable<Iterable<num>> weights) {
    if (weights.length != numRows) {
      throw new Exception('Weights have mismatching length!');
    }
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
        final double d = _data[i][j];
        final num w = weightsI.elementAt(j);
        if (d == null) continue;
        if (w == null) continue;
        sum += d * w;
        denom += w;
      }
    }
    return sum / denom;
  }

  double get sum {
    if (numRows == 0) return 0.0;

    double sum = 0.0;
    for (int i = 0; i < numRows; i++) {
      sum += _data[i].sum;
    }

    return sum;
  }

  Double2D operator +(/* num | Iterable<num> | Numeric2DArray */ other) =>
      toDouble()..addition(other);

  Double2D operator -(/* num | Iterable<num> | Numeric2DArray */ other) =>
      toDouble()..subtract(other);

  Double2D operator *(/* num | Iterable<num> | Numeric2DArray */ other) =>
      toDouble()..multiply(other);

  Double2D operator /(/* num | Iterable<num> | Numeric2DArray */ other) =>
      toDouble()..divide(other);

  Int2D operator ~/(/* int | Iterable<int> | Int2DArray */ other) =>
      toInt()..truncDiv(other);

  Double2D rdiv(/* num | Iterable<num> | Numeric2DArray */ other) =>
      toDouble()..rdivMe(other);

  Double2D operator -() {
    final ret = new Double2D.sized(numRows, numCols);
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
        ret[r][c] = math.log(_data[r][c]) / math.ln10;
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

  Double1D dot(IterView<num> other) {
    if (numCols != other.length)
      throw new ArgumentError.value(other, 'other', 'Invalid shape!');

    final ret = new Double1D.sized(numRows);
    for (int r = 0; r < numRows; r++) {
      ret[r] = _data[r].dot(other);
    }
    return ret;
  }

  Array2D<double> head([int count = 10]) {
    // TODO
    throw new UnimplementedError();
  }

  Array2D<double> tail([int count = 10]) {
    //TODO
    throw new UnimplementedError();
  }

  Array2D<double> sample([int count = 10]) {
    //TODO
    throw new UnimplementedError();
  }

  Double2D get transpose {
    final ret = new Double2D.sized(numCols, numRows);
    for (int j = 0; j < _data.first.length; j++) {
      for (int i = 0; i < numRows; i++) {
        ret[j][i] = _data[i][j];
      }
    }
    return ret;
  }

  Double1D get diagonal {
    int dim = numCols;
    if (dim > numRows) dim = numRows;

    final ret = new Double1D.sized(dim);
    for (int i = 0; i < dim; i++) {
      ret[i] = _data[i][i];
    }
    return ret;
  }

  Int2D toInt() => new Int2D.fromNum(this);

  Double2D toDouble() => new Double2D.from(_data);

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

  Double2D get covMatrix {
    final ret = new Double2D.sized(numCols, numCols);
    for (int c = 0; c < numCols; c++) {
      ret[c] = col[c].stats.covMatrix(view);
    }
    return ret;
  }

  Double2D get corrcoefMatrix {
    final ret = new Double2D.sized(numCols, numCols);
    for (int c = 0; c < numCols; c++) {
      ret[c] = col[c].stats.corrcoefMatrix(view);
    }
    return ret;
  }

  bool isClose(Numeric2D v, {double absTol: 1e-8}) {
    if (v.shape != shape) return false;
    for (int i = 0; i < numRows; i++) {
      if (!_data[i].isClose(v[i].asIterable, absTol: absTol)) return false;
    }
    return true;
  }

  bool isCloseVector(Iterable<num> v, {double absTol: 1e-8}) {
    for (int i = 0; i < numRows; i++) {
      if (!_data[i].isClose(v, absTol: absTol)) return false;
    }
    return true;
  }

  bool isCloseScalar(num v, {double absTol: 1e-8}) {
    for (int i = 0; i < numRows; i++) {
      if (!_data[i].isCloseScalar(v, absTol: absTol)) return false;
    }
    return true;
  }

  Double2D reshaped(Index2D newShape, {double def: 0.0}) {
    if (shape == newShape) return clone();

    List<List<double>> data = _data.map((i) => i.toList()).toList();

    if (shape.row > newShape.row) {
      data.removeRange(newShape.row, shape.row);
    } else {
      for (int i = shape.row; i < newShape.row; i++) {
        data.add(new List<double>.filled(newShape.col, def, growable: true));
      }
    }

    if (shape.col > newShape.col) {
      for (List<double> r in data) {
        r.removeRange(newShape.col, r.length);
      }
    } else {
      for (List<double> r in data) {
        r.addAll(new List<double>.filled(newShape.col - r.length, def));
      }
    }
    return new Double2D(data);
  }

  Double2D clone() => new Double2D.copy(this);

  Double2D matmul(Array2DView<num> other) {
    if (numCols != other.numRows) throw new Exception('Invalid size!');

    Double2D ret = new Double2D.sized(numRows, other.numCols);

    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < other.numCols; j++) {
        double v = 0.0;
        for (int ri = 0; ri < numCols; ri++) {
          v += this[i][ri] * other[ri][j];
        }
        ret[i][j] = v;
      }
    }
    return ret;
  }

  Double2D matmulDiag(ArrayView<num> other) {
    if (numCols != other.length) throw new Exception('Invalid size!');

    Double2D ret = new Double2D.sized(numRows, other.length);

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

  String toDecString() {
    StringBuffer sb = new StringBuffer();
    sb.writeln('[');
    for (int i = 0; i < numRows; i++) {
      sb.write('  ');
      sb.write(this[i].toDecString());
      sb.writeln(',');
    }
    sb.writeln(']');
    return sb.toString();
  }
}
