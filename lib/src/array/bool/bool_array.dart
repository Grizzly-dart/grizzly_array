library grizzly.series.array.bool;

import 'package:grizzly_primitives/grizzly_primitives.dart';
import 'package:grizzly_array/src/array2d/array2d.dart';
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
        Bool1DViewMixin
    implements Array<bool>, Bool1DFix, BoolArray {
  List<bool> _data;

  Bool1D([Iterable<bool> data = const <bool>[]])
      : _data = new List<bool>.from(data);

  Bool1D.copy(IterView<bool> other)
      : _data = new List<bool>.from(other.asIterable);

  Bool1D.own(this._data);

  Bool1D.sized(int length, {bool data: false})
      : _data = new List<bool>.filled(length, data, growable: true);

  factory Bool1D.shapedLike(IterView d, {bool data: false}) =>
      new Bool1D.sized(d.length, data: data);

  Bool1D.single(bool data) : _data = <bool>[data];

  Bool1D.gen(int length, bool maker(int index))
      : _data = new List<bool>.generate(length, maker);

  Iterable<bool> get asIterable => _data;

  Iterator<bool> get iterator => _data.iterator;

  int get length => _data.length;

  bool operator [](int i) => _data[i];

  operator []=(int i, bool val) {
    if (i > _data.length) {
      throw new RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    if (i == _data.length) {
      _data.add(val);
      return;
    }

    _data[i] = val;
  }

  Bool1D slice(int start, [int end]) => new Bool1D(_data.sublist(start, end));

  @override
  void add(bool a) => _data.add(a);

  void addAll(IterView<bool> a) => _data.addAll(a.asIterable);

  @override
  void insert(int index, bool a) => _data.insert(index, a);

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((bool a, bool b) => b ? 1 : 0);
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

    for (int pos in poss.asIterable) {
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
  Bool1DView get view => _view ??= new Bool1DView.own(_data);

  Bool1DFix _fixed;
  Bool1DFix get fixed => _fixed ??= new Bool1DFix.own(_data);
}
