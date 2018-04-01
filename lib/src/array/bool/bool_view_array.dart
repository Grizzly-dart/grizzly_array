part of grizzly.series.array.bool;

class Bool1DView extends Object
    with ArrayViewMixin<bool>, Bool1DViewMixin
    implements ArrayView<bool>, BoolArrayView {
  final List<bool> _data;

  Bool1DView(Iterable<bool> data) : _data = new List<bool>.from(data);

  Bool1DView.copy(IterView<bool> other)
      : _data = new List<bool>.from(other.asIterable, growable: false);

  Bool1DView.own(this._data);

  Bool1DView.sized(int length, {bool data: false})
      : _data = new List<bool>.filled(length, data);

  factory Bool1DView.shapedLike(IterView d, {bool data: false}) =>
      new Bool1DView.sized(d.length, data: data);

  Bool1DView.single(bool data) : _data = new List<bool>(1) {
    _data[0] = data;
  }

  Bool1DView.gen(int length, bool maker(int index))
      : _data = new List<bool>.generate(length, maker, growable: false);

  Iterable<bool> get asIterable => _data;

  int get length => _data.length;

  bool operator [](int i) => _data[i];

  Bool1D slice(int start, [int end]) => new Bool1D(_data.sublist(start, end));

  Bool1DView get view => this;

  @override
  int get hashCode => _data.hashCode;
}
