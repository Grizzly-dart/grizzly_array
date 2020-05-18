part of grizzly.array.dynamic;

int _dummyComparator(a, b) => 0;

class Dynamic1DView extends Object
    with ArrayViewMixin<dynamic>, IterableMixin<dynamic>, Dynamic1DViewMixin
    implements DynamicArrayView {
  List<dynamic> _data;

  /// Could be `String` or `NameMaker`
  final dynamic _name;

  String get name {
    if (_name == null) return null;
    if (_name is String) return _name;
    return _name();
  }

  Comparator comparator;

  Dynamic1DView(Iterable<dynamic> data,
      {this.comparator: _dummyComparator,
      dynamic /* String | NameMaker */ name})
      : _data = List<dynamic>.from(data),
        _name = name;

  Dynamic1DView.own(this._data,
      {this.comparator, dynamic /* String | NameMaker */ name})
      : _name = name;

  Dynamic1DView.sized(int length,
      {dynamic fill,
      this.comparator: _dummyComparator,
      dynamic /* String | NameMaker */ name})
      : _data = List<dynamic>.filled(length, fill),
        _name = name;

  factory Dynamic1DView.shapedLike(Iterable d,
          {dynamic fill,
          Comparator comparator: _dummyComparator,
          dynamic /* String | NameMaker */ name}) =>
      Dynamic1DView.sized(d.length,
          fill: fill, comparator: comparator, name: name);

  Dynamic1DView.single(dynamic data,
      {this.comparator: _dummyComparator,
      dynamic /* String | NameMaker */ name})
      : _data = List<dynamic>.from([data]),
        _name = name;

  Dynamic1DView.gen(int length, dynamic maker(int index),
      {this.comparator: _dummyComparator,
      dynamic /* String | NameMaker */ name})
      : _data = List<dynamic>.generate(length, maker, growable: false),
        _name = name;

  Iterator<dynamic> get iterator => _data.iterator;

  int get length => _data.length;

  dynamic operator [](int i) => _data[i];

  Dynamic1D slice(int start, [int end]) =>
      Dynamic1D(_data.sublist(start, end), comparator: comparator);

  Dynamic1DView get view => this;

  @override
  int get hashCode => _data.hashCode;
}
