library grizzly.array.dynamic;

import 'dart:collection';
import 'package:grizzly_primitives/grizzly_primitives.dart';
import 'package:grizzly_array/src/array2d/array2d.dart';
import '../array.dart';
import '../common/common.dart';

part 'dynamic_fix_array.dart';
part 'dynamic_view_array.dart';
part 'dynamic_minix.dart';

class Dynamic1D extends Object
    with
        ArrayViewMixin<dynamic>,
        ArrayFixMixin<dynamic>,
        ArrayMixin<dynamic>,
        IterableMixin<dynamic>,
        Dynamic1DViewMixin,
        Dynamic1DFixMixin
    implements DynamicArray, Dynamic1DFix {
  List<dynamic> _data;

  String _name;

  String get name => _name;

  set name(String value) => _name = value;

  Comparator comparator;

  Dynamic1D(Iterable<dynamic> data,
      {this.comparator: _dummyComparator, String name})
      : _data = List<dynamic>.from(data),
        _name = name;

  Dynamic1D.own(this._data, {this.comparator: _dummyComparator, String name})
      : _name = name;

  Dynamic1D.sized(int length,
      {dynamic fill, this.comparator: _dummyComparator, String name})
      : _data = List<dynamic>.filled(length, fill, growable: true),
        _name = name;

  factory Dynamic1D.shapedLike(Iterable d,
          {dynamic fill,
          Comparator comparator: _dummyComparator,
          String name}) =>
      Dynamic1D.sized(d.length, fill: fill, comparator: comparator, name: name);

  Dynamic1D.single(dynamic data,
      {this.comparator: _dummyComparator, String name})
      : _data = <dynamic>[data],
        _name = name;

  Dynamic1D.gen(int length, dynamic maker(int index),
      {this.comparator: _dummyComparator, String name})
      : _data = List<dynamic>.generate(length, maker),
        _name = name;

  Iterator<dynamic> get iterator => _data.iterator;

  int get length => _data.length;

  dynamic operator [](int i) => _data[i];

  operator []=(int i, dynamic val) {
    if (i >= _data.length) {
      throw RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Dynamic1D slice(int start, [int end]) =>
      Dynamic1D(_data.sublist(start, end), comparator: comparator);

  @override
  void add(dynamic a) => _data.add(a);

  void addAll(Iterable<dynamic> a) => _data.addAll(a);

  @override
  void insert(int index, dynamic a) => _data.insert(index, a);

  void clear() => _data.clear();

  void sort({bool descending: false}) {}

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

  void remove(dynamic value, {bool onlyFirst: false}) {
    if (onlyFirst) {
      _data.remove(value);
    } else {
      for (int i = length - 1; i >= 0; i--) {
        if (_data[i] == value) removeAt(i);
      }
    }
  }

  Dynamic1DView _view;
  Dynamic1DView get view =>
      _view ??= Dynamic1DView.own(_data, comparator: comparator);

  Dynamic1DFix _fixed;
  Dynamic1DFix get fixed =>
      _fixed ??= Dynamic1DFix.own(_data, comparator: comparator);
}
