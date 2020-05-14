part of grizzly.series.array.string;

class String1DView extends Object
    with ArrayViewMixin<String>, IterableMixin<String>, String1DViewMixin
    implements ArrayView<String>, StringArrayView {
  List<String> _data;

  /// Could be `String` or `NameMaker`
  final dynamic _name;

  String get name {
    if (_name == null) return null;
    if (_name is String) return _name;
    return _name();
  }

  String1DView(Iterable<String> data, [/* String | NameMaker */ this._name])
      : _data = new List<String>.from(data);

  String1DView.own(this._data, [/* String | NameMaker */ this._name]);

  String1DView.sized(int length,
      {String fill, dynamic /* String | NameMaker */ name})
      : _data = new List<String>.filled(length, fill),
        _name = name;

  factory String1DView.shapedLike(Iterable d,
          {String fill, dynamic /* String | NameMaker */ name}) =>
      new String1DView.sized(d.length, fill: fill, name: name);

  String1DView.single(String data, {dynamic /* String | NameMaker */ name})
      : _data = new List<String>.from(<String>[data], growable: false),
        _name = name;

  String1DView.gen(int length, String maker(int index),
      {dynamic /* String | NameMaker */ name})
      : _data = new List<String>.generate(length, maker, growable: false),
        _name = name;

  Iterator<String> get iterator => _data.iterator;

  int get length => _data.length;

  String operator [](int i) => _data[i];

  String1D slice(int start, [int end]) =>
      new String1D(_data.sublist(start, end));

  String1DView get view => this;

  @override
  int get hashCode => _data.hashCode;
}
