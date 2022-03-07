part of grizzly.array.bool;

abstract class Bool1DViewMixin implements ArrayView<bool>, BoolArrayView {
  Bool2D to2D({int repeat: 1, bool t: false}) {
    if (!t) {
      return Bool2D.aCol(this, repeat: repeat);
    } else {
      return Bool2D.aRow(this, repeat: repeat);
    }
  }

  Bool2D diagonal() => Bool2D.diagonal(this);

  String1D toStringArray({String trueVal: 'True', String falseVal: 'False'}) {
    final ret = String1D.shapedLike(this);
    for (int i = 0; i < length; i++) {
      if (this[i]) {
        ret[i] = trueVal;
      } else {
        ret[i] = falseVal;
      }
    }
    return ret;
  }

  @override
  Bool1D pickByIndices(Iterable<int> indices) {
    final ret = Bool1D.sized(indices.length);
    for (int i = 0; i < indices.length; i++) {
      ret[i] = this[indices.elementAt(i)];
    }
    return ret;
  }

  @override
  BoolArrayView operator ~() {
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = !this[i];
    }
    return ret;
  }

  @override
  BoolArrayView operator |(Array<bool> other) {
    if (length != other.length) throw Exception("Lengths don't match!");
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i] || other[i];
    }
    return ret;
  }

  @override
  BoolArrayView operator &(Array<bool> other) {
    if (length != other.length) throw Exception("Lengths don't match!");
    final ret = Bool1D.sized(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i] && other[i];
    }
    return ret;
  }

  @override
  int compareValue(bool a, bool b) => a == b ? 0 : a ? 1 : -1;

  Bool1D selectByMask(Iterable<bool> mask) {
    if (mask.length != length) throw Exception('Length mismatch!');

    int retLength = mask.where((v) => v).length;
    final ret = List<bool>()..length = retLength;
    int idx = 0;
    for (int i = 0; i < mask.length; i++) {
      if (mask.elementAt(i)) ret[idx++] = this[i];
    }
    return Bool1D.own(ret);
  }
}
