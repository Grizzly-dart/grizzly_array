part of grizzly.series.array.int;

abstract class Int1DViewMixin implements Numeric1DView<int> {
  Int1DView makeView(Iterable<int> newData, [String name]) =>
      new Int1DView(newData, name);

  Int1DFix makeFix(Iterable<int> newData, [String name]) =>
      new Int1DFix(newData, name);

  Int1D makeArray(Iterable<int> newData, [String name]) =>
      new Int1D(newData, name);

  Int1D clone({String name}) => new Int1D(this, name);

  Int1D operator -() {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = -this[i];
    return ret;
  }

  Int1D operator +(
          /* num | IterView<num> | Iterable<num> | Numeric2D<int> */ other) =>
      toInt()..addition(other);

  Int1D operator -(/* num | IterView<num> | Iterable<num> */ other) =>
      toInt()..subtract(other);

  Int1D operator *(/* num | IterView<num> | Iterable<num> */ other) =>
      toInt()..multiply(other);

  Double1D operator /(/* num | IterView<num> | Iterable<num> */ other) =>
      toDouble()..divide(other);

  Int1D operator ~/(/* num | IterView<num> | Iterable<num> */ other) =>
      toInt()..truncDiv(other);

  Double1D rdiv(/* num | IterView<num> | Iterable<num> */ other) =>
      toDouble()..rdivMe(other);

  @override
  int compareValue(int a, int b) => a.compareTo(b);

  Bool1D operator <(/* Numeric1D | num */ other) {
    final ret = new Bool1D.sized(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] < other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] < other[i];
      }
    } else {
      throw new UnsupportedError('Type not supported!');
    }
    return ret;
  }

  Bool1D operator <=(/* Numeric1D | num */ other) {
    final ret = new Bool1D.sized(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] <= other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] <= other[i];
      }
    } else {
      throw new UnsupportedError('Type not supported!');
    }
    return ret;
  }

  Bool1D operator >(/* Numeric1D | num */ other) {
    final ret = new Bool1D.sized(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] > other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] > other[i];
      }
    } else {
      throw new UnsupportedError('Type not supported!');
    }
    return ret;
  }

  Bool1D operator >=(/* Numeric1D | num */ other) {
    final ret = new Bool1D.sized(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] >= other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] >= other[i];
      }
    } else {
      throw new UnsupportedError('Type not supported!');
    }
    return ret;
  }

  int get min => stats.min;

  int get max => stats.max;

  Extent<int> get extent => stats.extent;

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
    final ret = new Int1D.sized(length);
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
    final ret = new Int1D.sized(length);
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
    for (int i = 0; i < length; i++) ret[i] = math.log(this[i]) / math.ln10;
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
    checkLengths(this, other, subject: 'other');

    num ret = 0;
    for (int i = 0; i < length; i++) {
      ret += this[i] * other.elementAt(i);
    }
    return ret.toInt();
  }

  Double1D toDouble() => new Double1D.fromNums(this);

  Int1D toInt() => new Int1D(this);

  Int2D diagonal({Index2D shape, num def: 0}) =>
      new Int2D.diagonal(this, shape: shape, fill: def?.toInt());

  Int2D to2D({int repeat: 1, bool t: false}) {
    if (!t) {
      return new Int2D.aCol(this, repeat: repeat);
    } else {
      return new Int2D.aRow(this, repeat: repeat);
    }
  }

  @override
  Int1D pickByIndices(Iterable<int> indices) {
    final ret = new Int1D.sized(indices.length);
    for (int i = 0; i < indices.length; i++) {
      ret[i] = this[indices.elementAt(i)];
    }
    return ret;
  }

  Int1D abs() {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = this[i].abs();
    return ret;
  }

  Int1D selectIf(Iterable<bool> mask) {
    if (mask.length != length) throw new Exception('Length mismatch!');

    int retLength = mask.where((v) => v).length;
    final ret = new List<int>()..length = retLength;
    int idx = 0;
    for (int i = 0; i < mask.length; i++) {
      if (mask.elementAt(i)) ret[idx++] = this[i];
    }
    return new Int1D.own(ret);
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
}
