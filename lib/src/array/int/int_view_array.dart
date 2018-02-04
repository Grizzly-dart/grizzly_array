part of grizzly.series.array.int;

class Int1DView extends Object
    with Int1DViewMixin, Array1DViewMixin<int>
    implements Numeric1DView<int> {
  final List<int> _data;

  Int1DView(Iterable<int> data) : _data = new Int32List.fromList(data.toList());

  /// Creates [Int1DView] from [_data] and also takes ownership of it. It is
  /// efficient than other ways of creating [Int1DView] because it involves no
  /// copying.
  Int1DView.own(this._data);

  Int1DView.sized(int length, {int data: 0}) : _data = new Int32List(length) {
    for (int i = 0; i < length; i++) {
      _data[i] = data;
    }
  }

  factory Int1DView.shapedLike(ArrayView d, {int data: 0}) =>
      new Int1DView.sized(d.length, data: data);

  Int1DView.single(int data) : _data = new Int32List.fromList(<int>[data]);

  Int1DView.gen(int length, int maker(int index))
      : _data = new Int32List(length) {
    for (int i = 0; i < length; i++) {
      _data[i] = maker(i);
    }
  }

  Iterable<int> get iterable => _data;

  Iterator<int> get iterator => _data.iterator;

  int get length => _data.length;

  int operator [](int i) => _data[i];

  Int1D slice(int start, [int end]) => new Int1D(_data.sublist(start, end));

  Int1DFix operator +(/* num | Iterable<num> */ other) => addition(other);

  Int1DFix addition(/* num | Iterable<num> */ other, {bool self: false}) {
    Int1D ret = new Int1D.sized(length);

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

  Int1DFix subtract(/* num | Iterable<num> */ other) {
    Int1D ret = new Int1D.sized(length);

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

  Int1DFix multiply(/* num | Iterable<num> */ other) {
    Int1D ret = new Int1D.sized(length);

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

  Double1DFix operator /(/* num | Iterable<num> */ other) {
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

  Double1D divide(/* E | Iterable<E> */ other) {
    return this / other;
  }

  Int1DFix operator ~/(/* num | Iterable<num> */ other) => truncDiv(other);

  Int1DFix truncDiv(/* num | Iterable<num> */ other) {
    Int1D ret = new Int1D.sized(length);

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

  Int1DView get view => this;

  @override
  int get hashCode => _data.hashCode;
}
