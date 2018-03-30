part of grizzly.series.array.int;

abstract class Int1DViewMixin implements Numeric1DView<int> {
  Int1DView makeView(Iterable<int> newData) => new Int1DView(newData);

  Int1DFix makeFix(Iterable<int> newData) => new Int1DFix(newData);

  Int1D makeArray(Iterable<int> newData) => new Int1D(newData);

  Int1D clone() => new Int1D.copy(this);

  Int1D operator -() {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = -this[i];
    return ret;
  }

  Int1D operator +(
          /* num | IterView<num> | Iterable<num> | Numeric2D<int> */ other) =>
      toInt..addition(other);

  Int1D operator -(/* num | IterView<num> | Iterable<num> */ other) =>
      toInt..subtract(other);

  Int1D operator *(/* num | IterView<num> | Iterable<num> */ other) =>
      toInt..multiply(other);

  Double1D operator /(/* num | IterView<num> | Iterable<num> */ other) =>
      toDouble..divide(other);

  Int1D operator ~/(/* num | IterView<num> | Iterable<num> */ other) =>
      toInt..truncDiv(other);

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

  int dot(IterView<num> other) {
    checkLengths(this, other, subject: 'other');

    num ret = 0;
    for (int i = 0; i < length; i++) {
      ret += this[i] * other[i];
    }
    return ret.toInt();
  }

  Double1D get toDouble => new Double1D.fromNum(this);

  Int1D get toInt => new Int1D.copy(this);

  Int2D repeat({int repeat: 1, bool transpose: false}) {
    if (!transpose) {
      return new Int2D.repeatCol(this, repeat + 1);
    } else {
      return new Int2D.repeatRow(this, repeat + 1);
    }
  }

  Int2D diagonal({Index2D shape, num def: 0}) =>
      new Int2D.diagonal(this, shape: shape, def: def?.toInt());

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
    for (int i = 0; i < indices.length; i++) {
      ret[i] = this[indices[i]];
    }
    return ret;
  }

  @override
  bool contains(int value) => asIterable.contains(value);

  Int1D abs() {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) ret[i] = this[i].abs();
    return ret;
  }
}
