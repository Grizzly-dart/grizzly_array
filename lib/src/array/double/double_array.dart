library grizzly.series.array.double;

import 'dart:math' as math;
import 'dart:typed_data';
import 'package:grizzly_primitives/grizzly_primitives.dart';
import 'package:grizzly_array/src/array2d/array2d.dart';
import '../array.dart';
import '../common/common.dart';

part 'double_view_array.dart';
part 'double_fix_array.dart';
part 'double_mixin.dart';

class Double1D extends Object
    with
        Array1DViewMixin<double>,
        Double1DViewMixin,
        DoubleFixMixin,
        Array1DFixMixin<double>
    implements Numeric1D<double>, Double1DFix {
  List<double> _data;

  Double1D(Iterable<double> data)
      : _data = new Float64List.fromList(data.toList());

  Double1D.copy(ArrayView<double> other)
      : _data = new List<double>.from(other.iterable);

  Double1D.own(this._data);

  Double1D.sized(int length, {double data: 0.0})
      : _data = new List<double>(length) {
    for (int i = 0; i < length; i++) {
      _data[i] = data;
    }
  }

  factory Double1D.shapedLike(Iterable d, {double data: 0.0}) =>
      new Double1D.sized(d.length, data: data);

  Double1D.single(double data) : _data = new List<double>.from(<double>[data]);

  Double1D.gen(int length, double maker(int index))
      : _data = new List<double>(length) {
    for (int i = 0; i < length; i++) {
      _data[i] = maker(i);
    }
  }

  factory Double1D.fromNum(iterable) {
    if (iterable is Numeric1DView) {
      final list = new Double1D.sized(iterable.length);
      for (int i = 0; i < iterable.length; i++)
        list[i] = iterable[i].toDouble();
      return list;
    } else if (iterable is Iterable<double>) {
      final list = new Double1D.sized(iterable.length);
      for (int i = 0; i < iterable.length; i++) {
        list[i] = iterable.elementAt(i).toDouble();
      }
      return list;
    }
    throw new UnsupportedError('Unknown type!');
  }

  Iterable<double> get iterable => _data;

  Iterator<double> get iterator => _data.iterator;

  int get length => _data.length;

  double operator [](int i) => _data[i];

  operator []=(int i, double val) {
    if (i > _data.length) {
      throw new RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    if (i == _data.length) {
      _data.add(val);
      return;
    }

    _data[i] = val;
  }

  Double1D slice(int start, [int end]) =>
      new Double1D(_data.sublist(start, end));

  @override
  void add(double a) => _data.add(a);

  @override
  void insert(int index, double a) => _data.insert(index, a);

  Double1D operator +(/* num | Iterable<num> */ other) => addition(other);

  Double1D addition(/* num | Iterable<num> */ other, {bool self: false}) {
    Double1D ret = this;

    if (!self) ret = new Double1D.sized(length);

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

  Double1D operator -(/* num | Iterable<num> */ other) => subtract(other);

  Double1D subtract(/* num | Iterable<num> */ other, {bool self: false}) {
    Double1D ret = this;

    if (!self) ret = new Double1D.sized(length);

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

  Double1D operator *(/* num | Iterable<num> */ other) => multiply(other);

  Double1D multiply(/* num | Iterable<num> */ other, {bool self: false}) {
    Double1D ret = this;

    if (!self) ret = new Double1D.sized(length);

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

  Double1D operator /(/* num | Iterable<num> */ other) => divide(other);

  Double1D divide(/* E | Iterable<E> */ other, {bool self: false}) {
    Double1D ret = this;

    if (!self) ret = new Double1D.sized(length);

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

  Int1D truncDiv(/* num | Iterable<num> */ other, {bool self: false}) {
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

  Double1D floorToDouble({bool self: false}) {
    if (self) {
      for (int i = 0; i < length; i++) {
        _data[i] = _data[i].floorToDouble();
      }
      return this;
    }
    return super.floorToDouble();
  }

  Double1D ceilToDouble({bool self: false}) {
    if (self) {
      for (int i = 0; i < length; i++) {
        _data[i] = _data[i].ceilToDouble();
      }
      return this;
    }
    return super.ceilToDouble();
  }

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((double a, double b) => b.compareTo(a));
  }

  void mask(Array<bool> mask) {
    if (mask.length != _data.length) throw new Exception('Length mismatch!');

    int retLength = mask.count(true);
    final ret = new Float64List(retLength);
    int idx = 0;
    for (int i = 0; i < mask.length; i++) {
      if (mask[i]) ret[idx++] = _data[i];
    }
    _data = ret;
  }

  void maskByPos(Array<int> pos) {
    final poss = pos.unique()..sort(descending: true);
    if (poss.first >= _data.length) throw new RangeError.index(poss.last, this);

    for (int pos in poss.iterable) {
      _data.removeAt(pos);
    }
  }

  Double1DView _view;
  Double1DView get view => _view ??= new Double1DView.own(_data);

  Double1DFix _fixed;
  Double1DFix get fixed => _fixed ??= new Double1DFix.own(_data);
}
