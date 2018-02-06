part of grizzly.series.array.double;

abstract class Double1DViewMixin implements Numeric1DView<double> {
  Double1DView makeView(Iterable<double> newData) => new Double1DView(newData);

  Double1DFix makeFix(Iterable<double> newData) => new Double1DFix(newData);

  Double1D makeArray(Iterable<double> newData) => new Double1D(newData);

  Double1D clone() => new Double1D.copy(this);

  Int1DFix operator ~/(/* num | Iterable<num> */ other) {
    if (other is Numeric1D) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
    } else if (other is num) {
      // Nothing here
    } else if (other is Iterable<num>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      final ret = new Int1D.sized(length);
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] ~/ other.elementAt(i).toInt();
      }
      return ret;
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    final ret = new Int1D.sized(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] ~/ other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] ~/ other[i];
      }
    }
    return ret;
  }

  int count(double v, {double absTol: 0.0}) {
    final double vLow = v - absTol;
    final double vHigh = v + absTol;
    int ret = 0;
    for (double item in iterable) {
      if (item > vLow && item < vHigh) ret++;
    }
    return ret;
  }

  double get min {
    double ret;
    for (int i = 0; i < length; i++) {
      final double d = this[i];

      if (d == null) continue;

      if (ret == null || d < ret) ret = d;
    }
    return ret;
  }

  double get max {
    double ret;
    for (int i = 0; i < length; i++) {
      final double d = this[i];

      if (d == null) continue;

      if (ret == null || d > ret) ret = d;
    }
    return ret;
  }

  Extent<double> get extent {
    double min;
    double max;
    for (int i = 0; i < length; i++) {
      final double d = this[i];

      if (d == null) continue;

      if (max == null || d > max) max = d;
      if (min == null || d < min) min = d;
    }
    return new Extent<double>(min, max);
  }

  int get argMin {
    int ret;
    double min;
    for (int i = 0; i < length; i++) {
      final double d = this[i];

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
    double max;
    for (int i = 0; i < length; i++) {
      final double d = this[i];

      if (d == null) continue;

      if (max == null || d > max) {
        max = d;
        ret = i;
      }
    }
    return ret;
  }

  double get ptp {
    double min;
    double max;
    for (int i = 0; i < length; i++) {
      final double d = this[i];

      if (d == null) continue;

      if (max == null || d > max) max = d;
      if (min == null || d < min) min = d;
    }

    if (min == null) return null;
    return max - min;
  }

  double get mean {
    if (length == 0) return 0.0;

    double sum = 0.0;
    for (int i = 0; i < length; i++) {
      final double d = this[i];
      if (d == null) continue;
      sum += d;
    }
    return sum / length;
  }

  double get sum {
    double sum = 0.0;
    for (int i = 0; i < length; i++) {
      final double d = this[i];
      if (d == null) continue;
      sum += d;
    }
    return sum;
  }

  double get prod {
    double prod = 1.0;
    for (int i = 0; i < length; i++) {
      final double d = this[i];
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
      final double d = this[i];
      final int w = weights.elementAt(i);
      if (d == null) continue;
      if (w == null) continue;
      sum += d * w;
      denom += w;
    }
    return sum / denom;
  }

  Double1D get cumsum {
    final Double1D ret = new Double1D(new Float64List(length));
    double sum = 0.0;
    for (int i = 0; i < length; i++) {
      final double d = this[i];
      if (d == null) {
        ret[i] = sum;
        continue;
      }
      sum += d;
      ret[i] = sum;
    }
    return ret;
  }

  Double1D get cumprod {
    final Double1D ret = new Double1D(new Float64List(length));
    double prod = 1.0;
    for (int i = 0; i < length; i++) {
      final double d = this[i];
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

  Double1D operator -() {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = -this[i];
    return ret;
  }

  Double1DFix sqrt() {
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

  Double1DFix floorToDouble() {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].floorToDouble();
    }
    return ret;
  }

  Double1DFix ceilToDouble() {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].ceilToDouble();
    }
    return ret;
  }

  Int1D floor() {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].floor();
    }
    return ret;
  }

  Int1D ceil() {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].ceil();
    }
    return ret;
  }

  Double2D to2D() => new Double2D.from([this]);

  @override
  Double2D get transpose {
    final ret = new Double2D.sized(length, 1);
    for (int i = 0; i < length; i++) {
      ret[i][0] = this[i];
    }
    return ret;
  }

  Double1D get toDouble => clone();

  Double2D repeat({int repeat: 1, bool transpose: false}) {
    if (!transpose) {
      return new Double2D.repeatCol(this, repeat + 1);
    } else {
      return new Double2D.repeatRow(this, repeat + 1);
    }
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

  bool isAllClose(Iterable<num> v, {double absTol: 1e-8}) {
    if (length != v.length) return false;
    for (int i = 0; i < length; i++) {
      if ((this[i] - v.elementAt(i)).abs() > absTol) return false;
    }
    return true;
  }

  bool isAllCloseScalar(num v, {double absTol: 1e-8}) {
    for (int i = 0; i < length; i++) {
      if ((this[i] - v).abs() > absTol) return false;
    }
    return true;
  }

  double dot(Iterable<num> other) {
    if (length != other.length) throw new Exception('Lengths must match!');

    double ret = 0.0;
    for (int i = 0; i < length; i++) {
      ret += this[i] * other.elementAt(i);
    }
    return ret;
  }

  Int1D toInt() {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].toInt();
    }
    return ret;
  }

  @override
  Double1D pickByIndices(ArrayView<int> indices) {
    final ret = new Double1D.sized(indices.length);
    for (int i = 0; i < indices.length; i++) {
      ret[i] = this[indices[i]];
    }
    return ret;
  }
}
