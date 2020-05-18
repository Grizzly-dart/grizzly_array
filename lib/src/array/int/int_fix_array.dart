part of grizzly.array.int;

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
      /* num | Iterable<num> */ other) {
    if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<num>) {
      checkLengths(this, other, subject: 'other');
    } else {
      throw UnimplementedError();
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        this[i] += other;
      }
    } else if (other is Iterable<int>) {
      for (int i = 0; i < length; i++) {
        this[i] += other.elementAt(i);
      }
    } else if (other is Iterable<num>) {
      for (int i = 0; i < length; i++) {
        this[i] += other.elementAt(i).toInt();
      }
    }
  }

  void subtract(
      /* num | Iterable<num> */ other) {
    if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<num>) {
      checkLengths(this, other, subject: 'other');
    } else {
      throw UnimplementedError();
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        this[i] -= other;
      }
    } else if (other is Iterable<int>) {
      for (int i = 0; i < length; i++) {
        this[i] -= other.elementAt(i);
      }
    } else if (other is Iterable<num>) {
      for (int i = 0; i < length; i++) {
        this[i] -= other.elementAt(i).toInt();
      }
    }
  }

  void multiply(
      /* num | Iterable<num> */ other) {
    if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<num>) {
      checkLengths(this, other, subject: 'other');
    } else {
      throw UnimplementedError();
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        this[i] *= other;
      }
    } else if (other is Iterable<int>) {
      for (int i = 0; i < length; i++) {
        this[i] *= other.elementAt(i);
      }
    } else if (other is Iterable<num>) {
      for (int i = 0; i < length; i++) {
        this[i] *= other.elementAt(i).toInt();
      }
    }
  }

  void divide(
          /* num | Iterable<num> */ other) =>
      truncDiv(this);

  void truncDiv(
      /* num | Iterable<num> */ other) {
    if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<int>) {
      checkLengths(this, other, subject: 'other');
    } else {
      throw UnimplementedError();
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        this[i] ~/= other;
      }
    } else if (other is Iterable<int>) {
      for (int i = 0; i < length; i++) {
        this[i] ~/= other.elementAt(i);
      }
    } else if (other is Iterable<num>) {
      for (int i = 0; i < length; i++) {
        this[i] ~/= other.elementAt(i).toInt();
      }
    }
  }

  void rdivMe(
      /* num | Iterable<num> */ other) {
    if (other is num) {
      other = other.toInt();
    } else if (other is Iterable<num>) {
      checkLengths(this, other, subject: 'other');
    } else {
      throw UnimplementedError();
    }

    if (other is int) {
      for (int i = 0; i < length; i++) {
        this[i] = other ~/ this[i];
      }
    } else if (other is Iterable<int>) {
      for (int i = 0; i < length; i++) {
        this[i] = other.elementAt(i) ~/ this[i];
      }
    } else if (other is Iterable<num>) {
      for (int i = 0; i < length; i++) {
        this[i] = other.elementAt(i).toInt() ~/ this[i];
      }
    }
  }
}

class Int1DFix extends Object
    with
        ArrayViewMixin<int>,
        ArrayFixMixin<int>,
        IterableMixin<int>,
        Int1DViewMixin,
        IntFixMixin
    implements Numeric1DFix<int>, Int1DView {
  final List<int> _data;

  /// Could be `String` or `NameMaker`
  final dynamic _name;

  String get name {
    if (_name == null) return null;
    if (_name is String) return _name;
    return _name();
  }

  Int1DFix(Iterable<int> data, [/* String | NameMaker */ this._name])
      : _data = List<int>.from(data, growable: false);

  /// Creates [Int1DFix] from [_data] and also takes ownership of it. It is
  /// efficient than other ways of creating [Int1DFix] because it involves no
  /// copying.
  Int1DFix.own(this._data, [/* String | NameMaker */ this._name]);

  Int1DFix.sized(int length,
      {int fill: 0, dynamic /* String | NameMaker */ name})
      : _data = List<int>.filled(length, fill),
        _name = name;

  factory Int1DFix.shapedLike(Iterable d,
          {int fill: 0, dynamic /* String | NameMaker */ name}) =>
      Int1DFix.sized(d.length, fill: fill, name: name);

  Int1DFix.single(int data, {dynamic /* String | NameMaker */ name})
      : _data = List<int>.from(<int>[data], growable: false),
        _name = name;

  Int1DFix.gen(int length, int maker(int index),
      {dynamic /* String | NameMaker */ name})
      : _data = List<int>.generate(length, maker, growable: false),
        _name = name;

  factory Int1DFix.fromNums(Iterable<num> iterable, [String name]) {
    final list = Int1DFix.sized(iterable.length, name: name);
    for (int i = 0; i < iterable.length; i++)
      list[i] = iterable.elementAt(i).toInt();
    return list;
  }

  factory Int1DFix.range(int start, int stop,
          {int step: 1, dynamic /* String | NameMaker */ name}) =>
      Int1DFix.own(
          ranger.range(start, stop, step).toList(growable: false), name);

  factory Int1DFix.until(int stop,
          {int step: 1, dynamic /* String | NameMaker */ name}) =>
      Int1DFix.own(ranger.until(stop, step).toList(growable: false), name);

  Stats<int> _stats;

  Stats<int> get stats => _stats ??= StatsImpl<int>(this);

  Iterator<int> get iterator => _data.iterator;

  int get length => _data.length;

  int operator [](int i) => _data[i];

  operator []=(int i, int val) {
    if (i > _data.length) {
      throw RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Int1D slice(int start, [int end]) => Int1D(_data.sublist(start, end));

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((int a, int b) => b.compareTo(a));
  }

  Int1DView _view;
  Int1DView get view => _view ??= Int1DView.own(_data);

  Int1DFix get fixed => this;

  Int1D unique() => super.unique();
}
