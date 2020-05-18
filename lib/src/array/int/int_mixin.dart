part of grizzly.array.int;

abstract class Int1DViewMixin implements Numeric1DView<int> {
  Int1DView makeView(Iterable<int> newData, [String name]) =>
      Int1DView(newData, name);

  Int1DFix makeFix(Iterable<int> newData, [String name]) =>
      Int1DFix(newData, name);

  Int1D makeArray(Iterable<int> newData, [String name]) => Int1D(newData, name);

  Int1D clone({String name}) => Int1D(this, name);

  Int1D operator -() {
    final ret = Int1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = -this[i];
    return ret;
  }

  Int1D operator +(
          /* num | Iterable<num> | Numeric2D<int> */ other) =>
      toInt()..addition(other);

  Int1D operator -(/* num | Iterable<num> */ other) => toInt()..subtract(other);

  Int1D operator *(/* num | Iterable<num> */ other) => toInt()..multiply(other);

  Double1D operator /(/* num | Iterable<num> */ other) =>
      toDouble()..divide(other);

  Int1D operator ~/(/* num | Iterable<num> */ other) =>
      toInt()..truncDiv(other);

  Double1D rdiv(/* num | Iterable<num> */ other) => toDouble()..rdivMe(other);

  @override
  int compareValue(int a, int b) => a.compareTo(b);

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

  int get min => stats.min;

  int get max => stats.max;

  ranger.Extent<int> get extent => stats.extent;

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

  int get ptp => stats.ptp;

  double get mean => stats.mean;

  int get sum => stats.sum;

  int get prod => stats.prod;

  double average(Iterable<num> weights) => stats.average(weights);

  Int1D get cumsum {
    final ret = Int1D.sized(length);
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
    final ret = Int1D.sized(length);
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

  Double1D sqrt() {
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

  int dot(Iterable<num> other) {
    checkLengths(this, other, subject: 'other');

    num ret = 0;
    for (int i = 0; i < length; i++) {
      ret += this[i] * other.elementAt(i);
    }
    return ret.toInt();
  }

  Double1D toDouble() => Double1D.fromNums(this);

  Int1D toInt() => Int1D(this);

  Int2D diagonal({Index2D shape, num def: 0}) =>
      Int2D.diagonal(this, shape: shape, fill: def?.toInt());

  Int2D to2D({int repeat: 1, bool t: false}) {
    if (!t) {
      return Int2D.aCol(this, repeat: repeat);
    } else {
      return Int2D.aRow(this, repeat: repeat);
    }
  }

  @override
  Int1D pickByIndices(Iterable<int> indices) {
    final ret = Int1D.sized(indices.length);
    for (int i = 0; i < indices.length; i++) {
      ret[i] = this[indices.elementAt(i)];
    }
    return ret;
  }

  Int1D abs() {
    final ret = Int1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = this[i].abs();
    return ret;
  }

  Int1D selectByMask(Iterable<bool> mask) {
    if (mask.length != length) throw Exception('Length mismatch!');

    int retLength = mask.where((v) => v).length;
    final ret = List<int>()..length = retLength;
    int idx = 0;
    for (int i = 0; i < mask.length; i++) {
      if (mask.elementAt(i)) ret[idx++] = this[i];
    }
    return Int1D.own(ret);
  }

  bool operator ==(other) {
    if (other is Iterable<num>) {
      if (other.length != length) return false;
      for (int i = 0; i < length; i++) {
        if (this[i] != other.elementAt(i)) return false;
      }
      return true;
    }
    return false;
  }

  @override
  Double1D sin() {
    final ret = toDouble();
    for (int i = 0; i < length; i++) ret[i] = math.sin(ret[i]);
    return ret;
  }

  List<ranger.Extent<int>> generateBins(
      {ranger.Extent<int> range, int count = 10}) {
    range ??= this.extent;
    final edges = ranger.linspace<int>(range.lower, range.upper, count);
    return ranger.Extent.consecutive(edges);
  }

  @override
  IntSeries<ranger.Extent<int>> histogram(/* Iterable<E> | int */ bins,
      {ranger.Extent<int> range, Iterable<int> weights}) {
    if (bins is int) {
      bins = generateBins(range: range, count: bins);
    } else if (bins is! Iterable<int>) {
      throw Exception('bins must be integer or Iterable<int>');
    }

    final Iterable<ranger.Extent<int>> binExtents = bins;
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
