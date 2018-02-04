library grizzly.series.array.int;

import 'dart:math' as math;
import 'dart:typed_data';
import 'package:grizzly_primitives/grizzly_primitives.dart';
import 'package:grizzly_array/src/array2d/array2d.dart';
import '../array.dart';
import '../common/common.dart';

part 'int_fix_array.dart';
part 'int_view_array.dart';
part 'int_mixin.dart';

class Int1D extends Object
    with Int1DViewMixin, IntFixMixin, Array1DViewMixin<int>
    implements Numeric1D<int>, Int1DFix {
  List<int> _data;

  Int1D([Iterable<int> data = const <int>[]])
      : _data = new List<int>.from(data);

  Int1D.copy(ArrayView<int> other) : _data = new List<int>.from(other.iterable);

  /// Creates [Int1D] from [_data] and also takes ownership of it. It is
  /// efficient than other ways of creating [Int1D] because it involves no
  /// copying.
  Int1D.own(this._data);

  Int1D.sized(int length, {int data: 0})
      : _data = new List<int>.filled(length, data);

  Int1D.shapedLike(ArrayView d, {int data: 0})
      : _data = new List<int>.filled(d.length, data);

  Int1D.single(int data) : _data = <int>[data];

  Int1D.gen(int length, int maker(int index)) : _data = new List<int>(length) {
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

    if (i == _data.length) {
      _data.add(val);
      return;
    }

    _data[i] = val;
  }

  Int1D slice(int start, [int end]) => new Int1D(_data.sublist(start, end));

  @override
  void add(int a) => _data.add(a);

  @override
  void insert(int index, int a) => _data.insert(index, a);

  Int1D operator +(/* num | Iterable<num> */ other) => addition(other);

  Int1D addition(/* num | Iterable<num> */ other, {bool self: false}) {
    Int1D ret = this;
    if (!self) ret = new Int1D.sized(length);

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

  Int1D operator -(/* num | Iterable<num> */ other) => subtract(other);

  Int1D subtract(/* num | Iterable<num> */ other, {bool self: false}) {
    Int1D ret = this;
    if (!self) {
      ret = new Int1D.sized(length);
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

  Int1D operator *(/* num | Iterable<num> */ other) => multiply(other);

  Int1D multiply(/* num | Iterable<num> */ other, {bool self: false}) {
    Int1D ret = this;

    if (!self) {
      ret = new Int1D.sized(length);
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

  Int1D operator ~/(/* num | Iterable<num> */ other) => truncDiv(other);

  Int1D truncDiv(/* num | Iterable<num> */ other, {bool self: false}) {
    Int1D ret = this;

    if (!self) {
      ret = new Int1D.sized(length);
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

  void mask(Array<bool> mask) {
    if (mask.length != _data.length) throw new Exception('Length mismatch!');

    int retLength = mask.count(true);
    final ret = new Int32List(retLength);
    int idx = 0;
    for (int i = 0; i < mask.length; i++) {
      if (mask[i]) ret[idx++] = _data[i];
    }
    _data = ret;
  }

  Int1DView _view;
  Int1DView get view => _view ??= new Int1DView.own(_data);

  Int1DFix _fixed;
  Int1DFix get fixed => _fixed ??= new Int1DFix.own(_data);

  String toString() => _data.toString();
}
