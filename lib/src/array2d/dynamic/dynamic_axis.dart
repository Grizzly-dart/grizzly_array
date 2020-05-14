part of grizzly.series.array2d;

abstract class Dynamic2DAxisMixin implements DynamicAxis2DView {
  /// Minimum along y-axis
  Dynamic1D get min {
    final ret = Dynamic1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].min;
    }
    return ret;
  }

  /// Maximum along y-axis
  Dynamic1D get max {
    final ret = Dynamic1D.sized(length);
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
  DynamicArray makeArray(Iterable<dynamic> newData) => Dynamic1D(newData);
}
