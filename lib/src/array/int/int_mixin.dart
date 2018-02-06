part of grizzly.series.array.int;

abstract class Int1DViewMixin implements Numeric1DView<int> {
  Int1DView makeView(Iterable<int> newData) => new Int1DView(newData);

  Int1DFix makeFix(Iterable<int> newData) => new Int1DFix(newData);

  Int1D makeArray(Iterable<int> newData) => new Int1D(newData);

  Int1D clone() => new Int1D.copy(this);

  int get min {
    int ret;
    for (int i = 0; i < length; i++) {
      final int d = this[i];
      if (d == null) continue;
      if (ret == null || d < ret) ret = d;
    }
    return ret;
  }

  int get max {
    int ret;
    for (int i = 0; i < length; i++) {
      final int d = this[i];
      if (d == null) continue;
      if (ret == null || d > ret) ret = d;
    }
    return ret;
  }

  Extent<int> get extent {
    int min;
    int max;
    for (int i = 0; i < length; i++) {
      final int d = this[i];
      if (d == null) continue;
      if (max == null || d > max) max = d;
      if (min == null || d < min) min = d;
    }
    return new Extent<int>(min, max);
  }

  int get argMin {
    int ret;
    int min;
    for (int i = 0; i < length; i++) {
      final int d = this[i];
      if (d == null) continue;
      if (min == null || d < min) {
        min = d;
        ret = i;
      }
    }
    return ret;
  }

  int get argMax {
    int ret;
    int max;
    for (int i = 0; i < length; i++) {
      final int d = this[i];
      if (d == null) continue;
      if (max == null || d > max) {
        max = d;
        ret = i;
      }
    }
    return ret;
  }

  int get ptp {
    int min;
    int max;
    for (int i = 0; i < length; i++) {
      final int d = this[i];
      if (d == null) continue;
      if (max == null || d > max) max = d;
      if (min == null || d < min) min = d;
    }

    if (min == null) return null;
    return max - min;
  }

  double get mean {
    if (length == 0) return 0.0;

    int sum = 0;
    for (int i = 0; i < length; i++) {
      final int d = this[i];
      if (d == null) continue;
      sum += d;
    }
    return sum / length;
  }

  int get sum {
    int sum = 0;
    for (int i = 0; i < length; i++) {
      final int d = this[i];
      if (d == null) continue;
      sum += d;
    }
    return sum;
  }

  int get prod {
    int prod = 1;
    for (int i = 0; i < length; i++) {
      final int d = this[i];
      if (d == null) continue;
      prod *= d;
    }
    return prod;
  }

  double average(Iterable<num> weights) {
    if (weights.length != length) {
      throw new Exception('Weights have mismatching length!');
    }
    if (length == 0) return 0.0;

    double sum = 0.0;
    num denom = 0.0;
    for (int i = 0; i < length; i++) {
      final int d = this[i];
      final num w = weights.elementAt(i);
      if (d == null) continue;
      if (w == null) continue;
      sum += d * w;
      denom += w;
    }
    return sum / denom;
  }

  Int1D get cumsum {
    final ret = new Int1D(new Int32List(length));
    int sum = 0;
    for (int i = 0; i < length; i++) {
      final int d = this[i];
      if (d == null) {
        ret[i] = sum;
        continue;
      }
      sum += d;
      ret[i] = sum;
    }
    return ret;
  }

  Int1D get cumprod {
    final ret = new Int1D(new Int32List(length));
    int prod = 1;
    for (int i = 0; i < length; i++) {
      final int d = this[i];
      if (d == null) {
        ret[i] = prod;
        continue;
      }
      prod *= d;
      ret[i] = prod;
    }
    return ret;
  }

  double get variance {
    if (length == 0) return 0.0;

    final double mean = this.mean;
    double ret = 0.0;
    for (int i = 0; i < length; i++) {
      final double val = this[i] - mean;
      ret += val * val;
    }
    return ret / length;
  }

  double get std => math.sqrt(variance);

  Int1D operator -() {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = -this[i];
    return ret;
  }

  Double1D sqrt() {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = math.sqrt(this[i]);
    return ret;
  }

  @override
  Double1D get log {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = math.log(this[i]);
    return ret;
  }

  @override
  Double1D get log10 {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = math.log(this[i]) / math.LN10;
    return ret;
  }

  @override
  Double1D logN(double n) {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = math.log(this[i]) / math.log(n);
    return ret;
  }

  @override
  Double1D get exp {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = math.exp(this[i]);
    return ret;
  }

  int dot(Iterable<num> other) {
    if (length != other.length) throw new Exception('Lengths must match!');

    num ret = 0;
    for (int i = 0; i < length; i++) {
      ret += this[i] * other.elementAt(i);
    }
    return ret.toInt();
  }

  Double1D get toDouble {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].toDouble();
    }
    return ret;
  }

  double cov(Numeric1DView y) {
    if (y.length != length) throw new Exception('Size mismatch!');
    if (length == 0) return 0.0;
    final double meanX = mean;
    final double meanY = y.mean;
    double sum = 0.0;
    for (int i = 0; i < length; i++) {
      sum += (this[i] - meanX) * (y[i] - meanY);
    }
    return sum / length;
  }

  Double1D covMatrix(Numeric2DView y) {
    if (y.numRows != length) throw new Exception('Size mismatch!');
    final double meanX = mean;
    final Double1D meanY = y.col.mean;
    Double1D sum = new Double1D.sized(y.numCols);
    for (int i = 0; i < length; i++) {
      sum += (y.col[i] - meanY) * (this[i] - meanX);
    }
    return sum / length;
  }

  double corrcoef(Numeric1DView y) {
    if (y.length != length) throw new Exception('Size mismatch!');
    return cov(y) / (std * y.std);
  }

  Double1D corrcoefMatrix(Numeric2DView y) {
    if (y.numRows != length) throw new Exception('Size mismatch!');
    return covMatrix(y) / (y.std * std);
  }

  Int2D repeat({int repeat: 1, bool transpose: false}) {
    if (!transpose) {
      return new Int2D.repeatCol(this, repeat + 1);
    } else {
      return new Int2D.repeatRow(this, repeat + 1);
    }
  }

  bool operator ==(other) {
    if (other is! Array<int>) return false;

    if (other is Array<int>) {
      if (length != other.length) return false;
      for (int i = 0; i < length; i++) {
        if (this[i] != other[i]) return false;
      }
      return true;
    }

    return false;
  }

  Int2D to2D() => new Int2D.from([this]);

  Int2D get transpose {
    final ret = new Int2D.sized(length, 1);
    for (int i = 0; i < length; i++) {
      ret[i][0] = this[i];
    }
    return ret;
  }

  @override
  Int1D pickByIndices(ArrayView<int> indices) {
    final ret = new Int1D.sized(indices.length);
    for(int i = 0; i < indices.length; i++) {
      ret[i] = this[indices[i]];
    }
    return ret;
  }

/* TODO
  @override
  IntSeries<int> valueCounts(
      {bool sortByValue: false,
      bool ascending: false,
      bool dropNull: false,
      dynamic name: ''}) {
    final groups = new Map<int, List<int>>();

    for (int i = 0; i < length; i++) {
      final int v = _data[i];
      if (!groups.containsKey(v)) groups[v] = <int>[0];
      groups[v][0]++;
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
}
