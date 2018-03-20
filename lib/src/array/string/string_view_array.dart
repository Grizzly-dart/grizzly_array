part of grizzly.series.array.string;

class String1DView extends Object
    with String1DViewMixin, ArrayViewMixin<String>
    implements ArrayView<String>, StringArrayView {
  List<String> _data;

  String1DView(Iterable<String> data) : _data = new List<String>.from(data);

  String1DView.copy(IterView<String> other)
      : _data = new List<String>.from(other.asIterable);

  String1DView.own(this._data);

  String1DView.sized(int length, {String data})
      : _data = new List<String>.filled(length, data);

  factory String1DView.shapedLike(IterView d, {String data}) =>
      new String1DView.sized(d.length, data: data);

  String1DView.single(String data) : _data = new List<String>(1) {
    _data[0] = data;
  }

  String1DView.gen(int length, String maker(int index))
      : _data = new List<String>.generate(length, maker, growable: false);

  Iterable<String> get asIterable => _data;

  Iterator<String> get iterator => _data.iterator;

  int get length => _data.length;

  String operator [](int i) => _data[i];

  String1D slice(int start, [int end]) =>
      new String1D(_data.sublist(start, end));

  String1DView get view => this;

  @override
  int get hashCode => _data.hashCode;
}
