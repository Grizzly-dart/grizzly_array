part of grizzly.series.array.bool;

class Bool1DView extends Object
    with Bool1DViewMixin, Array1DViewMixin<bool>
    implements ArrayView<bool>, BoolArrayView {
  final List<bool> _data;

  Bool1DView(Iterable<bool> data) : _data = new List<bool>.from(data);

  Bool1DView.copy(ArrayView<bool> other)
      : _data = new List<bool>.from(other.iterable);

  Bool1DView.own(this._data);

  Bool1DView.sized(int length, {bool data: false})
      : _data = new List<bool>(length) {
    for (int i = 0; i < length; i++) {
      _data[i] = data;
    }
  }

  factory Bool1DView.shapedLike(ArrayView d, {bool data: false}) =>
      new Bool1DView.sized(d.length, data: data);

  Bool1DView.single(bool data) : _data = new List<bool>(1) {
    _data[0] = data;
  }

  Bool1DView.gen(int length, bool maker(int index))
      : _data = new List<bool>(length) {
    for (int i = 0; i < length; i++) {
      _data[i] = maker(i);
    }
  }

  Iterable<bool> get iterable => _data;

  Iterator<bool> get iterator => _data.iterator;

  int get length => _data.length;

  bool operator [](int i) => _data[i];

  Bool1D slice(int start, [int end]) => new Bool1D(_data.sublist(start, end));

  Bool1DView get view => this;

  @override
  int get hashCode => _data.hashCode;
}
