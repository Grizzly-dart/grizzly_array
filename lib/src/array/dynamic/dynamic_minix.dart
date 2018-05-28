part of grizzly.series.array.dynamic;

abstract class Dynamic1DViewMixin implements DynamicArrayView {
  Dynamic1DView makeView(Iterable<dynamic> newData, [String name]) =>
      new Dynamic1DView(newData, comparator: comparator, name: name);

  Dynamic1DFix makeFix(Iterable<dynamic> newData, [String name]) =>
      new Dynamic1DFix(newData, comparator: comparator, name: name);

  Dynamic1D makeArray(Iterable<dynamic> newData, [String name]) =>
      new Dynamic1D(newData, comparator: comparator, name: name);

  Index1D get shape => new Index1D(length);

  Dynamic1D clone({String name}) =>
      new Dynamic1D(this, comparator: comparator, name: name);

  dynamic get min {
    dynamic ret;
    for (int i = 0; i < length; i++) {
      final dynamic d = this[i];
      if (d == null) continue;
      if (ret == null || comparator(d, ret) < 0) ret = d;
    }
    return ret;
  }

  dynamic get max {
    dynamic ret;
    for (int i = 0; i < length; i++) {
      final dynamic d = this[i];
      if (d == null) continue;
      if (ret == null || comparator(d, ret) > 0) ret = d;
    }
    return ret;
  }

  int get argMin {
    int ret;
    dynamic min;
    for (int i = 0; i < length; i++) {
      final dynamic d = this[i];
      if (d == null) continue;
      if (min == null || comparator(d, min) < 0) {
        min = d;
        ret = i;
      }
    }
    return ret;
  }

  int get argMax {
    int ret;
    dynamic max;
    for (int i = 0; i < length; i++) {
      final dynamic d = this[i];
      if (d == null) continue;
      if (max == null || comparator(d, max) > 0) {
        max = d;
        ret = i;
      }
    }
    return ret;
  }

  Dynamic2D to2D() => new Dynamic2D([this]);

  Dynamic2D repeat({int repeat: 1, bool transpose: false}) {
    if (!transpose) {
      return new Dynamic2D.aCol(this, repeat: repeat + 1);
    } else {
      return new Dynamic2D.aRow(this, repeat: repeat + 1);
    }
  }

  Dynamic2D diagonal() => new Dynamic2D.diagonal(this);

  Dynamic2D get transpose {
    final ret = new Dynamic2D.sized(length, 1);
    for (int i = 0; i < length; i++) {
      ret[i][0] = this[i];
    }
    return ret;
  }

  @override
  Dynamic1D pickByIndices(Iterable<int> indices) {
    final ret = new Dynamic1D.sized(indices.length, comparator: comparator);
    for (int i = 0; i < indices.length; i++) {
      ret[i] = this[indices.elementAt(i)];
    }
    return ret;
  }

  @override
  int compareValue(dynamic a, dynamic b) => comparator(a, b);

  @override
  Int1D toIntArray({int defaultValue, int onInvalid(value)}) {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      dynamic v = this[i];
      if (v is int) {
        ret[i] = v;
      } else if (v is num) {
        ret[i] = v.toInt();
      } else if (onInvalid != null) {
        ret[i] = onInvalid(v);
      } else {
        ret[i] = defaultValue;
      }
    }
    return ret;
  }

  @override
  Double1D toDoubleArray({double defaultValue, double onInvalid(value)}) {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      dynamic v = this[i];
      if (v is double) {
        ret[i] = v;
      } else if (v is num) {
        ret[i] = v.toDouble();
      } else if (onInvalid != null) {
        ret[i] = onInvalid(v);
      } else {
        ret[i] = defaultValue;
      }
    }
    return ret;
  }

  @override
  Bool1D toBoolArray({bool defaultValue, bool onInvalid(value)}) {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      dynamic v = this[i];
      if (v is bool) {
        ret[i] = v;
      } else if (onInvalid != null) {
        ret[i] = onInvalid(v);
      } else {
        ret[i] = defaultValue;
      }
    }
    return ret;
  }

  @override
  String1D toStringArray({String defaultValue, String onInvalid(value)}) {
    final ret = new String1D.sized(length);
    for (int i = 0; i < length; i++) {
      dynamic v = this[i];
      if (v is String) {
        ret[i] = v;
      } else if (onInvalid != null) {
        ret[i] = onInvalid(v);
      } else {
        ret[i] = defaultValue;
      }
    }
    return ret;
  }

  Dynamic1D selectIf(Iterable<bool> mask) {
    if (mask.length != length) throw new Exception('Length mismatch!');

    int retLength = mask.where((v) => v).length;
    final ret = new List<dynamic>()..length = retLength;
    int idx = 0;
    for (int i = 0; i < mask.length; i++) {
      if (mask.elementAt(i)) ret[idx++] = this[i];
    }
    return new Dynamic1D.own(ret);
  }
}
