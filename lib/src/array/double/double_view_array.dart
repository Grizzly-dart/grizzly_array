part of grizzly.series.array.double;

class Double1DView extends Object
    with Array1DViewMixin<double>, Double1DViewMixin
    implements Numeric1DView<double> {
  final List<double> _data;

  Double1DView(Iterable<double> iterable)
      : _data = new Float64List.fromList(iterable.toList());

  Double1DView.own(this._data);

  Double1DView.sized(int length, {double data: 0.0})
      : _data = new Float64List(length) {
    for (int i = 0; i < length; i++) {
      _data[i] = data;
    }
  }

  factory Double1DView.shapedLike(Iterable d, {double data: 0.0}) =>
      new Double1DView.sized(d.length, data: data);

  Double1DView.single(double data) : _data = new Float64List(1) {
    _data[0] = data;
  }

  Double1DView.gen(int length, double maker(int index))
      : _data = new Float64List(length) {
    for (int i = 0; i < length; i++) {
      _data[i] = maker(i);
    }
  }

  factory Double1DView.fromNum(Iterable<num> iterable) {
    final list = new Float64List(iterable.length);
    final Iterator<num> ite = iterable.iterator;
    ite.moveNext();
    for (int i = 0; i < list.length; i++) {
      list[i] = ite.current.toDouble();
      ite.moveNext();
    }
    return new Double1DView.own(list);
  }

  Iterable<double> get iterable => _data;

  Iterator<double> get iterator => _data.iterator;

  int get length => _data.length;

  Index1D get shape => new Index1D(_data.length);

  double operator [](int i) => _data[i];

  Double1D slice(int start, [int end]) =>
      new Double1D(_data.sublist(start, end));

  Double1DFix operator +(/* num | Iterable<num> */ other) => addition(other);

  Double1DFix addition(/* num | Iterable<num> */ other) {
    Double1D ret = new Double1D.sized(length);

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

  Double1DFix subtract(/* num | Iterable<num> */ other) {
    Double1D ret = new Double1D.sized(length);

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

  Double1DFix multiply(/* num | Iterable<num> */ other) {
    Double1D ret = new Double1D.sized(length);

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

  Double1DFix divide(/* E | Iterable<E> */ other) {
    Double1D ret = new Double1D.sized(length);

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

  Int1DFix truncDiv(/* num | Iterable<num> */ other) => this ~/ other;

  Double1DView get view => this;
}
