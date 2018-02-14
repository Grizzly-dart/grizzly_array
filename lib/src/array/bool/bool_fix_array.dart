part of grizzly.series.array.bool;

class Bool1DFix extends Object
    with Array1DViewMixin<bool>, Array1DFixMixin<bool>, Bool1DViewMixin
    implements ArrayFix<bool>, Bool1DView {
  final List<bool> _data;

  Bool1DFix(Iterable<bool> data)
      : _data = new List<bool>.from(data, growable: false);

  Bool1DFix.copy(IterView<bool> other)
      : _data = new List<bool>.from(other.asIterable, growable: false);

  Bool1DFix.own(this._data);

  Bool1DFix.sized(int length, {bool data: false})
      : _data = new List<bool>.filled(length, data);

  factory Bool1DFix.shapedLike(IterView d, {bool data: false}) =>
      new Bool1DFix.sized(d.length, data: data);

  Bool1DFix.single([bool data = false]) : _data = <bool>[data];

  Bool1DFix.gen(int length, bool maker(int index))
      : _data = new List<bool>.generate(length, maker, growable: false);

  Iterable<bool> get asIterable => _data;

  Iterator<bool> get iterator => _data.iterator;

  int get length => _data.length;

  bool operator [](int i) => _data[i];

  operator []=(int i, bool val) {
    if (i > _data.length) {
      throw new RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    _data[i] = val;
  }

  Bool1D slice(int start, [int end]) => new Bool1D(_data.sublist(start, end));

  void sort({bool descending: false}) {
    if (!descending)
      _data.sort();
    else
      _data.sort((bool a, bool b) => b ? 1 : 0);
  }

  Bool1DView _view;
  Bool1DView get view => _view ??= new Bool1DView.own(_data);

  Bool1DFix get fixed => this;
}
