part of grizzly.series.array.dynamic;

class Dynamic1DView extends Object
    with Array1DViewMixin<dynamic>, Dynamic1DViewMixin
    implements DynamicArrayView {
  List<dynamic> _data;

  Comparator comparator;

  Dynamic1DView(Iterable<dynamic> data, {this.comparator})
      : _data = new List<dynamic>.from(data);

  Dynamic1DView.copy(IterView<dynamic> other, {this.comparator})
      : _data = new List<dynamic>.from(other.asIterable);

  Dynamic1DView.own(this._data, {this.comparator});

  Dynamic1DView.sized(int length, {dynamic data, this.comparator})
      : _data = new List<dynamic>.filled(length, data);

  factory Dynamic1DView.shapedLike(IterView d,
          {dynamic data, Comparator comparator}) =>
      new Dynamic1DView.sized(d.length, data: data, comparator: comparator);

  Dynamic1DView.single(dynamic data, {this.comparator})
      : _data = new List<dynamic>(1) {
    _data[0] = data;
  }

  Dynamic1DView.gen(int length, dynamic maker(int index), {this.comparator})
      : _data = new List<dynamic>.generate(length, maker, growable: false);

  Iterable<dynamic> get asIterable => _data;

  Iterator<dynamic> get iterator => _data.iterator;

  int get length => _data.length;

  dynamic operator [](int i) => _data[i];

  Dynamic1D slice(int start, [int end]) =>
      new Dynamic1D(_data.sublist(start, end), comparator: comparator);

  Dynamic1DView get view => this;

  @override
  int get hashCode => _data.hashCode;
}
