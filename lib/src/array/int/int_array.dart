library grizzly.series.array.int;

import 'dart:collection';
import 'dart:math' as math;
import 'package:grizzly_primitives/grizzly_primitives.dart';
import 'package:grizzly_array/src/array2d/array2d.dart';
import '../array.dart';
import '../common/common.dart';

part 'int_fix_array.dart';
part 'int_view_array.dart';
part 'int_mixin.dart';

class Int1D extends Object
    with
        ArrayViewMixin<int>,
        ArrayFixMixin<int>,
        ArrayMixin<int>,
        IterableMixin<int>,
        Int1DViewMixin,
        IntFixMixin
    implements Numeric1D<int>, Int1DFix {
  final List<int> _data;

  String _name;

  String get name => _name;

  set name(String value) => _name = value;

  Int1D(Iterable<int> data, [this._name]) : _data = List<int>.from(data);

  /// Creates [Int1D] from [_data] and also takes ownership of it. It is
  /// efficient than other ways of creating [Int1D] because it involves no
  /// copying.
  Int1D.own(this._data, [this._name]);

  Int1D.sized(int length, {int fill: 0, String name})
      : _data = List<int>.filled(length, fill, growable: true),
        _name = name;

  factory Int1D.shapedLike(Iterable d, {int fill: 0, String name}) =>
      Int1D.sized(d.length, fill: fill, name: name);

  Int1D.single(int data, {String name})
      : _data = <int>[data],
        _name = name;

  Int1D.gen(int length, int maker(int index), [this._name])
      : _data = List<int>.generate(length, maker);

  factory Int1D.fromNums(Iterable<num> iterable, [String name]) {
    final list = Int1D.sized(iterable.length, name: name);
    for (int i = 0; i < iterable.length; i++)
      list[i] = iterable.elementAt(i).toInt();
    return list;
  }

  factory Int1D.range(int start, int stop, {int step: 1, String name}) =>
      Int1D.own(
          Ranger.range(start, stop, step).toList(growable: false), name);

  factory Int1D.until(int start, int stop, {int step: 1, String name}) =>
      Int1D.own(Ranger.until(stop, step).toList(growable: false), name);

  Stats<int> _stats;

  Stats<int> get stats => _stats ??= StatsImpl<int>(this);

  Iterator<int> get iterator => _data.iterator;

  int get length => _data.length;

  int operator [](int i) => _data[i];

  operator []=(int i, int val) {
    if (i >= _data.length) {
      throw RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Int1D slice(int start, [int end]) => Int1D(_data.sublist(start, end));

  @override
  void add(int a) => _data.add(a);

  void addAll(Iterable<int> a) => _data.addAll(a);

  @override
  void insert(int index, int a) => _data.insert(index, a);

  void clear() => _data.clear();

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((int a, int b) => b.compareTo(a));
  }

  void keepIf(Iterable<bool> mask) {
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

  void remove(int value, {bool onlyFirst: false}) {
    if (onlyFirst) {
      _data.remove(value);
    } else {
      for (int i = length - 1; i >= 0; i--) {
        if (_data[i] == value) removeAt(i);
      }
    }
  }

  Int1DView _view;
  Int1DView get view => _view ??= Int1DView.own(_data);

  Int1DFix _fixed;
  Int1DFix get fixed => _fixed ??= Int1DFix.own(_data);

  Int1D unique() => super.unique();
}
