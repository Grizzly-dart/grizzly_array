part of grizzly.array.string;

abstract class String1DFixMixin implements ArrayFix<String>, StringArrayFix {
  void toLowerCase() {
    for (int i = 0; i < length; i++) {
      this[i] = this[i].toLowerCase();
    }
  }

  void toUpperCase() {
    for (int i = 0; i < length; i++) {
      this[i] = this[i].toUpperCase();
    }
  }

  void trim() {
    for (int i = 0; i < length; i++) {
      this[i] = this[i].trim();
    }
  }

  void trimLeft() {
    for (int i = 0; i < length; i++) {
      this[i] = this[i].trimLeft();
    }
  }

  void trimRight() {
    for (int i = 0; i < length; i++) {
      this[i] = this[i].trimRight();
    }
  }
}

class String1DFix extends Object
    with
        ArrayViewMixin<String>,
        ArrayFixMixin<String>,
        IterableMixin<String>,
        String1DViewMixin,
        String1DFixMixin
    implements ArrayFix<String>, String1DView, StringArrayFix {
  List<String> _data;

  /// Could be `String` or `NameMaker`
  final dynamic _name;

  String get name {
    if (_name == null) return null;
    if (_name is String) return _name;
    return _name();
  }

  String1DFix(Iterable<String> data, [/* String | NameMaker */ this._name])
      : _data = List<String>.from(data, growable: false);

  String1DFix.own(this._data, [/* String | NameMaker */ this._name]);

  String1DFix.sized(int length,
      {String fill, dynamic /* String | NameMaker */ name})
      : _data = List<String>.filled(length, fill),
        _name = name;

  factory String1DFix.shapedLike(Iterable d,
          {String fill, dynamic /* String | NameMaker */ name}) =>
      String1DFix.sized(d.length, fill: fill, name: name);

  String1DFix.single(String data, {dynamic /* String | NameMaker */ name})
      : _data = <String>[data],
        _name = name;

  String1DFix.gen(int length, String maker(int index),
      {dynamic /* String | NameMaker */ name})
      : _data = List<String>.generate(length, maker, growable: false),
        _name = name;

  Iterator<String> get iterator => _data.iterator;

  int get length => _data.length;

  String operator [](int i) => _data[i];

  operator []=(int i, String val) {
    if (i > _data.length) {
      throw RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  String1D slice(int start, [int end]) => String1D(_data.sublist(start, end));

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((String a, String b) => b.compareTo(a));
  }

  String1DView _view;
  String1DView get view => _view ??= String1DView.own(_data);

  String1DFix get fixed => this;
}
