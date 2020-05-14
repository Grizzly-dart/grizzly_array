part of grizzly.series.array.dynamic;

abstract class Dynamic1DViewMixin implements DynamicArrayView {
  Dynamic1DView makeView(Iterable<dynamic> newData, [String name]) =>
      Dynamic1DView(newData, comparator: comparator, name: name);

  Dynamic1DFix makeFix(Iterable<dynamic> newData, [String name]) =>
      Dynamic1DFix(newData, comparator: comparator, name: name);

  Dynamic1D makeArray(Iterable<dynamic> newData, [String name]) =>
      Dynamic1D(newData, comparator: comparator, name: name);

  Index1D get shape => Index1D(length);

  Dynamic1D clone({String name}) =>
      Dynamic1D(this, comparator: comparator, name: name);

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

  Dynamic2D to2D({int repeat: 1, bool t: false}) {
    if (!t) {
      return Dynamic2D.aCol(this, repeat: repeat);
    } else {
      return Dynamic2D.aRow(this, repeat: repeat);
    }
  }

  Dynamic2D diagonal() => Dynamic2D.diagonal(this);

  @override
  Dynamic1D pickByIndices(Iterable<int> indices) {
    final ret = Dynamic1D.sized(indices.length, comparator: comparator);
    for (int i = 0; i < indices.length; i++) {
      ret[i] = this[indices.elementAt(i)];
    }
    return ret;
  }

  @override
  int compareValue(dynamic a, dynamic b) => comparator(a, b);

  @override
  Int1D toIntArray({int defaultValue, int onInvalid(value)}) {
    final ret = Int1D.sized(length);
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
    final ret = Double1D.sized(length);
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
    final ret = Bool1D.sized(length);
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
    final ret = String1D.sized(length);
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
    if (mask.length != length) throw Exception('Length mismatch!');

    int retLength = mask.where((v) => v).length;
    final ret = List<dynamic>()..length = retLength;
    int idx = 0;
    for (int i = 0; i < mask.length; i++) {
      if (mask.elementAt(i)) ret[idx++] = this[i];
    }
    return Dynamic1D.own(ret);
  }
}
