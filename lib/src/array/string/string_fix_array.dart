part of grizzly.series.array.string;

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
        String1DViewMixin,
        ArrayViewMixin<String>,
        ArrayFixMixin<String>,
        String1DFixMixin
    implements ArrayFix<String>, String1DView, StringArrayFix {
  List<String> _data;

  String1DFix(Iterable<String> data)
      : _data = new List<String>.from(data, growable: false);

  String1DFix.copy(IterView<String> other)
      : _data = new List<String>.from(other.asIterable);

  String1DFix.own(this._data);

  String1DFix.sized(int length, {String data})
      : _data = new List<String>.filled(length, data);

  factory String1DFix.shapedLike(IterView d, {String data}) =>
      new String1DFix.sized(d.length, data: data);

  String1DFix.single(String data) : _data = <String>[data];

  String1DFix.gen(int length, String maker(int index))
      : _data = new List<String>.generate(length, maker, growable: false);

  Iterable<String> get asIterable => _data;

  Iterator<String> get iterator => _data.iterator;

  int get length => _data.length;

  String operator [](int i) => _data[i];

  operator []=(int i, String val) {
    if (i > _data.length) {
      throw new RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  String1D slice(int start, [int end]) =>
      new String1D(_data.sublist(start, end));

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((String a, String b) => b.compareTo(a));
  }

  String1DView _view;
  String1DView get view => _view ??= new String1DView.own(_data);

  String1DFix get fixed => this;
}
