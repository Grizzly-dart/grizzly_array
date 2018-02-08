part of grizzly.series.array.double;

abstract class DoubleFixMixin implements Numeric1DFix<double> {
  @override
  void clip({double min, double max}) {
    if (min != null && max != null) {
      for (int i = 0; i < length; i++) {
        final double d = this[i];

        if (d < min) this[i] = min;
        if (d > max) this[i] = max;
      }
      return;
    }
    if (min != null) {
      for (int i = 0; i < length; i++) {
        final double d = this[i];

        if (d < min) this[i] = min;
      }
      return;
    }
    if (max != null) {
      for (int i = 0; i < length; i++) {
        final double d = this[i];

        if (d > max) this[i] = max;
      }
      return;
    }
  }

  Double1DFix get logSelf {
    for (int i = 0; i < length; i++) this[i] = math.log(this[i]);
    return this;
  }

  Double1DFix get log10Self {
    for (int i = 0; i < length; i++) this[i] = math.log(this[i]) / math.LN10;
    return this;
  }

  Double1D expSelf(num x) {
    for (int i = 0; i < length; i++) this[i] = math.exp(this[i]);
    return this;
  }

  Double1DFix logNSelf(double n) {
    for (int i = 0; i < length; i++) this[i] = math.log(this[i]) / math.log(n);
    return this;
  }
}

class Double1DFix extends Object
    with
        Array1DViewMixin<double>,
        Double1DViewMixin,
        DoubleFixMixin,
        Array1DFixMixin<double>
    implements Numeric1DFix<double>, Double1DView {
  final List<double> _data;

  Double1DFix(Iterable<double> data)
      : _data = new List<double>.from(data, growable: false);

  Double1DFix.own(this._data);

  Double1DFix.sized(int length, {double data: 0.0})
      : _data = new List<double>.filled(length, data);

  factory Double1DFix.shapedLike(Iterable d, {double data: 0.0}) =>
      new Double1DFix.sized(d.length, data: data);

  Double1DFix.single(double data)
      : _data = new List<double>.from(<double>[data], growable: false);

  Double1DFix.gen(int length, double maker(int index))
      : _data = new List<double>.generate(length, maker, growable: false);

  factory Double1DFix.fromNum(iterable) {
    if (iterable is Numeric1DView) {
      final list = new Double1DFix.sized(iterable.length);
      for (int i = 0; i < iterable.length; i++)
        list[i] = iterable[i].toDouble();
      return list;
    } else if (iterable is Iterable<double>) {
      final list = new Double1DFix.sized(iterable.length);
      for (int i = 0; i < iterable.length; i++) {
        list[i] = iterable.elementAt(i).toDouble();
      }
      return list;
    }
    throw new UnsupportedError('Unknown type!');
  }

  Iterable<double> get asIterable => _data;

  Iterator<double> get iterator => _data.iterator;

  int get length => _data.length;

  double operator [](int i) => _data[i];

  operator []=(int i, double val) {
    if (i >= _data.length) {
      throw new RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Double1D slice(int start, [int end]) =>
      new Double1D(_data.sublist(start, end));

  Double1DFix operator +(/* num | Iterable<num> */ other) => addition(other);

  Double1DFix addition(/* num | Iterable<num> */ other, {bool self: false}) {
    Double1DFix ret = this;

    if (!self) ret = new Double1DFix.sized(length);

    if (other is Numeric1D) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
    } else if (other is num) {
      // Nothing here
    } else if (other is Iterable<num>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] + other.elementAt(i);
      }
      return ret;
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] + other;
      }
    } else if (other is Double1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] + other[i];
      }
    }
    return ret;
  }

  Double1DFix operator -(/* num | Iterable<num> */ other) => subtract(other);

  Double1DFix subtract(/* num | Iterable<num> */ other, {bool self: false}) {
    Double1DFix ret = this;

    if (!self) ret = new Double1DFix.sized(length);

    if (other is Numeric1D) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
    } else if (other is num) {
      // Nothing here
    } else if (other is Iterable<num>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] - other.elementAt(i);
      }
      return ret;
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] - other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] - other[i];
      }
    }
    return ret;
  }

  Double1DFix operator *(/* num | Iterable<num> */ other) => multiply(other);

  Double1DFix multiply(/* num | Iterable<num> */ other, {bool self: false}) {
    Double1DFix ret = this;

    if (!self) ret = new Double1DFix.sized(length);

    if (other is Numeric1D) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
    } else if (other is num) {
      // Nothing here
    } else if (other is Iterable<num>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] * other.elementAt(i);
      }
      return ret;
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] * other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] * other[i];
      }
    }
    return ret;
  }

  Double1DFix operator /(/* num | Iterable<num> */ other) => divide(other);

  Double1DFix divide(/* E | Iterable<E> */ other, {bool self: false}) {
    Double1DFix ret = this;

    if (!self) ret = new Double1DFix.sized(length);

    if (other is Numeric1D) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
    } else if (other is num) {
      // Nothing here
    } else if (other is Iterable<num>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] / other.elementAt(i);
      }
      return ret;
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] / other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] / other[i];
      }
    }
    return ret;
  }

  Int1DFix operator ~/(/* num | Iterable<num> */ other) {
    if (other is Numeric1D) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
    } else if (other is num) {
      // Nothing here
    } else if (other is Iterable<num>) {
      if (other.length != length) {
        throw new Exception('Length mismatch!');
      }
      final ret = new Int1DFix.sized(length);
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] ~/ other.elementAt(i).toInt();
      }
      return ret;
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    final ret = new Int1DFix.sized(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] ~/ other;
      }
    } else if (other is Numeric1D) {
      for (int i = 0; i < length; i++) {
        ret[i] = _data[i] ~/ other[i];
      }
    }
    return ret;
  }

  Int1DFix truncDiv(/* num | Iterable<num> */ other, {bool self: false}) {
    if (!self) return this ~/ other;
    throw new Exception('Operation not supported!');
  }

  Double1DFix sqrt({bool self: false}) {
    if (self) {
      for (int i = 0; i < length; i++) _data[i] = math.sqrt(_data[i]);
      return this;
    }
    return super.sqrt();
  }

  Double1DFix floorToDouble({bool self: false}) {
    if (self) {
      for (int i = 0; i < length; i++) {
        _data[i] = _data[i].floorToDouble();
      }
      return this;
    }
    return new Double1DFix(this.asIterable).floorToDouble();
  }

  Double1DFix ceilToDouble({bool self: false}) {
    if (self) {
      for (int i = 0; i < length; i++) {
        _data[i] = _data[i].ceilToDouble();
      }
      return this;
    }
    return new Double1DFix(this.asIterable).ceilToDouble();
  }

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((double a, double b) => b.compareTo(a));
  }

  Double1DView _view;
  Double1DView get view => _view ??= new Double1DView.own(_data);

  @override
  Double1DFix get fixed => this;
}
