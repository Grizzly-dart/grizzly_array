part of grizzly.series.array.int;

abstract class IntFixMixin implements Numeric1DFix<int> {
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

  @override
  void negate() {
    for (int i = 0; i < length; i++) {
      this[i] = -this[i];
    }
  }

  void addition(
      /* num | IterView<num> | Iterable<num> */ other) {
    if (other is IterView<int>) {
      checkLengths(this, other, subject: 'other');
    } else if (other is int) {
      // Nothing here
    } else if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<int>) {
      checkLengths(this, other, subject: 'other');
      other = new IterView<int>(other);
    } else if (other is IterView<num> || other is Iterable<num>) {
      if (other is Iterable<num>) other = new IterView<num>(other);
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) {
        this[i] += other[i].toInt();
      }
      return;
    } else {
      throw new UnimplementedError();
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        this[i] += other;
      }
    } else if (other is IterView<int>) {
      for (int i = 0; i < length; i++) {
        this[i] += other[i];
      }
    }
  }

  void subtract(
      /* num | IterView<num> | Iterable<num> */ other) {
    if (other is IterView<int>) {
      checkLengths(this, other, subject: 'other');
    } else if (other is int) {
      // Nothing here
    } else if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<int>) {
      checkLengths(this, other, subject: 'other');
      other = new IterView<int>(other);
    } else if (other is IterView<num> || other is Iterable<num>) {
      if (other is Iterable<num>) other = new IterView<num>(other);
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) {
        this[i] -= other[i].toInt();
      }
      return;
    } else {
      throw new UnimplementedError();
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        this[i] -= other;
      }
    } else if (other is IterView<int>) {
      for (int i = 0; i < length; i++) {
        this[i] -= other[i];
      }
    }
  }

  void multiply(
      /* num | IterView<num> | Iterable<num> */ other) {
    if (other is IterView<int>) {
      checkLengths(this, other, subject: 'other');
    } else if (other is int) {
      // Nothing here
    } else if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<int>) {
      checkLengths(this, other, subject: 'other');
      other = new IterView<int>(other);
    } else if (other is IterView<num> || other is Iterable<num>) {
      if (other is Iterable<num>) other = new IterView<num>(other);
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) {
        this[i] *= other[i].toInt();
      }
      return;
    } else {
      throw new UnimplementedError();
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        this[i] *= other;
      }
    } else if (other is IterView<int>) {
      for (int i = 0; i < length; i++) {
        this[i] *= other[i];
      }
    }
  }

  void divide(
          /* num | IterView<num> | Iterable<num> */ other) =>
      truncDiv(this);

  void truncDiv(
      /* num | IterView<num> | Iterable<num> */ other) {
    if (other is IterView<int>) {
      checkLengths(this, other, subject: 'other');
    } else if (other is int) {
      // Nothing here
    } else if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<int>) {
      checkLengths(this, other, subject: 'other');
      other = new IterView<int>(other);
    } else if (other is IterView<num> || other is Iterable<num>) {
      if (other is Iterable<num>) other = new IterView<num>(other);
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) {
        this[i] ~/= other[i].toInt();
      }
      return;
    } else {
      throw new UnimplementedError();
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        this[i] ~/= other;
      }
    } else if (other is IterView<int>) {
      for (int i = 0; i < length; i++) {
        this[i] ~/= other[i];
      }
    }
  }

  void rdivMe(
      /* num | IterView<num> | Iterable<num> */ other) {
    if (other is IterView<int>) {
      checkLengths(this, other, subject: 'other');
    } else if (other is int) {
      // Nothing here
    } else if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<int>) {
      checkLengths(this, other, subject: 'other');
      other = new IterView<int>(other);
    } else if (other is IterView<num> || other is Iterable<num>) {
      if (other is Iterable<num>) other = new IterView<num>(other);
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) {
        this[i] = other[i].toInt() ~/ this[i];
      }
      return;
    } else {
      throw new UnimplementedError();
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        this[i] = other ~/ this[i];
      }
    } else if (other is IterView<int>) {
      for (int i = 0; i < length; i++) {
        this[i] = other[i] ~/ this[i];
      }
    }
  }
}

class Int1DFix extends Object
    with ArrayViewMixin<int>, ArrayFixMixin<int>, Int1DViewMixin, IntFixMixin
    implements Numeric1DFix<int>, Int1DView {
  final List<int> _data;

  Int1DFix(Iterable<int> data)
      : _data = new List<int>.from(data, growable: false);

  Int1DFix.copy(IterView<int> other)
      : _data = new List<int>.from(other.asIterable, growable: false);

  /// Creates [Int1DFix] from [_data] and also takes ownership of it. It is
  /// efficient than other ways of creating [Int1DFix] because it involves no
  /// copying.
  Int1DFix.own(this._data);

  Int1DFix.sized(int length, {int data: 0})
      : _data = new List<int>.filled(length, data);

  factory Int1DFix.shapedLike(IterView d, {int data: 0}) =>
      new Int1DFix.sized(d.length, data: data);

  Int1DFix.single(int data)
      : _data = new List<int>.from(<int>[data], growable: false);

  Int1DFix.gen(int length, int maker(int index))
      : _data = new List<int>.generate(length, maker, growable: false);

  Stats<int> _stats;

  Stats<int> get stats => _stats ??= new StatsImpl<int>(this);

  Iterable<int> get asIterable => _data;

  int get length => _data.length;

  int operator [](int i) => _data[i];

  operator []=(int i, int val) {
    if (i > _data.length) {
      throw new RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Int1D slice(int start, [int end]) => new Int1D(_data.sublist(start, end));

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((int a, int b) => b.compareTo(a));
  }

  Int1DView _view;
  Int1DView get view => _view ??= new Int1DView.own(_data);

  Int1DFix get fixed => this;

  Int1D unique() => super.unique();
}
