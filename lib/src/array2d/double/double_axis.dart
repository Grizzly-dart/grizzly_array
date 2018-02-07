part of grizzly.series.array2d;

class Double1DFixLazy extends Double1DFix {
  Double1DFixLazy(Double2DFix inner, int colIndex)
      : super(new ColList<double>(inner, colIndex));
}

class Double1DViewLazy extends Double1DView {
  Double1DViewLazy(Double2DView inner, int colIndex)
      : super(new ColList<double>(inner, colIndex));
}

abstract class DoubleAxis2DViewMixin implements Numeric2DAxisView<double> {
  Double1D get mean {
    if (length == 0) return new Double1D.sized(0);

    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].mean;
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

  Double1D get sum {
    if (length == 0) return new Double1D.sized(0);

    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].sum;
    }
    return ret;
  }

  /// Minimum along y-axis
  Double1D get min {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].min;
    }
    return ret;
  }

  /// Maximum along y-axis
  Double1D get max {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].max;
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
  Array<double> makeArray(Iterable<double> newData) => new Double1D(newData);
}

abstract class Double2DRowViewMixin implements Numeric2DAxisView<double> {
  Numeric2D<double> operator +(Numeric1DView<double> other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Double2D ret = new Double2D.sized(length, otherDLength);
    for (int r = 0; r < length; r++) ret[r] = this[r] + other;
    return ret;
  }

  Numeric2D<double> operator -(Numeric1DView<double> other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Double2D ret = new Double2D.sized(length, otherDLength);
    for (int r = 0; r < length; r++) ret[r] = this[r] - other;
    return ret;
  }

  Numeric2D<double> operator *(Numeric1DView<double> other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Double2D ret = new Double2D.sized(length, otherDLength);
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

abstract class Double2DColViewMixin implements Numeric2DAxisView<double> {
  Numeric2D<double> operator +(Numeric1DView<double> other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Double2D ret = new Double2D.sized(otherDLength, length);
    for (int c = 0; c < length; c++) ret.col[c] = this[c] + other;
    return ret;
  }

  Numeric2D<double> operator -(Numeric1DView<double> other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Double2D ret = new Double2D.sized(otherDLength, length);
    for (int c = 0; c < length; c++) ret.col[c] = this[c] - other;
    return ret;
  }

  Numeric2D<double> operator *(Numeric1DView<double> other) {
    if (other.length != otherDLength)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');
    Double2D ret = new Double2D.sized(otherDLength, length);
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
