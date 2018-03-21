part of grizzly.series.array.int;

void checkLengths(IterView expected, IterView found, {String subject}) {
  if (expected.length != found.length)
    new LengthMismatch(
        expected: expected.length, found: found.length, subject: subject);
}

class Int1DView extends Object
    with ArrayViewMixin<int>, Int1DViewMixin
    implements Numeric1DView<int> {
  final List<int> _data;

  Int1DView(Iterable<int> data)
      : _data = new List<int>.from(data, growable: false);

  Int1DView.copy(IterView<int> other)
      : _data = new List<int>.from(other.asIterable, growable: false);

  /// Creates [Int1DView] from [_data] and also takes ownership of it. It is
  /// efficient than other ways of creating [Int1DView] because it involves no
  /// copying.
  Int1DView.own(this._data);

  Int1DView.sized(int length, {int data: 0})
      : _data = new List<int>.filled(length, data);

  factory Int1DView.shapedLike(IterView d, {int data: 0}) =>
      new Int1DView.sized(d.length, data: data);

  Int1DView.single(int data)
      : _data = new List<int>.from(<int>[data], growable: false);

  Int1DView.gen(int length, int maker(int index))
      : _data = new List<int>.generate(length, maker, growable: false);

  Stats<int> _stats;

  Stats<int> get stats => _stats ??= new StatsImpl<int>(this);

  Iterable<int> get asIterable => _data;

  Iterator<int> get iterator => _data.iterator;

  int get length => _data.length;

  int operator [](int i) => _data[i];

  Int1D slice(int start, [int end]) => new Int1D(_data.sublist(start, end));

  Int1DView get view => this;

  @override
  int get hashCode => _data.hashCode;
}
