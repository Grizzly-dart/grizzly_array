part of grizzly.array2d;

abstract class BoolAxis2DViewMixin implements Axis2D<bool> {
  /*
  Double1D get mean {
    if (length == 0) return Double1D.sized(0);
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].mean;
    }
    return ret;
  }

  Int1D get sum {
    if (length == 0) return Int1D.sized(0);
    final ret = Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].sum;
    }
    return ret;
  }
   */

  /// Minimum along y-axis
  Bool1D get min {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].min;
    }
    return ret;
  }

  /// Maximum along y-axis
  Bool1D get max {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].max;
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
  BoolArray makeArray(Iterable<bool> newData) => Bool1D(newData);
}
