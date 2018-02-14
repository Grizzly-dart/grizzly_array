part of grizzly.series.array.int;

void checkLengths(ArrayView expected, ArrayView found, {String subject}) {
  if (expected.length != found.length)
    new LengthMismatch(
        expected: expected.length, found: found.length, subject: subject);
}

class Int1DView extends Object
    with Int1DViewMixin, Array1DViewMixin<int>
    implements Numeric1DView<int> {
  final List<int> _data;

  Int1DView(Iterable<int> data)
      : _data = new List<int>.from(data, growable: false);

  Int1DView.copy(IterView<int> other)
      : _data = new List<int>.from(other.asIterable, growable: false);

  /// Creates [Int1DView] from [_data] and also takes ownership of it. It is
  /// efficient than other ways of creating [Int1DView] because it involves no
  /// copying.
  Int1DView.own(this._data);

  Int1DView.sized(int length, {int data: 0})
      : _data = new List<int>.filled(length, data);

  factory Int1DView.shapedLike(IterView d, {int data: 0}) =>
      new Int1DView.sized(d.length, data: data);

  Int1DView.single(int data)
      : _data = new List<int>.from(<int>[data], growable: false);

  Int1DView.gen(int length, int maker(int index))
      : _data = new List<int>.generate(length, maker, growable: false);

  Iterable<int> get asIterable => _data;

  Iterator<int> get iterator => _data.iterator;

  int get length => _data.length;

  int operator [](int i) => _data[i];

  Int1D slice(int start, [int end]) => new Int1D(_data.sublist(start, end));

  Int1DFix operator +(/* num | Numeric1DView | Numeric2DView */ other) =>
      addition(other);

  Int1DFix addition(final /* num | Numeric1DView | Numeric2DView */ other,
      {bool self: false}) {
    Int1D ret = new Int1D.sized(length);

    if (other is Numeric1DView<int>) {
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] + other[i];
    } else if (other is int) {
      for (int i = 0; i < length; i++) ret[i] = _data[i] + other;
    } else if (other is num) {
      int otherI = other.toInt();
      for (int i = 0; i < length; i++) ret[i] = _data[i] + otherI;
    } else if (other is Numeric1DView) {
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] + other[i].toInt();
    } else if (other is Numeric2DView<int>) {
      if (other.numRows != length)
        throw lengthMismatch(
            expected: length, found: other.numRows, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] + other[i].sum;
    } else if (other is Numeric2DView) {
      if (other.numRows != length)
        throw lengthMismatch(
            expected: length, found: other.numRows, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] + other[i].sum.toInt();
    } else {
      throw new UnsupportedError('Type not supported!');
    }

    return ret;
  }

  Int1DFix operator -(/* num | Numeric1DView | Numeric2DView */ other) =>
      subtract(other);

  Int1DFix subtract(final /* num | Numeric1DView | Numeric2DView */ other) {
    Int1D ret = new Int1D.sized(length);

    if (other is Numeric1DView<int>) {
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] - other[i];
    } else if (other is int) {
      for (int i = 0; i < length; i++) ret[i] = _data[i] - other;
    } else if (other is num) {
      int otherI = other.toInt();
      for (int i = 0; i < length; i++) ret[i] = _data[i] - otherI;
    } else if (other is Numeric1DView) {
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] - other[i].toInt();
    } else if (other is Numeric2DView<int>) {
      if (other.numRows != length)
        throw lengthMismatch(
            expected: length, found: other.numRows, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] - other[i].sum;
    } else if (other is Numeric2DView) {
      if (other.numRows != length)
        throw lengthMismatch(
            expected: length, found: other.numRows, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] - other[i].sum.toInt();
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    return ret;
  }

  Int1DFix operator *(/* num | Numeric1DView | Numeric2DView */ other) =>
      multiply(other);

  Int1DFix multiply(/* num | Numeric1DView | Numeric2DView */ other) {
    Int1D ret = new Int1D.sized(length);

    if (other is Int1D) {
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] * other[i];
    } else if (other is int) {
      for (int i = 0; i < length; i++) ret[i] = _data[i] * other;
    } else if (other is num) {
      int otherI = other.toInt();
      for (int i = 0; i < length; i++) ret[i] = _data[i] * otherI;
    } else if (other is Numeric1DView) {
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] * other[i].toInt();
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    return ret;
  }

  Double1DFix operator /(/* num | Numeric1DView | Numeric2DView */ other) {
    final ret = new Double1D.sized(length);

    if (other is Int1D) {
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] / other[i];
    } else if (other is int) {
      for (int i = 0; i < length; i++) ret[i] = _data[i] / other;
    } else if (other is num) {
      int otherI = other.toInt();
      for (int i = 0; i < length; i++) ret[i] = _data[i] / otherI;
    } else if (other is Numeric1DView) {
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] / other[i].toInt();
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    return ret;
  }

  Double1D divide(/* num | Numeric1DView | Numeric2DView */ other) =>
      this / other;

  Int1DFix operator ~/(/* num | Numeric1DView | Numeric2DView */ other) =>
      truncDiv(other);

  Int1DFix truncDiv(/* num | Numeric1DView | Numeric2DView */ other) {
    Int1D ret = new Int1D.sized(length);

    if (other is Int1D) {
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] ~/ other[i];
    } else if (other is int) {
      for (int i = 0; i < length; i++) ret[i] = _data[i] ~/ other;
    } else if (other is num) {
      int otherI = other.toInt();
      for (int i = 0; i < length; i++) ret[i] = _data[i] ~/ otherI;
    } else if (other is Numeric1DView) {
      checkLengths(this, other, subject: 'other');
      for (int i = 0; i < length; i++) ret[i] = _data[i] ~/ other[i].toInt();
    } else {
      throw new Exception('Expects num or Iterable<num>');
    }

    return ret;
  }

  Int1DView get view => this;

  @override
  int get hashCode => _data.hashCode;
}
