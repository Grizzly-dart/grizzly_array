part of grizzly.series.array.string;

abstract class String1DViewMixin implements ArrayView<String>, StringArrayView {
  String1DView makeView(Iterable<String> newData) => new String1DView(newData);

  String1DFix makeFix(Iterable<String> newData) => new String1DFix(newData);

  String1D makeArray(Iterable<String> newData) => new String1D(newData);

  Index1D get shape => new Index1D(length);

  String1D clone() => new String1D.copy(this);

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

  String2D to2D() => new String2D.from([this]);

  String2D repeat({int repeat: 1, bool transpose: false}) {
    if (!transpose) {
      return new String2D.repeatCol(this, repeat + 1);
    } else {
      return new String2D.repeatRow(this, repeat + 1);
    }
  }

  String2D diagonal() => new String2D.diagonal(this);

  String2D get transpose {
    final ret = new String2D.sized(length, 1);
    for (int i = 0; i < length; i++) {
      ret[i][0] = this[i];
    }
    return ret;
  }

  bool operator ==(other) {
    if (other is! Array<String>) return false;

    if (other is Array<String>) {
      if (length != other.length) return false;
      for (int i = 0; i < length; i++) {
        if (this[i] != other[i]) return false;
      }
      return true;
    }

    return false;
  }

  Array<bool> get isAlphaNum {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(new RegExp(r'[a-zA-Z0-9]*$'));
    }
    return ret;
  }

  Array<bool> get isAlphabet {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(new RegExp(r'[a-zA-Z]*$'));
    }
    return ret;
  }

  Array<bool> get isDecimal {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(new RegExp(r'\d+(\.\d+)?$'));
    }
    return ret;
  }

  Array<bool> get isNumber {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(new RegExp(r'\d+$'));
    }
    return ret;
  }

  Array<bool> get isLower {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(new RegExp(r'[a-z]*$'));
    }
    return ret;
  }

  Array<bool> get isUpper {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(new RegExp(r'[A-Z]*$'));
    }
    return ret;
  }

  Array<bool> get isSpace {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(new RegExp(r'\s*$'));
    }
    return ret;
  }

  Array<bool> startsWith(Pattern pattern, [int index = 0]) {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].startsWith(pattern, index);
    }
    return ret;
  }

  Array<bool> endsWith(String pattern) {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].endsWith(pattern);
    }
    return ret;
  }

  String join([String separator = ""]) => asIterable.join(separator);

  Array<int> get lengths {
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].length;
    }
    return ret;
  }

  Array<bool> get areEmpty {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].isEmpty;
    }
    return ret;
  }

  Array<bool> get areNotEmpty {
    final ret = new Bool1D.sized(length);
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
    final ret = new Int1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = int.parse(this[i],
          radix: radix, onError: onError ?? (_) => defaultValue);
    }
    return ret;
  }

  Numeric1D<double> toDouble(
      {double onError(String source), double defaultValue}) {
    final ret = new Double1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = double.parse(this[i], onError ?? (_) => defaultValue);
    }
    return ret;
  }

  @override
  String1D pickByIndices(ArrayView<int> indices) {
    final ret = new String1D.sized(indices.length);
    for (int i = 0; i < indices.length; i++) {
      ret[i] = this[indices[i]];
    }
    return ret;
  }

  @override
  bool contains(String value) => asIterable.contains(value);

  @override
  int compareValue(String a, String b) => a.compareTo(b);
}
