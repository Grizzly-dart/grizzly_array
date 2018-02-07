part of grizzly.series.array2d;

abstract class BoolAxis2DViewMixin implements BoolAxis2DView {
  Double1D get mean {
    if (length == 0) return new Double1D.sized(0);
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].mean;
    }
    return ret;
  }

  Int1D get sum {
    if (length == 0) return new Int1D.sized(0);
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].sum;
    }
    return ret;
  }

  /// Minimum along y-axis
  Bool1D get min {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].min;
    }
    return ret;
  }

  /// Maximum along y-axis
  Bool1D get max {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].max;
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
  BoolArray makeArray(Iterable<bool> newData) => new Bool1D(newData);
}
