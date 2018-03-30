part of grizzly.series.array.dynamic;

class Dynamic1DFix extends Object
    with
        ArrayViewMixin<dynamic>,
        ArrayFixMixin<dynamic>,
        Dynamic1DViewMixin,
        Dynamic1DFixMixin
    implements Dynamic1DView, DynamicArrayFix {
  List<dynamic> _data;

  Comparator comparator;

  Dynamic1DFix(Iterable<dynamic> data, {this.comparator: _dummyComparator})
      : _data = new List<dynamic>.from(data, growable: false);

  Dynamic1DFix.copy(IterView<dynamic> other,
      {this.comparator: _dummyComparator})
      : _data = new List<dynamic>.from(other.asIterable);

  Dynamic1DFix.own(this._data, {this.comparator});

  Dynamic1DFix.sized(int length,
      {dynamic data, this.comparator: _dummyComparator})
      : _data = new List<dynamic>.filled(length, data);

  factory Dynamic1DFix.shapedLike(IterView d,
          {dynamic data, Comparator comparator: _dummyComparator}) =>
      new Dynamic1DFix.sized(d.length, data: data, comparator: comparator);

  Dynamic1DFix.single(dynamic data, {this.comparator: _dummyComparator})
      : _data = <dynamic>[data];

  Dynamic1DFix.gen(int length, dynamic maker(int index),
      {this.comparator: _dummyComparator})
      : _data = new List<dynamic>.generate(length, maker, growable: false);

  Iterable<dynamic> get asIterable => _data;

  int get length => _data.length;

  dynamic operator [](int i) => _data[i];

  operator []=(int i, val) {
    if (i > _data.length) {
      throw new RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Dynamic1D slice(int start, [int end]) =>
      new Dynamic1D(_data.sublist(start, end), comparator: comparator);

  void sort({bool descending: false}) {}

  Dynamic1DView _view;
  Dynamic1DView get view =>
      _view ??= new Dynamic1DView.own(_data, comparator: comparator);

  Dynamic1DFix get fixed => this;
}

abstract class Dynamic1DFixMixin implements ArrayFix<dynamic>, DynamicArrayFix {
}
