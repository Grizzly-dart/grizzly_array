part of grizzly.array.bool;

class Bool1DFix extends Object
    with
        ArrayViewMixin<bool>,
        ArrayFixMixin<bool>,
        Bool1DViewMixin,
        IterableMixin<bool>
    implements ArrayFix<bool>, Bool1DView {
  final List<bool> _data;

  /// Could be `String` or `NameMaker`
  final dynamic _name;

  String get name {
    if (_name == null) return null;
    if (_name is String) return _name;
    return _name();
  }

  Bool1DFix(Iterable<bool> data, [dynamic /* String | NameMaker */ name])
      : _data = List<bool>.from(data, growable: false),
        _name = name;

  Bool1DFix.own(this._data, [dynamic /* String | NameMaker */ name])
      : _name = name;

  Bool1DFix.sized(int length,
      {bool fill: false, dynamic /* String | NameMaker */ name})
      : _data = List<bool>.filled(length, fill),
        _name = name;

  factory Bool1DFix.shapedLike(Iterable d,
          {bool data: false, dynamic /* String | NameMaker */ name}) =>
      Bool1DFix.sized(d.length, fill: data, name: name);

  Bool1DFix.single(bool data, {dynamic /* String | NameMaker */ name})
      : _data = <bool>[data],
        _name = name;

  Bool1DFix.gen(int length, bool maker(int index),
      {dynamic /* String | NameMaker */ name})
      : _data = List<bool>.generate(length, maker, growable: false),
        _name = name;

  Iterator<bool> get iterator => _data.iterator;

  int get length => _data.length;

  bool operator [](int i) => _data[i];

  operator []=(int i, bool val) {
    if (i > _data.length) {
      throw RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Bool1D slice(int start, [int end]) => Bool1D(_data.sublist(start, end));

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((bool a, bool b) => b ? 1 : 0);
  }

  Bool1DView _view;
  Bool1DView get view => _view ??= Bool1DView.own(_data);

  Bool1DFix get fixed => this;
}
