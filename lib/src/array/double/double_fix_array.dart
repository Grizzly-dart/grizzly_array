part of grizzly.array.double;

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

  @override
  void negate() {
    for (int i = 0; i < length; i++) {
      this[i] = -this[i];
    }
  }

  void addition(
      /* num | Iterable<num> */ other) {
    if (other is num) {
      // Nothing here
    } else if (other is Iterable<num>) {
      checkLengths(this, other, subject: 'other');
    } else {
      throw UnimplementedError();
    }

    if (other is num) {
      for (int i = 0; i < length; i++) {
        this[i] += other;
      }
    } else if (other is Iterable<num>) {
      for (int i = 0; i < length; i++) {
        this[i] += other.elementAt(i);
      }
    }
  }

  void subtract(
      /* num | Iterable<num> */ other) {
    if (other is num) {
      // Nothing here
    } else if (other is Iterable<num>) {
      checkLengths(this, other, subject: 'other');
    } else {
      throw UnimplementedError();
    }

    if (other is num) {
      for (int i = 0; i < length; i++) {
        this[i] -= other;
      }
    } else if (other is Iterable<num>) {
      for (int i = 0; i < length; i++) {
        this[i] -= other.elementAt(i);
      }
    }
  }

  void multiply(
      /* num | Iterable<num> */ other) {
    if (other is num) {
      // Nothing here
    } else if (other is Iterable<num>) {
      checkLengths(this, other, subject: 'other');
    } else {
      throw UnimplementedError();
    }

    if (other is num) {
      for (int i = 0; i < length; i++) {
        this[i] *= other;
      }
    } else if (other is Iterable<num>) {
      for (int i = 0; i < length; i++) {
        this[i] *= other.elementAt(i);
      }
    }
  }

  void divide(
      /* num | Iterable<num> */ other) {
    if (other is num) {
      // Nothing here
    } else if (other is Iterable<num>) {
      checkLengths(this, other, subject: 'other');
    } else {
      throw UnimplementedError();
    }

    if (other is num) {
      for (int i = 0; i < length; i++) {
        this[i] /= other;
      }
    } else if (other is Iterable<num>) {
      for (int i = 0; i < length; i++) {
        this[i] /= other.elementAt(i);
      }
    }
  }

  void truncDiv(
          /* num | Iterable<num> */ other) =>
      truncDiv(this);

  void rdivMe(
      /* num | Iterable<num> */ other) {
    if (other is Iterable<num>) {
      checkLengths(this, other, subject: 'other');
    } else if (other is num) {
      // Do nothing
    } else {
      throw UnimplementedError();
    }

    if (other is num) {
      for (int i = 0; i < length; i++) {
        this[i] = other / this[i];
      }
    } else if (other is Iterable<num>) {
      for (int i = 0; i < length; i++) {
        this[i] = other.elementAt(i) / this[i];
      }
    }
  }

  Double1DFix get logMe {
    for (int i = 0; i < length; i++) this[i] = math.log(this[i]);
    return this;
  }

  Double1DFix get log10Me {
    for (int i = 0; i < length; i++) this[i] = math.log(this[i]) / math.ln10;
    return this;
  }

  Double1D expMe(num x) {
    for (int i = 0; i < length; i++) this[i] = math.exp(this[i]);
    return this;
  }

  Double1DFix logNMe(double n) {
    for (int i = 0; i < length; i++) this[i] = math.log(this[i]) / math.log(n);
    return this;
  }
}

class Double1DFix extends Object
    with
        ArrayViewMixin<double>,
        ArrayFixMixin<double>,
        IterableMixin<double>,
        Double1DViewMixin,
        DoubleFixMixin
    implements Numeric1DFix<double>, Double1DView {
  final List<double> _data;

  /// Could be `String` or `NameMaker`
  final dynamic _name;

  String get name {
    if (_name == null) return null;
    if (_name is String) return _name;
    return _name();
  }

  Double1DFix(Iterable<double> data, [/* String | NameMaker */ this._name])
      : _data = List<double>.from(data, growable: false);

  Double1DFix.own(this._data, [/* String | NameMaker */ this._name]);

  Double1DFix.sized(int length,
      {double fill: 0.0, dynamic /* String | NameMaker */ name})
      : _data = List<double>.filled(length, fill),
        _name = name;

  factory Double1DFix.shapedLike(Iterable d,
          {double fill: 0.0, dynamic /* String | NameMaker */ name}) =>
      Double1DFix.sized(d.length, fill: fill, name: name);

  Double1DFix.single(double data, {dynamic /* String | NameMaker */ name})
      : _data = List<double>.from(<double>[data], growable: false),
        _name = name;

  Double1DFix.gen(int length, double maker(int index),
      {dynamic /* String | NameMaker */ name})
      : _data = List<double>.generate(length, maker, growable: false),
        _name = name;

  factory Double1DFix.fromNums(Iterable<num> iterable,
      {dynamic /* String | NameMaker */ name}) {
    final list = Double1DFix.sized(iterable.length, name: name);
    for (int i = 0; i < iterable.length; i++) {
      list[i] = iterable.elementAt(i).toDouble();
    }
    return list;
  }

  Stats<double> _stats;

  Stats<double> get stats => _stats ??= StatsImpl<double>(this);

  Iterator<double> get iterator => _data.iterator;

  int get length => _data.length;

  double operator [](int i) => _data[i];

  operator []=(int i, double val) {
    if (i >= _data.length) {
      throw RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Double1D slice(int start, [int end]) => Double1D(_data.sublist(start, end));

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
    return Double1DFix(this).floorToDouble();
  }

  Double1DFix ceilToDouble({bool self: false}) {
    if (self) {
      for (int i = 0; i < length; i++) {
        _data[i] = _data[i].ceilToDouble();
      }
      return this;
    }
    return Double1DFix(this).ceilToDouble();
  }

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((double a, double b) => b.compareTo(a));
  }

  Double1DView _view;
  Double1DView get view => _view ??= Double1DView.own(_data);

  @override
  Double1DFix get fixed => this;

  Double1D unique() => super.unique();
}
