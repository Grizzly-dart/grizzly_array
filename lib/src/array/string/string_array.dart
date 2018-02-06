library grizzly.series.array.string;

import 'package:grizzly_primitives/grizzly_primitives.dart';
import 'package:grizzly_array/src/array2d/array2d.dart';
import '../array.dart';
import '../common/common.dart';

part 'string_fix_array.dart';
part 'string_view_array.dart';
part 'string_minix.dart';

class String1D extends Object
    with
        String1DViewMixin,
        Array1DViewMixin<String>,
        Array1DFixMixin<String>,
        String1DFixMixin
    implements Array<String>, String1DFix {
  List<String> _data;

  String1D(Iterable<String> data) : _data = new List<String>.from(data);

  String1D.copy(ArrayView<String> other)
      : _data = new List<String>.from(other.iterable);

  String1D.own(this._data);

  String1D.sized(int length, {String data: ''})
      : _data = new List<String>.filled(length, data);

  factory String1D.shapedLike(ArrayView d, {String data: ''}) =>
      new String1D.sized(d.length, data: data);

  String1D.single(String data) : _data = <String>[data];

  String1D.gen(int length, String maker(int index))
      : _data = new List<String>(length) {
    for (int i = 0; i < length; i++) {
      _data[i] = maker(i);
    }
  }

  Iterable<String> get iterable => _data;

  Iterator<String> get iterator => _data.iterator;

  int get length => _data.length;

  String operator [](int i) => _data[i];

  operator []=(int i, String val) {
    if (i > _data.length) {
      throw new RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    if (i == _data.length) {
      _data.add(val);
      return;
    }

    _data[i] = val;
  }

  String1D slice(int start, [int end]) =>
      new String1D(_data.sublist(start, end));

  @override
  void add(String a) => _data.add(a);

  @override
  void insert(int index, String a) => _data.insert(index, a);

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((String a, String b) => b.compareTo(a));
  }

  void mask(ArrayView<bool> mask) {
    if (mask.length != _data.length) throw new Exception('Length mismatch!');

    for (int i = length - 1; i >= 0; i--) {
      if (!mask[i]) _data.removeAt(i);
    }
  }

  void removeAt(int pos) => _data.removeAt(pos);

  void removeAtMany(ArrayView<int> pos) {
    final poss = pos.unique()..sort(descending: true);
    if (poss.first >= _data.length) throw new RangeError.index(poss.last, this);

    for (int pos in poss.iterable) {
      _data.removeAt(pos);
    }
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

  void removeMany(ArrayView<String> values) {
    for (int i = length - 1; i >= 0; i--) {
      if (values.contains(_data[i])) removeAt(i);
    }
  }

  String1DView _view;
  String1DView get view => _view ??= new String1DView.make(_data);

  String1DFix _fixed;
  String1DFix get fixed => _fixed ??= new String1DFix.own(_data);
}
