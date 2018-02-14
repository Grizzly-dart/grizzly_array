part of grizzly.series.array2d;

abstract class IntAxis2DViewMixin implements Numeric2DAxisView<int> {
  /// Minimum along y-axis
  Int1D get min {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].min;
    }
    return ret;
  }

  /// Maximum along y-axis
  Int1D get max {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].max;
    }
    return ret;
  }

  Double1D get mean {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].mean;
    }
    return ret;
  }

  Int1D get sum {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].sum;
    }
    return ret;
  }

  Double1D average(Iterable<num> weights) {
    if (length == 0) return new Double1D.sized(0);

    if (weights.length != otherDLength) {
      throw new Exception('Weights have mismatching length!');
    }

    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].average(weights);
    }
    return ret;
  }

  Double1D get std {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].std;
    }
    return ret;
  }

  Double1D get variance {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].variance;
    }
    return ret;
  }

  @override
  ArrayView<int> get argMax {
    Int1D ret = new Int1D.sized(length);
    for (int r = 0; r < length; r++) ret[r] = this[r].argMax;
    return ret;
  }

  @override
  ArrayView<int> get argMin {
    Int1D ret = new Int1D.sized(length);
    for (int r = 0; r < length; r++) ret[r] = this[r].argMin;
    return ret;
  }

  @override
  Array<int> makeArray(Iterable<int> newData) => new Int1D(newData);
}

abstract class Int2DRowViewMixin implements Numeric2DAxisView<int> {
  Numeric2D<int> operator +(Numeric1DView<int> other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Int2D ret = new Int2D.sized(length, otherDLength);
    for (int r = 0; r < length; r++) ret[r] = this[r] + other;
    return ret;
  }

  Numeric2D<int> operator -(Numeric1DView<int> other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Int2D ret = new Int2D.sized(length, otherDLength);
    for (int r = 0; r < length; r++) ret[r] = this[r] - other;
    return ret;
  }

  Numeric2D<int> operator *(Numeric1DView<int> other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Int2D ret = new Int2D.sized(length, otherDLength);
    for (int r = 0; r < length; r++) ret[r] = this[r] * other;
    return ret;
  }

  Numeric2D<double> operator /(Numeric1DView other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Double2D ret = new Double2D.sized(length, otherDLength);
    for (int r = 0; r < length; r++) ret[r] = this[r] / other;
    return ret;
  }

  Numeric2D<int> operator ~/(Numeric1DView other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Int2D ret = new Int2D.sized(length, otherDLength);
    for (int r = 0; r < length; r++) ret[r] = this[r] ~/ other;
    return ret;
  }
}

abstract class Int2DColViewMixin implements Numeric2DAxisView<int> {
  Numeric2D<int> operator +(Numeric1DView<int> other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Int2D ret = new Int2D.sized(otherDLength, length);
    for (int c = 0; c < length; c++) ret.col[c] = this[c] + other;
    return ret;
  }

  Numeric2D<int> operator -(Numeric1DView<int> other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Int2D ret = new Int2D.sized(otherDLength, length);
    for (int c = 0; c < length; c++) ret.col[c] = this[c] - other;
    return ret;
  }

  Numeric2D<int> operator *(Numeric1DView<int> other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Int2D ret = new Int2D.sized(otherDLength, length);
    for (int c = 0; c < length; c++) ret.col[c] = this[c] * other;
    return ret;
  }

  Numeric2D<double> operator /(Numeric1DView other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Double2D ret = new Double2D.sized(otherDLength, length);
    for (int c = 0; c < length; c++) ret.col[c] = this[c] / other;
    return ret;
  }

  Numeric2D<int> operator ~/(Numeric1DView other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Int2D ret = new Int2D.sized(otherDLength, length);
    for (int c = 0; c < length; c++) ret.col[c] = this[c] ~/ other;
    return ret;
  }
}
