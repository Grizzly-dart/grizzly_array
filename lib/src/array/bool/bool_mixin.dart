part of grizzly.series.array.bool;

abstract class Bool1DViewMixin implements ArrayView<bool>, BoolArrayView {
  Bool1DView makeView(Iterable<bool> newData) => new Bool1DView(newData);

  Bool1DFix makeFix(Iterable<bool> newData) => new Bool1DFix(newData);

  Bool1D makeArray(Iterable<bool> newData) => new Bool1D(newData);

  Index1D get shape => new Index1D(length);

  Bool1D clone() => new Bool1D.copy(this);

  bool get min {
    bool min;
    for (int i = 0; i < length; i++) {
      final bool d = this[i];
      if (d == null) continue;
      if (!d)
        return false;
      else
        min = true;
    }
    return min;
  }

  bool get max {
    bool max;
    for (int i = 0; i < length; i++) {
      final bool d = this[i];
      if (d == null) continue;
      if (d)
        return true;
      else
        max = false;
    }
    return max;
  }

  int get argMin {
    int minPos;
    for (int i = 0; i < length; i++) {
      final bool d = this[i];
      if (d == null) continue;
      if (!d)
        return i;
      else
        minPos ??= i;
    }
    return minPos;
  }

  int get argMax {
    int maxPos;
    for (int i = 0; i < length; i++) {
      final bool d = this[i];
      if (d == null)
        continue;
      else
        maxPos = i;
    }
    return maxPos;
  }

  int get sum {
    int sum = 0;
    for (int i = 0; i < length; i++) {
      final bool d = this[i];
      if (d == null) continue;
      if (d) sum++;
    }
    return sum;
  }

  double get mean {
    if (length == 0) return 0.0;
    return sum / length;
  }

  Bool2D to2D() => new Bool2D.from([this]);

  Bool2D get transpose {
    final ret = new Bool2D.sized(length, 1);
    for (int i = 0; i < length; i++) {
      ret[i][0] = this[i];
    }
    return ret;
  }

  Bool2D repeat({int repeat: 1, bool transpose: false}) {
    if (!transpose) {
      return new Bool2D.repeatCol(this, repeat + 1);
    } else {
      return new Bool2D.repeatRow(this, repeat + 1);
    }
  }

  Int1D toIntArray({int trueVal: 1, int falseVal: 0}) {
    final ret = new Int1D.shapedLike(this);
    for (int i = 0; i < length; i++) {
      if (this[i]) {
        ret[i] = trueVal;
      } else {
        ret[i] = falseVal;
      }
    }
    return ret;
  }

  String1D toStringArray({String trueVal: 'True', String falseVal: 'False'}) {
    final ret = new String1D.shapedLike(this);
    for (int i = 0; i < length; i++) {
      if (this[i]) {
        ret[i] = trueVal;
      } else {
        ret[i] = falseVal;
      }
    }
    return ret;
  }

  bool operator ==(final other) {
    if (other is! Array<bool>) return false;

    if (other is Array<bool>) {
      if (length != other.length) return false;
      for (int i = 0; i < length; i++) {
        if (this[i] != other[i]) return false;
      }
      return true;
    }

    return false;
  }

  bool get isTrue {
    for (int i = 0; i < length; i++) {
      final bool val = this[i];
      if (val == null) continue;
      if (!val) return false;
    }
    return true;
  }

  bool get isFalse {
    for (int i = 0; i < length; i++) {
      final bool val = this[i];
      if (val == null) continue;
      if (val) return false;
    }
    return true;
  }

  @override
  Bool1D pickByIndices(ArrayView<int> indices) {
    final ret = new Bool1D.sized(indices.length);
    for (int i = 0; i < indices.length; i++) {
      ret[i] = this[indices[i]];
    }
    return ret;
  }

  @override
  bool contains(bool value) => iterable.contains(value);

  @override
  BoolArrayView operator ~() {
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = ~this[i];
    }
    return ret;
  }

  @override
  BoolArrayView operator |(Array<bool> other) {
    if (length != other.length) throw new Exception("Lengths don't match!");
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i] || other[i];
    }
    return ret;
  }

  @override
  BoolArrayView operator &(Array<bool> other) {
    if (length != other.length) throw new Exception("Lengths don't match!");
    final ret = new Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i] && other[i];
    }
    return ret;
  }
}
