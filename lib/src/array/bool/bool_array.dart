library grizzly.array.bool;

import 'dart:collection';
import 'package:grizzly_primitives/grizzly_primitives.dart';
import 'package:grizzly_array/src/array2d/array2d.dart';
import 'package:grizzly_range/grizzly_range.dart' as ranger;
import '../common/common.dart';
import '../array.dart';

part 'bool_fix_array.dart';
part 'bool_view_array.dart';
part 'bool_mixin.dart';

class Bool1D extends Object
    with
        ArrayViewMixin<bool>,
        ArrayFixMixin<bool>,
        ArrayMixin<bool>,
        Bool1DViewMixin,
        IterableMixin<bool>
    implements Array<bool>, Bool1DFix, BoolArray {
  List<bool> _data;

  String _name;

  String get name => _name;

  set name(String value) => _name = value;

  Bool1D(Iterable<bool> data, [String name])
      : _data = List<bool>.from(data),
        _name = name;

  Bool1D.own(this._data, [String name]) : _name = name;

  Bool1D.sized(int length, {bool fill: false, String name})
      : _data = List<bool>.filled(length, fill, growable: true),
        _name = name;

  factory Bool1D.shapedLike(Iterable d, {bool fill: false, String name}) =>
      Bool1D.sized(d.length, fill: fill, name: name);

  Bool1D.single(bool data, {String name})
      : _data = <bool>[data],
        _name = name;

  Bool1D.gen(int length, bool maker(int index), {String name})
      : _data = List<bool>.generate(length, maker),
        _name = name;

  Iterator<bool> get iterator => _data.iterator;

  int get length => _data.length;

  bool operator [](int i) => _data[i];

  operator []=(int i, bool val) {
    if (i >= _data.length) {
      throw RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Bool1D slice(int start, [int end]) => Bool1D(_data.sublist(start, end));

  @override
  void add(bool a) => _data.add(a);

  void addAll(Iterable<bool> a) => _data.addAll(a);

  @override
  void insert(int index, bool a) => _data.insert(index, a);

  void clear() => _data.clear();

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((bool a, bool b) => b ? 1 : 0);
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

    for (int pos in poss) {
      _data.removeAt(pos);
    }
  }

  void removeRange(int start, [int end]) {
    _data.removeRange(start, end ?? length);
  }

  void remove(bool value, {bool onlyFirst: false}) {
    if (onlyFirst) {
      _data.remove(value);
    } else {
      for (int i = length - 1; i >= 0; i--) {
        if (_data[i] == value) removeAt(i);
      }
    }
  }

  Bool1DView _view;
  Bool1DView get view => _view ??= Bool1DView.own(_data);

  Bool1DFix _fixed;
  Bool1DFix get fixed => _fixed ??= Bool1DFix.own(_data);
}
