part of grizzly.array.common;

class StatsImpl<T extends num> implements Stats<T> {
  final Iterable<T> values;

  StatsImpl(this.values);

  int get length => values.length;

  T operator [](int index) => values.elementAt(index);

  T get min {
    T ret;
    for (int i = 0; i < length; i++) {
      final T d = values.elementAt(i);
      if (d == null) continue;
      if (ret == null || d < ret) ret = d;
    }
    return ret;
  }

  T get max {
    T ret;
    for (int i = 0; i < length; i++) {
      final T d = values.elementAt(i);
      if (d == null) continue;
      if (ret == null || d > ret) ret = d;
    }
    return ret;
  }

  Extent<T> get extent {
    T min;
    T max;
    for (int i = 0; i < length; i++) {
      final T d = values.elementAt(i);
      if (d == null) continue;
      if (max == null || d > max) max = d;
      if (min == null || d < min) min = d;
    }
    return Extent<T>(min, max);
  }

  T get ptp {
    T min;
    T max;
    for (int i = 0; i < length; i++) {
      final T d = values.elementAt(i);
      if (d == null) continue;
      if (max == null || d > max) max = d;
      if (min == null || d < min) min = d;
    }

    if (min == null) return null;
    return max - min;
  }

  T get mode {
    throw UnimplementedError();
  }

  T get median {
    if (length == 0) return null;
    final list = values.toList()..sort();
    return list[length ~/ 2];
  }

  double average(Iterable<num> weights) {
    if (weights.length != length) {
      throw Exception('Weights have mismatching length!');
    }
    if (length == 0) return 0.0;

    double sum = 0.0;
    num denom = 0.0;
    for (int i = 0; i < length; i++) {
      final T d = values.elementAt(i);
      final num w = weights.elementAt(i);
      if (d == null) continue;
      if (w == null) continue;
      sum += d * w;
      denom += w;
    }
    return sum / denom;
  }

  double get mean {
    if (length == 0) return 0.0;

    num sum = 0;
    for (int i = 0; i < length; i++) {
      final T d = values.elementAt(i);
      if (d == null) continue;
      sum += d;
    }
    return sum / length;
  }

  double get variance {
    if (length == 0) return 0.0;

    final double mean = this.mean;
    double ret = 0.0;
    for (int i = 0; i < length; i++) {
      final double val = values.elementAt(i) - mean;
      ret += val * val;
    }
    return ret / length;
  }

  double get std => math.sqrt(variance);

  int count(T v) {
    int ret = 0;
    for (int i = 0; i < length; i++) {
      if (values.elementAt(i) == v) ret++;
    }
    return ret;
  }

  int get countNonNull {
    int ret = 0;
    for (int i = 0; i < length; i++) {
      if (values.elementAt(i) != null) ret++;
    }
    return ret;
  }

  T get sum {
    T ret;
    if (0 is T) {
      ret = 0 as T;
    } else {
      ret = 0.0 as T;
    }
    for (int i = 0; i < length; i++) {
      final T d = values.elementAt(i);
      if (d == null) continue;
      ret += d;
    }
    return ret;
  }

  T get prod {
    T ret;
    if (0 is T) {
      ret = 1 as T;
    } else {
      ret = 1.0 as T;
    }
    for (int i = 0; i < length; i++) {
      final T d = values.elementAt(i);
      if (d == null) continue;
      ret *= d;
    }
    return ret;
  }

  double cov(Numeric1DView y) {
    if (y.length != length) throw Exception('Size mismatch!');
    if (length == 0) return 0.0;
    final double meanX = mean;
    final double meanY = y.mean;
    double sum = 0.0;
    for (int i = 0; i < length; i++) {
      sum += (values.elementAt(i) - meanX) * (y[i] - meanY);
    }
    return sum / length;
  }

  Numeric1D<double> covMatrix(Numeric2D y) {
    if (y.numRows != length) throw Exception('Size mismatch!');
    final double meanX = mean;
    final Double1D meanY = y.col.mean;
    Double1D sum = Double1D.sized(y.numCols);
    for (int i = 0; i < length; i++) {
      sum += (y.col[i] - meanY) * (values.elementAt(i) - meanX);
    }
    return sum / length;
  }

  double corrcoef(Numeric1DView y) {
    if (y.length != length) throw Exception('Size mismatch!');
    return cov(y) / (std * y.std);
  }

  Numeric1D<double> corrcoefMatrix(Numeric2D y) {
    if (y.numRows != length) throw Exception('Size mismatch!');
    return covMatrix(y) / (y.std * std);
  }

  String describe() {
    final ret = table(['', '']);
    ret.row(['Count (non-null)', countNonNull]);
    ret.row(['Mean', mean]);
    ret.row(['std', std]);
    ret.row(['min', min]);
    // TODO
    ret.row(['max', max]);
    // TODO
    return ret.toString();
  }
}
