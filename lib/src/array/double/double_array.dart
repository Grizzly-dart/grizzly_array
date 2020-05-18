library grizzly.array.double;

import 'dart:math' as math;
import 'dart:collection';
import 'package:grizzly_primitives/grizzly_primitives.dart';
import 'package:grizzly_array/src/array2d/array2d.dart';
import '../array.dart';
import '../common/common.dart';
import 'package:grizzly_range/grizzly_range.dart' as ranger;
import 'package:grizzly_series/grizzly_series.dart';

part 'double_view_array.dart';
part 'double_fix_array.dart';
part 'double_mixin.dart';

class Double1D extends Object
    with
        ArrayViewMixin<double>,
        ArrayFixMixin<double>,
        ArrayMixin<double>,
        IterableMixin<double>,
        Double1DViewMixin,
        DoubleFixMixin
    implements Numeric1D<double>, Double1DFix {
  List<double> _data;

  String _name;

  String get name => _name;

  set name(String value) => _name = value;

  Double1D(Iterable<double> data, [this._name])
      : _data = List<double>.from(data);

  Double1D.own(this._data, {String name}) : _name = name;

  Double1D.sized(int length, {double fill: 0.0, String name})
      : _data = List<double>.filled(length, fill, growable: true),
        _name = name;

  factory Double1D.shapedLike(Iterable d, {double fill: 0.0, String name}) =>
      Double1D.sized(d.length, fill: fill, name: name);

  Double1D.single(double data, {String name})
      : _data = List<double>.from(<double>[data]),
        _name = name;

  Double1D.gen(int length, double maker(int index), {String name})
      : _data = List<double>.generate(length, maker),
        _name = name;

  factory Double1D.fromNums(Iterable<num> iterable, {String name}) {
    final list = Double1D.sized(iterable.length, name: name);
    for (int i = 0; i < iterable.length; i++) {
      list[i] = iterable.elementAt(i)?.toDouble();
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

  @override
  void add(double a) => _data.add(a);

  void addAll(Iterable<double> a) => _data.addAll(a);

  @override
  void insert(int index, double a) => _data.insert(index, a);

  Double1DFix sqrt({bool self: false}) {
    if (self) {
      for (int i = 0; i < length; i++) _data[i] = math.sqrt(_data[i]);
      return this;
    }
    return super.sqrt();
  }

  void clear() => _data.clear();

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

  void keepByMask(Iterable<bool> mask) {
    if (mask.length != _data.length) throw Exception('Length mismatch!');

    for (int i = length - 1; i >= 0; i--) {
      if (!mask.elementAt(i)) _data.removeAt(i);
    }
  }

  void removeAt(int pos) => _data.removeAt(pos);

  void removeAtMany(ArrayView<int> pos) {
    final poss = pos.unique()..sort(descending: true);
    if (poss.first >= _data.length) throw RangeError.index(poss.last, this);

    for (int pos in poss) _data.removeAt(pos);
  }

  void removeRange(int start, [int end]) {
    _data.removeRange(start, end ?? length);
  }

  void remove(double value, {bool onlyFirst: false, double absTol: 1e-8}) {
    double vLow = value - absTol;
    double vHigh = value + absTol;
    if (onlyFirst) {
      for (int i = 0; i < length; i++) {
        if (_data[i] > vLow && _data[i] < vHigh) {
          removeAt(i);
          break;
        }
      }
    } else {
      for (int i = length - 1; i >= 0; i--) {
        if (_data[i] > vLow && _data[i] < vHigh) removeAt(i);
      }
    }
  }

  Double1DView _view;
  Double1DView get view => _view ??= Double1DView.own(_data);

  Double1DFix _fixed;
  Double1DFix get fixed => _fixed ??= Double1DFix.own(_data);

  Double1D unique() => super.unique();
}
