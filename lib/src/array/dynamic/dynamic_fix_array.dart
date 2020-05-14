part of grizzly.series.array.dynamic;

class Dynamic1DFix extends Object
    with
        ArrayViewMixin<dynamic>,
        ArrayFixMixin<dynamic>,
        IterableMixin<dynamic>,
        Dynamic1DViewMixin,
        Dynamic1DFixMixin
    implements Dynamic1DView, DynamicArrayFix {
  List<dynamic> _data;

  /// Could be `String` or `NameMaker`
  final dynamic _name;

  String get name {
    if (_name == null) return null;
    if (_name is String) return _name;
    return _name();
  }

  Comparator comparator;

  Dynamic1DFix(Iterable<dynamic> data,
      {this.comparator: _dummyComparator,
      dynamic /* String | NameMaker */ name})
      : _data = List<dynamic>.from(data, growable: false),
        _name = name;

  Dynamic1DFix.own(this._data,
      {this.comparator, dynamic /* String | NameMaker */ name})
      : _name = name;

  Dynamic1DFix.sized(int length,
      {dynamic fill,
      this.comparator: _dummyComparator,
      dynamic /* String | NameMaker */ name})
      : _data = List<dynamic>.filled(length, fill),
        _name = name;

  factory Dynamic1DFix.shapedLike(Iterable d,
          {dynamic fill,
          Comparator comparator: _dummyComparator,
          dynamic /* String | NameMaker */ name}) =>
      Dynamic1DFix.sized(d.length,
          fill: fill, comparator: comparator, name: name);

  Dynamic1DFix.single(dynamic data,
      {this.comparator: _dummyComparator,
      dynamic /* String | NameMaker */ name})
      : _data = <dynamic>[data],
        _name = name;

  Dynamic1DFix.gen(int length, dynamic maker(int index),
      {this.comparator: _dummyComparator,
      dynamic /* String | NameMaker */ name})
      : _data = List<dynamic>.generate(length, maker, growable: false),
        _name = name;

  Iterator<dynamic> get iterator => _data.iterator;

  int get length => _data.length;

  dynamic operator [](int i) => _data[i];

  operator []=(int i, val) {
    if (i > _data.length) {
      throw RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Dynamic1D slice(int start, [int end]) =>
      Dynamic1D(_data.sublist(start, end), comparator: comparator);

  void sort({bool descending: false}) {}

  Dynamic1DView _view;
  Dynamic1DView get view =>
      _view ??= Dynamic1DView.own(_data, comparator: comparator);

  Dynamic1DFix get fixed => this;
}

abstract class Dynamic1DFixMixin implements ArrayFix<dynamic>, DynamicArrayFix {
}
