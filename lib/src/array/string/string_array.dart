library grizzly.array.string;

import 'dart:collection';
import 'package:grizzly_primitives/grizzly_primitives.dart';
import 'package:grizzly_array/src/array2d/array2d.dart';
import '../array.dart';
import '../common/common.dart';

part 'string_fix_array.dart';
part 'string_view_array.dart';
part 'string_minix.dart';

class String1D extends Object
    with
        ArrayViewMixin<String>,
        ArrayFixMixin<String>,
        ArrayMixin<String>,
        IterableMixin<String>,
        String1DViewMixin,
        String1DFixMixin
    implements StringArray, String1DFix {
  List<String> _data;

  String _name;

  String get name => _name;

  set name(String value) => _name = value;

  String1D(Iterable<String> data, [this._name])
      : _data = List<String>.from(data);

  String1D.own(this._data, [this._name]);

  String1D.sized(int length, {String fill, String name})
      : _data = List<String>.filled(length, fill, growable: true),
        _name = name;

  factory String1D.shapedLike(Iterable d, {String fill, String name}) =>
      String1D.sized(d.length, fill: fill, name: name);

  String1D.single(String data, {String name})
      : _data = <String>[data],
        _name = name;

  String1D.gen(int length, String maker(int index), {String name})
      : _data = List<String>.generate(length, maker),
        _name = name;

  Iterator<String> get iterator => _data.iterator;

  int get length => _data.length;

  String operator [](int i) => _data[i];

  operator []=(int i, String val) {
    if (i >= _data.length) {
      throw RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  String1D slice(int start, [int end]) => String1D(_data.sublist(start, end));

  @override
  void add(String a) => _data.add(a);

  void addAll(Iterable<String> a) => _data.addAll(a);

  void clear() => _data.clear();

  @override
  void insert(int index, String a) => _data.insert(index, a);

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((String a, String b) => b.compareTo(a));
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

  void remove(String value, {bool onlyFirst: false}) {
    if (onlyFirst) {
      _data.remove(value);
    } else {
      for (int i = length - 1; i >= 0; i--) {
        if (_data[i] == value) removeAt(i);
      }
    }
  }

  String1DView _view;
  String1DView get view => _view ??= String1DView.own(_data);

  String1DFix _fixed;
  String1DFix get fixed => _fixed ??= String1DFix.own(_data);
}
