part of grizzly.array.double;

abstract class Double1DViewMixin implements Numeric1DView<double> {
  Double1DView makeView(Iterable<double> newData, [String name]) =>
      Double1DView(newData, name);

  Double1DFix makeFix(Iterable<double> newData, [String name]) =>
      Double1DFix(newData, name);

  Double1D makeArray(Iterable<double> newData, [String name]) =>
      Double1D(newData, name);

  Double1D clone({String name}) => Double1D(this, name);

  Double1D operator -() {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = -this[i];
    return ret;
  }

  Double1D operator +(/* num | Numeric1DView | Numeric2DView */ other) =>
      toDouble()..addition(other);

  Double1D operator -(/* num | Numeric1DView | Numeric2DView */ other) =>
      toDouble()..subtract(other);

  Double1D operator *(/* num | Numeric1DView | Numeric2DView */ other) =>
      toDouble()..multiply(other);

  Double1D operator /(/* num | Numeric1DView | Numeric2DView */ other) =>
      toDouble()..divide(other);

  Int1D operator ~/(/* num | Numeric1DView | Numeric2DView */ other) =>
      toInt()..truncDiv(other);

  Double1D rdiv(/* num | Numeric1DView | Numeric2DView */ other) =>
      toDouble()..rdivMe(other);

  @override
  int compareValue(double a, double b) => a.compareTo(b);

  Bool1D operator <(/* Numeric1D | num */ other) {
    final ret = Bool1D.sized(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] < other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] < other[i];
      }
    } else {
      throw UnsupportedError('Type not supported!');
    }
    return ret;
  }

  Bool1D operator <=(/* Numeric1D | num */ other) {
    final ret = Bool1D.sized(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] <= other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] <= other[i];
      }
    } else {
      throw UnsupportedError('Type not supported!');
    }
    return ret;
  }

  Bool1D operator >(/* Numeric1D | num */ other) {
    final ret = Bool1D.sized(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] > other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] > other[i];
      }
    } else {
      throw UnsupportedError('Type not supported!');
    }
    return ret;
  }

  Bool1D operator >=(/* Numeric1D | num */ other) {
    final ret = Bool1D.sized(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] >= other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] >= other[i];
      }
    } else {
      throw UnsupportedError('Type not supported!');
    }
    return ret;
  }

  int count(double v, {double absTol: 1e-8}) {
    final double vLow = v - absTol;
    final double vHigh = v + absTol;
    int ret = 0;
    for (double item in this) {
      if (item > vLow && item < vHigh) ret++;
    }
    return ret;
  }

  double get min => stats.min;

  double get max => stats.max;

  ranger.Extent<double> get extent => stats.extent;

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

  double get ptp => stats.ptp;

  double get mean => stats.mean;

  double get sum => stats.sum;

  double get prod => stats.prod;

  double average(Iterable<num> weights) => stats.average(weights);

  Double1D get cumsum {
    final Double1D ret = Double1D.sized(length);
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
    final Double1D ret = Double1D.sized(length);
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

  double get variance => stats.variance;

  double get std => math.sqrt(variance);

  Double1DFix sqrt() {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = math.sqrt(this[i]);
    return ret;
  }

  @override
  Double1D get log {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = math.log(this[i]);
    return ret;
  }

  @override
  Double1D get log10 {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = math.log(this[i]) / math.ln10;
    return ret;
  }

  @override
  Double1D logN(double n) {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = math.log(this[i]) / math.log(n);
    return ret;
  }

  @override
  Double1D get exp {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = math.exp(this[i]);
    return ret;
  }

  Double1DFix floorToDouble() {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].floorToDouble();
    }
    return ret;
  }

  Double1DFix ceilToDouble() {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].ceilToDouble();
    }
    return ret;
  }

  Int1D floor() {
    final ret = Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].floor();
    }
    return ret;
  }

  Int1D ceil() {
    final ret = Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].ceil();
    }
    return ret;
  }

  Double2D to2D({int repeat: 1, bool t: false}) {
    if (!t) {
      return Double2D.aCol(this, repeat: repeat);
    } else {
      return Double2D.aRow(this, repeat: repeat);
    }
  }

  Double1D toDouble() => Double1D(this);

  Double2D diagonal({Index2D shape, num def: 0}) =>
      Double2D.diagonal(this, shape: shape, fill: def?.toDouble());

  bool isClose(Iterable<num> v, {double absTol: 1e-8}) {
    if (length != v.length) return false;
    for (int i = 0; i < length; i++) {
      if ((this[i] - v.elementAt(i)).abs() > absTol) return false;
    }
    return true;
  }

  bool isCloseScalar(num v, {double absTol: 1e-8}) {
    for (int i = 0; i < length; i++) {
      if ((this[i] - v).abs() > absTol) return false;
    }
    return true;
  }

  double dot(Iterable<num> other) {
    if (length != other.length) throw Exception('Lengths must match!');

    double ret = 0.0;
    for (int i = 0; i < length; i++) {
      ret += this[i] * other.elementAt(i);
    }
    return ret;
  }

  Int1D toInt() {
    final ret = Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].toInt();
    }
    return ret;
  }

  @override
  Double1D pickByIndices(Iterable<int> indices) {
    final ret = Double1D.sized(indices.length);
    for (int i = 0; i < indices.length; i++) {
      ret[i] = this[indices.elementAt(i)];
    }
    return ret;
  }

  @override
  bool contains(final Object value, {double absTol: 1e-8}) {
    if (value is num) {
      double vLow = value - absTol;
      double vHigh = value + absTol;
      for (double el in this) {
        if (el > vLow && el < vHigh) return true;
      }
    }
    return false;
  }

  @override
  Double1DFix abs() {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = this[i].abs();
    return ret;
  }

  Double1D selectByMask(Iterable<bool> mask) {
    if (mask.length != length) throw Exception('Length mismatch!');

    int retLength = mask.where((v) => v).length;
    final ret = List<double>()..length = retLength;
    int idx = 0;
    for (int i = 0; i < mask.length; i++) {
      if (mask.elementAt(i)) ret[idx++] = this[i];
    }
    return Double1D.own(ret);
  }

  bool operator ==(/* Iterable<num> */ other) {
    if (other is Iterable<num>) {
      if (other.length != length) return false;
      for (int i = 0; i < length; i++) {
        if (this[i] != other.elementAt(i)) return false;
      }
      return true;
    }
    return false;
  }

  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write('[');
    for (int i = 0; i < length; i++) {
      sb.write(' ');
      sb.write(this[i]);
      sb.write(',');
    }
    sb.write(']');
    return sb.toString();
  }

  @override
  Double1D sin() {
    final ret = toDouble();
    for (int i = 0; i < length; i++) ret[i] = math.sin(ret[i]);
    return ret;
  }

  List<ranger.Extent<double>> generateBins(
      {ranger.Extent<double> range, int count = 10}) {
    range ??= this.extent;
    final edges = ranger.linspace<double>(range.lower, range.upper, count);
    return ranger.Extent.consecutive(edges);
  }

  @override
  IntSeries<ranger.Extent<double>> histogram(/* Iterable<E> | int */ bins,
      {ranger.Extent<double> range, Iterable<int> weights}) {
    if (bins is int) {
      bins = generateBins(range: range, count: bins);
    } else if (bins is! Iterable<double>) {
      throw Exception('bins must be integer or Iterable<double>');
    }

    final Iterable<ranger.Extent<double>> binExtents = bins;
    final counts = List<int>.filled(binExtents.length, 0);

    int dataIndex = -1;
    for (final v in this) {
      dataIndex++;

      if (range != null) {
        if (!range.has(v)) continue;
      }

      int extentIndex = -1;
      for (final e in binExtents) {
        extentIndex++;
        if (!e.has(v)) continue;

        if (weights == null) {
          counts[extentIndex]++;
        } else {
          int inc = weights.elementAt(dataIndex) ?? 1;
          counts[extentIndex] += inc;
        }
        break;
      }
    }

    return IntSeries(counts, labels: binExtents);
  }
}
