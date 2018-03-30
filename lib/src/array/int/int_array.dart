library grizzly.series.array.int;

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
        Int1DViewMixin,
        IntFixMixin
    implements Numeric1D<int>, Int1DFix {
  List<int> _data;

  Int1D([Iterable<int> data = const <int>[]])
      : _data = new List<int>.from(data);

  Int1D.copy(IterView<int> other)
      : _data = new List<int>.from(other.asIterable);

  /// Creates [Int1D] from [_data] and also takes ownership of it. It is
  /// efficient than other ways of creating [Int1D] because it involves no
  /// copying.
  Int1D.own(this._data);

  Int1D.sized(int length, {int data: 0})
      : _data = new List<int>.filled(length, data, growable: true);

  Int1D.shapedLike(IterView d, {int data: 0})
      : _data = new List<int>.filled(d.length, data);

  Int1D.single(int data) : _data = <int>[data];

  Int1D.gen(int length, int maker(int index))
      : _data = new List<int>.generate(length, maker);

  factory Int1D.fromNum(iterable) {
    if (iterable is IterView<num>) {
      final list = new Int1D.sized(iterable.length);
      for (int i = 0; i < iterable.length; i++) list[i] = iterable[i].toInt();
      return list;
    } else if (iterable is Iterable<num>) {
      final list = new Int1D.sized(iterable.length);
      for (int i = 0; i < iterable.length; i++) {
        list[i] = iterable.elementAt(i).toInt();
      }
      return list;
    }
    throw new UnsupportedError('Unknown type!');
  }

  Stats<int> _stats;

  Stats<int> get stats => _stats ??= new StatsImpl<int>(this);

  Iterable<int> get asIterable => _data;

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

  void addAll(IterView<int> a) => _data.addAll(a.asIterable);

  @override
  void insert(int index, int a) => _data.insert(index, a);

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((int a, int b) => b.compareTo(a));
  }

  void mask(ArrayView<bool> mask) {
    if (mask.length != _data.length) throw new Exception('Length mismatch!');

    int retLength = mask.count(true);
    final ret = new List<int>()..length = retLength;
    int idx = 0;
    for (int i = 0; i < mask.length; i++) {
      if (mask[i]) ret[idx++] = _data[i];
    }
    _data = ret;
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
  Int1DView get view => _view ??= new Int1DView.own(_data);

  Int1DFix _fixed;
  Int1DFix get fixed => _fixed ??= new Int1DFix.own(_data);
}
