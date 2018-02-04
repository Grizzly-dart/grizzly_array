part of grizzly.series.array.int;

abstract class IntFixMixin implements Numeric1DFix<int> {
  /// Sets all elements in the array to given value [v]
  void set(int v) {
    for (int i = 0; i < length; i++) {
      this[i] = v;
    }
  }

  void assign(Iterable<int> other) {
    if (other.length != length)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int i = 0; i < length; i++) this[i] = other.elementAt(i);
  }

  @override
  void clip({int min, int max}) {
    if (min != null && max != null) {
      for (int i = 0; i < length; i++) {
        final int d = this[i];

        if (d < min) this[i] = min;
        if (d > max) this[i] = max;
      }
      return;
    }
    if (min != null) {
      for (int i = 0; i < length; i++) {
        final int d = this[i];

        if (d < min) this[i] = min;
      }
      return;
    }
    if (max != null) {
      for (int i = 0; i < length; i++) {
        final int d = this[i];

        if (d > max) this[i] = max;
      }
      return;
    }
  }
}

class Int1DFix extends Object
    with Int1DViewMixin, IntFixMixin, Array1DViewMixin<int>
    implements Numeric1DFix<int>, Int1DView {
  final List<int> _data;

  Int1DFix(Iterable<int> data) : _data = new Int32List.fromList(data.toList());

  /// Creates [Int1DFix] from [_data] and also takes ownership of it. It is
  /// efficient than other ways of creating [Int1DFix] because it involves no
  /// copying.
  Int1DFix.own(this._data);

  Int1DFix.sized(int length, {int data: 0}) : _data = new Int32List(length) {
    for (int i = 0; i < length; i++) {
      _data[i] = data;
    }
  }

  factory Int1DFix.shapedLike(ArrayView d, {int data: 0}) =>
      new Int1DFix.sized(d.length, data: data);

  Int1DFix.single(int data) : _data = new Int32List.fromList(<int>[data]);

  Int1DFix.gen(int length, int maker(int index))
      : _data = new Int32List(length) {
    for (int i = 0; i < length; i++) {
      _data[i] = maker(i);
    }
  }

  Iterable<int> get iterable => _data;

  Iterator<int> get iterator => _data.iterator;

  int get length => _data.length;

  int operator [](int i) => _data[i];

  operator []=(int i, int val) {
    if (i > _data.length) {
      throw new RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Int1D slice(int start, [int end]) => new Int1D(_data.sublist(start, end));

  Int1DFix operator +(/* num | Iterable<num> */ other) => addition(other);

  Int1DFix addition(/* num | Iterable<num> */ other, {bool self: false}) {
    Int1DFix ret = this;
    if (!self) ret = new Int1DFix.sized(length);

    if (other is Int1D) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
    } else if (other is int) {
      // Nothing here
    } else if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<int>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] + other.elementAt(i);
      }
      return ret;
    } else if (other is Iterable<num>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] + other.elementAt(i).toInt();
      }
      return ret;
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] + other;
      }
    } else if (other is Int1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] + other[i];
      }
    }
    return ret;
  }

  Int1DFix operator -(/* num | Iterable<num> */ other) => subtract(other);

  Int1DFix subtract(/* num | Iterable<num> */ other, {bool self: false}) {
    Int1DFix ret = this;
    if (!self) {
      ret = new Int1DFix.sized(length);
    }

    if (other is Int1D) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
    } else if (other is int) {
      // Nothing here
    } else if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<int>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] - other.elementAt(i);
      }
      return ret;
    } else if (other is Iterable<num>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] - other.elementAt(i).toInt();
      }
      return ret;
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] - other;
      }
    } else if (other is Int1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] - other[i];
      }
    }
    return ret;
  }

  Int1DFix operator *(/* num | Iterable<num> */ other) => multiply(other);

  Int1DFix multiply(/* num | Iterable<num> */ other, {bool self: false}) {
    Int1DFix ret = this;

    if (!self) {
      ret = new Int1DFix.sized(length);
    }

    if (other is Int1D) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
    } else if (other is int) {
      // Nothing here
    } else if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<int>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] * other.elementAt(i);
      }
      return ret;
    } else if (other is Iterable<num>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] * other.elementAt(i).toInt();
      }
      return ret;
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] * other;
      }
    } else if (other is Int1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] * other[i];
      }
    }
    return ret;
  }

  Double1D operator /(/* num | Iterable<num> */ other) {
    if (other is Int1D) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
    } else if (other is int) {
      // Nothing here
    } else if (other is num) {
      other = other;
    } else if (other is Iterable<int>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      final ret = new Double1D.sized(length);
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] / other.elementAt(i);
      }
      return ret;
    } else if (other is Iterable<num>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      final ret = new Double1D.sized(length);
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] / other.elementAt(i);
      }
      return ret;
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    final ret = new Double1D.sized(length);
    if (other is int) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] / other;
      }
    } else if (other is Int1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] / other[i];
      }
    }
    return ret;
  }

  Double1D divide(/* E | Iterable<E> */ other, {bool self: false}) {
    if (!self) return this / other;

    throw new Exception('Operation not supported!');
  }

  Int1DFix operator ~/(/* num | Iterable<num> */ other) => truncDiv(other);

  Int1DFix truncDiv(/* num | Iterable<num> */ other, {bool self: false}) {
    Int1DFix ret = this;

    if (!self) {
      ret = new Int1DFix.sized(length);
    }

    if (other is Int1D) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
    } else if (other is int) {
      // Nothing here
    } else if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<int>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] ~/ other.elementAt(i);
      }
      return ret;
    } else if (other is Iterable<num>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] ~/ other.elementAt(i).toInt();
      }
      return ret;
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] ~/ other;
      }
    } else if (other is Int1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] ~/ other[i];
      }
    }
    return ret;
  }

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((int a, int b) => b.compareTo(a));
  }

  Int1DView _view;
  Int1DView get view => _view ??= new Int1DView.own(_data);

  Int1DFix get fixed => this;
}
