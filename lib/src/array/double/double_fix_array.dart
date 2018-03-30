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

  @override
  void negate() {
    for (int i = 0; i < length; i++) {
      this[i] = -this[i];
    }
  }

  void addition(
      /* num | IterView<num> | Numeric2DView | Iterable<num> */ other) {
    if (other is IterView<double>) {
      checkLengths(this, other, subject: 'other');
    } else if (other is double) {
      // Nothing here
    } else if (other is num) {
      other = other.toDouble();
    } else if (other is Iterable<double>) {
      checkLengths(this, other, subject: 'other');
      other = new IterView<double>(other);
    } else if (other is IterView<num> || other is Iterable<num>) {
      if (other is Iterable<num>) other = new IterView<num>(other);
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) {
        this[i] += other[i].toDouble();
      }
      return;
    } else {
      throw new UnimplementedError();
    }

    if (other is double) {
      for (int i = 0; i < length; i++) {
        this[i] += other;
      }
    } else if (other is IterView<double>) {
      for (int i = 0; i < length; i++) {
        this[i] += other[i];
      }
    }
  }

  void subtract(
      /* num | IterView<num> | Numeric2DView | Iterable<num> */ other) {
    if (other is IterView<double>) {
      checkLengths(this, other, subject: 'other');
    } else if (other is double) {
      // Nothing here
    } else if (other is num) {
      other = other.toDouble();
    } else if (other is Iterable<double>) {
      checkLengths(this, other, subject: 'other');
      other = new IterView<double>(other);
    } else if (other is IterView<num> || other is Iterable<num>) {
      if (other is Iterable<num>) other = new IterView<num>(other);
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) {
        this[i] -= other[i].toDouble();
      }
      return;
    } else {
      throw new UnimplementedError();
    }

    if (other is double) {
      for (int i = 0; i < length; i++) {
        this[i] -= other;
      }
    } else if (other is IterView<double>) {
      for (int i = 0; i < length; i++) {
        this[i] -= other[i];
      }
    }
  }

  void multiply(
      /* num | IterView<num> | Numeric2DView | Iterable<num> */ other) {
    if (other is IterView<double>) {
      checkLengths(this, other, subject: 'other');
    } else if (other is double) {
      // Nothing here
    } else if (other is num) {
      other = other.toDouble();
    } else if (other is Iterable<double>) {
      checkLengths(this, other, subject: 'other');
      other = new IterView<double>(other);
    } else if (other is IterView<num> || other is Iterable<num>) {
      if (other is Iterable<num>) other = new IterView<num>(other);
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) {
        this[i] *= other[i].toDouble();
      }
      return;
    } else {
      throw new UnimplementedError();
    }

    if (other is double) {
      for (int i = 0; i < length; i++) {
        this[i] *= other;
      }
    } else if (other is IterView<double>) {
      for (int i = 0; i < length; i++) {
        this[i] *= other[i];
      }
    }
  }

  void divide(
      /* num | IterView<num> | Numeric2DView | Iterable<num> */ other) {
    if (other is IterView<double>) {
      checkLengths(this, other, subject: 'other');
    } else if (other is double) {
      // Nothing here
    } else if (other is num) {
      other = other.toDouble();
    } else if (other is Iterable<double>) {
      checkLengths(this, other, subject: 'other');
      other = new IterView<double>(other);
    } else if (other is IterView<num> || other is Iterable<num>) {
      if (other is Iterable<num>) other = new IterView<num>(other);
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) {
        this[i] /= other[i].toDouble();
      }
      return;
    } else {
      throw new UnimplementedError();
    }

    if (other is double) {
      for (int i = 0; i < length; i++) {
        this[i] /= other;
      }
    } else if (other is IterView<double>) {
      for (int i = 0; i < length; i++) {
        this[i] /= other[i];
      }
    }
  }

  void truncDiv(
          /* num | IterView<num> | Numeric2DView | Iterable<num> */ other) =>
      truncDiv(this);

  @override
  Double1DFix get logSelf {
    for (int i = 0; i < length; i++) this[i] = math.log(this[i]);
    return this;
  }

  @override
  Double1DFix get log10Self {
    for (int i = 0; i < length; i++) this[i] = math.log(this[i]) / math.ln10;
    return this;
  }

  @override
  Double1D expSelf(num x) {
    for (int i = 0; i < length; i++) this[i] = math.exp(this[i]);
    return this;
  }

  @override
  Double1DFix logNSelf(double n) {
    for (int i = 0; i < length; i++) this[i] = math.log(this[i]) / math.log(n);
    return this;
  }
}

class Double1DFix extends Object
    with
        ArrayViewMixin<double>,
        Double1DViewMixin,
        DoubleFixMixin,
        ArrayFixMixin<double>
    implements Numeric1DFix<double>, Double1DView {
  final List<double> _data;

  Double1DFix(Iterable<double> data)
      : _data = new List<double>.from(data, growable: false);

  Double1DFix.copy(IterView<double> other)
      : _data = new List<double>.from(other.asIterable, growable: false);

  Double1DFix.own(this._data);

  Double1DFix.sized(int length, {double data: 0.0})
      : _data = new List<double>.filled(length, data);

  factory Double1DFix.shapedLike(IterView d, {double data: 0.0}) =>
      new Double1DFix.sized(d.length, data: data);

  Double1DFix.single(double data)
      : _data = new List<double>.from(<double>[data], growable: false);

  Double1DFix.gen(int length, double maker(int index))
      : _data = new List<double>.generate(length, maker, growable: false);

  factory Double1DFix.nums(iterable) {
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

  Stats<double> _stats;

  Stats<double> get stats => _stats ??= new StatsImpl<double>(this);

  Iterable<double> get asIterable => _data;

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

  Double1D unique() => super.unique();
}
