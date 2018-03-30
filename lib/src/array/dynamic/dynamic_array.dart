library grizzly.series.array.dynamic;

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
        Dynamic1DViewMixin,
        Dynamic1DFixMixin
    implements DynamicArray, Dynamic1DFix {
  List<dynamic> _data;

  Comparator comparator;

  Dynamic1D(Iterable<dynamic> data, {this.comparator: _dummyComparator})
      : _data = new List<dynamic>.from(data);

  Dynamic1D.copy(IterView<dynamic> other, {this.comparator: _dummyComparator})
      : _data = new List<dynamic>.from(other.asIterable);

  Dynamic1D.own(this._data, {this.comparator: _dummyComparator});

  Dynamic1D.sized(int length, {dynamic data, this.comparator: _dummyComparator})
      : _data = new List<dynamic>.filled(length, data, growable: true);

  factory Dynamic1D.shapedLike(IterView d,
          {dynamic data, Comparator comparator: _dummyComparator}) =>
      new Dynamic1D.sized(d.length, data: data, comparator: comparator);

  Dynamic1D.single(dynamic data, {this.comparator: _dummyComparator})
      : _data = <dynamic>[data];

  Dynamic1D.gen(int length, dynamic maker(int index),
      {this.comparator: _dummyComparator})
      : _data = new List<dynamic>.generate(length, maker);

  Iterable<dynamic> get asIterable => _data;

  int get length => _data.length;

  dynamic operator [](int i) => _data[i];

  operator []=(int i, dynamic val) {
    if (i >= _data.length) {
      throw new RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Dynamic1D slice(int start, [int end]) =>
      new Dynamic1D(_data.sublist(start, end), comparator: comparator);

  @override
  void add(dynamic a) => _data.add(a);

  void addAll(IterView<dynamic> a) => _data.addAll(a.asIterable);

  @override
  void insert(int index, dynamic a) => _data.insert(index, a);

  void sort({bool descending: false}) {}

  void keepIf(IterView<bool> mask) {
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
      _view ??= new Dynamic1DView.own(_data, comparator: comparator);

  Dynamic1DFix _fixed;
  Dynamic1DFix get fixed =>
      _fixed ??= new Dynamic1DFix.own(_data, comparator: comparator);
}
