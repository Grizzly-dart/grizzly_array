part of grizzly.series.array2d;

abstract class IntAxis2DViewMixin implements Numeric2DAxisView<int> {
  /// Minimum along y-axis
  Int1D get min {
    final ret = Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].min;
    }
    return ret;
  }

  /// Maximum along y-axis
  Int1D get max {
    final ret = Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].max;
    }
    return ret;
  }

  Double1D get mean {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].mean;
    }
    return ret;
  }

  Int1D get sum {
    final ret = Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].sum;
    }
    return ret;
  }

  Double1D average(Iterable<num> weights) {
    if (length == 0) return Double1D.sized(0);

    if (weights.length != otherDLength) {
      throw Exception('Weights have mismatching length!');
    }

    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].average(weights);
    }
    return ret;
  }

  Double1D get std {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].std;
    }
    return ret;
  }

  Double1D get variance {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].variance;
    }
    return ret;
  }

  @override
  ArrayView<int> get argMax {
    Int1D ret = Int1D.sized(length);
    for (int r = 0; r < length; r++) ret[r] = this[r].argMax;
    return ret;
  }

  @override
  ArrayView<int> get argMin {
    Int1D ret = Int1D.sized(length);
    for (int r = 0; r < length; r++) ret[r] = this[r].argMin;
    return ret;
  }

  @override
  Array<int> makeArray(Iterable<int> newData) => Int1D(newData);
}

abstract class Int2DRowViewMixin implements Numeric2DAxisView<int> {
  Numeric2D<int> operator +(
      /* num | Iterable<num> | Numeric2DView<int> */ other) {
    if (other is num || other is Iterable<num>) {
      Int2D ret = Int2D.sized(length, otherDLength);
      for (int r = 0; r < length; r++) ret[r] = this[r] + other;
      return ret;
    } else if (other is Numeric2DView<int>) {
      Int2D ret = Int2D.sized(length, otherDLength);
      for (int r = 0; r < length; r++) ret[r] = this[r] + other[r];
      return ret;
    }
    throw UnsupportedError(other?.runtimeType?.toString());
  }

  Numeric2D<int> operator -(
      /* num | Iterable<num> | Numeric2DView<int> */ other) {
    if (other is num || other is Iterable<num>) {
      Int2D ret = Int2D.sized(length, otherDLength);
      for (int r = 0; r < length; r++) ret[r] = this[r] - other;
      return ret;
    } else if (other is Numeric2DView<int>) {
      Int2D ret = Int2D.sized(length, otherDLength);
      for (int r = 0; r < length; r++) ret[r] = this[r] - other[r];
      return ret;
    }
    throw UnsupportedError(other?.runtimeType?.toString());
  }

  Numeric2D<int> operator *(
      /* num | Iterable<num> | Numeric2DView<int> */ other) {
    if (other is num || other is Iterable<num>) {
      Int2D ret = Int2D.sized(length, otherDLength);
      for (int r = 0; r < length; r++) ret[r] = this[r] * other;
      return ret;
    } else if (other is Numeric2DView<int>) {
      Int2D ret = Int2D.sized(length, otherDLength);
      for (int r = 0; r < length; r++) ret[r] = this[r] * other[r];
      return ret;
    }
    throw UnsupportedError(other?.runtimeType?.toString());
  }

  Numeric2D<double> operator /(
      /* num | Iterable<num> | Numeric2DView<int> */ other) {
    if (other is num || other is Iterable<num>) {
      Double2D ret = Double2D.sized(length, otherDLength);
      for (int r = 0; r < length; r++) ret[r] = this[r] / other;
      return ret;
    } else if (other is Numeric2DView<int>) {
      Double2D ret = Double2D.sized(length, otherDLength);
      for (int r = 0; r < length; r++) ret[r] = this[r] / other[r];
      return ret;
    }
    throw UnsupportedError(other?.runtimeType?.toString());
  }

  Numeric2D<int> operator ~/(
      /* num | Iterable<num> | Numeric2DView<int> */ other) {
    if (other is num || other is Iterable<num>) {
      Int2D ret = Int2D.sized(length, otherDLength);
      for (int r = 0; r < length; r++) ret[r] = this[r] ~/ other;
      return ret;
    } else if (other is Numeric2DView<int>) {
      Int2D ret = Int2D.sized(length, otherDLength);
      for (int r = 0; r < length; r++) ret[r] = this[r] ~/ other[r];
      return ret;
    }
    throw UnsupportedError(other?.runtimeType?.toString());
  }
}

abstract class Int2DColViewMixin implements Numeric2DAxisView<int> {
  Numeric2D<int> operator +(
      /* num | Iterable<num> | Numeric2DView<int> */ other) {
    if (other is num || other is Iterable<num>) {
      Int2D ret = Int2D.sized(otherDLength, length);
      for (int c = 0; c < length; c++) ret.col[c] = this[c] + other;
      return ret;
    } else if (other is Numeric2DView<int>) {
      Int2D ret = Int2D.sized(length, otherDLength);
      for (int c = 0; c < length; c++) ret.col[c] = this[c] + other.col[c];
      return ret;
    }
    throw UnsupportedError(other?.runtimeType?.toString());
  }

  Numeric2D<int> operator -(
      /* num | Iterable<num> | Numeric2DView<int> */ other) {
    if (other is num || other is Iterable<num>) {
      Int2D ret = Int2D.sized(otherDLength, length);
      for (int c = 0; c < length; c++) ret.col[c] = this[c] - other;
      return ret;
    } else if (other is Numeric2DView<int>) {
      Int2D ret = Int2D.sized(length, otherDLength);
      for (int c = 0; c < length; c++) ret.col[c] = this[c] - other.col[c];
      return ret;
    }
    throw UnsupportedError(other?.runtimeType?.toString());
  }

  Numeric2D<int> operator *(
      /* num | Iterable<num> | Numeric2DView<int> */ other) {
    if (other is num || other is Iterable<num>) {
      Int2D ret = Int2D.sized(otherDLength, length);
      for (int c = 0; c < length; c++) ret.col[c] = this[c] * other;
      return ret;
    } else if (other is Numeric2DView<int>) {
      Int2D ret = Int2D.sized(length, otherDLength);
      for (int c = 0; c < length; c++) ret.col[c] = this[c] * other.col[c];
      return ret;
    }
    throw UnsupportedError(other?.runtimeType?.toString());
  }

  Numeric2D<double> operator /(
      /* num | Iterable<num> | Numeric2DView<int> */ other) {
    if (other is num || other is Iterable<num>) {
      Double2D ret = Double2D.sized(otherDLength, length);
      for (int c = 0; c < length; c++) ret.col[c] = this[c] / other;
      return ret;
    } else if (other is Numeric2DView<int>) {
      Double2D ret = Double2D.sized(length, otherDLength);
      for (int c = 0; c < length; c++) ret.col[c] = this[c] / other.col[c];
      return ret;
    }
    throw UnsupportedError(other?.runtimeType?.toString());
  }

  Numeric2D<int> operator ~/(
      /* num | Iterable<num> | Numeric2DView<int> */ other) {
    if (other is num || other is Iterable<num>) {
      Int2D ret = Int2D.sized(otherDLength, length);
      for (int c = 0; c < length; c++) ret.col[c] = this[c] ~/ other;
      return ret;
    } else if (other is Numeric2DView<int>) {
      Int2D ret = Int2D.sized(length, otherDLength);
      for (int c = 0; c < length; c++) ret.col[c] = this[c] ~/ other.col[c];
      return ret;
    }
    throw UnsupportedError(other?.runtimeType?.toString());
  }
}
