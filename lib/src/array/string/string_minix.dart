part of grizzly.series.array.string;

abstract class String1DViewMixin implements ArrayView<String>, StringArrayView {
  String1DView makeView(Iterable<String> newData, [String name]) =>
      String1DView(newData, name);

  String1DFix makeFix(Iterable<String> newData, [String name]) =>
      String1DFix(newData, name);

  String1D makeArray(Iterable<String> newData, [String name]) =>
      String1D(newData, name);

  Index1D get shape => Index1D(length);

  String1D clone({String name}) => String1D(this, name);

  String get min {
    String ret;
    for (int i = 0; i < length; i++) {
      final String d = this[i];
      if (d == null) continue;
      if (ret == null || d.compareTo(ret) < 0) ret = d;
    }
    return ret;
  }

  String get max {
    String ret;
    for (int i = 0; i < length; i++) {
      final String d = this[i];
      if (d == null) continue;
      if (ret == null || d.compareTo(ret) > 0) ret = d;
    }
    return ret;
  }

  int get argMin {
    int ret;
    String min;
    for (int i = 0; i < length; i++) {
      final String d = this[i];
      if (d == null) continue;
      if (min == null || d.compareTo(min) < 0) {
        min = d;
        ret = i;
      }
    }
    return ret;
  }

  int get argMax {
    int ret;
    String max;
    for (int i = 0; i < length; i++) {
      final String d = this[i];
      if (d == null) continue;
      if (max == null || d.compareTo(max) > 0) {
        max = d;
        ret = i;
      }
    }
    return ret;
  }

  String2D to2D({int repeat: 1, bool t: false}) {
    if (!t)
      return String2D.aCol(this, repeat: repeat);
    else
      return String2D.aRow(this, repeat: repeat);
  }

  String2D diagonal() => String2D.diagonal(this);

  Array<bool> get isAlphaNum {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(RegExp(r'[a-zA-Z0-9]*$'));
    }
    return ret;
  }

  Array<bool> get isAlphabet {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(RegExp(r'[a-zA-Z]*$'));
    }
    return ret;
  }

  Array<bool> get isDecimal {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(RegExp(r'\d+(\.\d+)?$'));
    }
    return ret;
  }

  Array<bool> get isNumber {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(RegExp(r'\d+$'));
    }
    return ret;
  }

  Array<bool> get isLower {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(RegExp(r'[a-z]*$'));
    }
    return ret;
  }

  Array<bool> get isUpper {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(RegExp(r'[A-Z]*$'));
    }
    return ret;
  }

  Array<bool> get isSpace {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(RegExp(r'\s*$'));
    }
    return ret;
  }

  Array<bool> startsWith(Pattern pattern, [int index = 0]) {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(pattern, index);
    }
    return ret;
  }

  Array<bool> endsWith(String pattern) {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].endsWith(pattern);
    }
    return ret;
  }

  Array<int> get lengths {
    final ret = Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].length;
    }
    return ret;
  }

  Array<bool> get areEmpty {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].isEmpty;
    }
    return ret;
  }

  Array<bool> get areNotEmpty {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].isNotEmpty;
    }
    return ret;
  }

  bool get areAllEmpty {
    for (int i = 0; i < length; i++) {
      if (this[i].isNotEmpty) return false;
    }
    return true;
  }

  bool get areAllNotEmpty {
    for (int i = 0; i < length; i++) {
      if (this[i].isEmpty) return false;
    }
    return true;
  }

  Numeric1D<int> toInt(
      {int radix, int defaultValue, int onError(String source)}) {
    final ret = Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = int.tryParse(this[i], radix: radix) ?? defaultValue;
    }
    return ret;
  }

  Numeric1D<double> toDouble(
      {double onError(String source), double defaultValue}) {
    final ret = Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = double.tryParse(this[i]) ?? defaultValue;
    }
    return ret;
  }

  @override
  String1D pickByIndices(Iterable<int> indices) {
    final ret = String1D.sized(indices.length);
    for (int i = 0; i < indices.length; i++) {
      ret[i] = this[indices.elementAt(i)];
    }
    return ret;
  }

  @override
  int compareValue(String a, String b) => a.compareTo(b);

  String1D selectIf(Iterable<bool> mask) {
    if (mask.length != length) throw Exception('Length mismatch!');

    int retLength = mask.where((v) => v).length;
    final ret = List<String>()..length = retLength;
    int idx = 0;
    for (int i = 0; i < mask.length; i++) {
      if (mask.elementAt(i)) ret[idx++] = this[i];
    }
    return String1D.own(ret);
  }
}
