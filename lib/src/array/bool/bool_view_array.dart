part of grizzly.series.array.bool;

class Bool1DView extends Object
    with ArrayViewMixin<bool>, Bool1DViewMixin, IterableMixin<bool>
    implements ArrayView<bool>, BoolArrayView {
  final List<bool> _data;

  /// Could be `String` or `NameMaker`
  final dynamic _name;

  String get name {
    if (_name == null) return null;
    if (_name is String) return _name;
    return _name();
  }

  Bool1DView(Iterable<bool> data, [/* String | NameMaker */ this._name])
      : _data = new List<bool>.from(data);

  Bool1DView.own(this._data, [/* String | NameMaker */ this._name]);

  Bool1DView.sized(int length,
      {bool fill: false, dynamic /* String | NameMaker */ name})
      : _data = new List<bool>.filled(length, fill),
        _name = name;

  factory Bool1DView.shapedLike(Iterable d,
          {bool fill: false, dynamic /* String | NameMaker */ name}) =>
      new Bool1DView.sized(d.length, fill: fill, name: name);

  Bool1DView.single(bool data, {dynamic /* String | NameMaker */ name})
      : _data = new List<bool>.from([data]),
        _name = name;

  Bool1DView.gen(int length, bool maker(int index),
      {dynamic /* String | NameMaker */ name})
      : _data = new List<bool>.generate(length, maker, growable: false),
        _name = name;

  Iterator<bool> get iterator => _data.iterator;

  int get length => _data.length;

  bool operator [](int i) => _data[i];

  Bool1D slice(int start, [int end]) => new Bool1D(_data.sublist(start, end));

  Bool1DView get view => this;

  @override
  int get hashCode => _data.hashCode;
}
