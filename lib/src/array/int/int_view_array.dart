part of grizzly.array.int;

void checkLengths(expected, found, {String subject}) {
  if (expected.length != found.length)
    LengthMismatch(
        expected: expected.length, found: found.length, subject: subject);
}

class Int1DView extends Object
    with ArrayViewMixin<int>, IterableMixin<int>, Int1DViewMixin
    implements Numeric1DView<int> {
  final Iterable<int> _data;

  /// Could be `String` or `NameMaker`
  final dynamic _name;

  String get name {
    if (_name == null) return null;
    if (_name is String) return _name;
    return _name();
  }

  Int1DView(Iterable<int> data, [/* String | NameMaker */ this._name])
      : _data = List<int>.from(data, growable: false);

  /// Creates [Int1DView] from [_data] and also takes ownership of it. It is
  /// efficient than other ways of creating [Int1DView] because it involves no
  /// copying.
  Int1DView.own(this._data, [/* String | NameMaker */ this._name]);

  Int1DView.sized(int length,
      {int fill: 0, dynamic /* String | NameMaker */ name})
      : _data = ranger.ConstantIterable<int>(fill, length),
        _name = name;

  factory Int1DView.shapedLike(Iterable d,
          {int fill: 0, dynamic /* String | NameMaker */ name}) =>
      Int1DView.sized(d.length, fill: fill, name: name);

  Int1DView.single(int data, {dynamic /* String | NameMaker */ name})
      : _data = List<int>.from(<int>[data], growable: false),
        _name = name;

  Int1DView.gen(int length, int maker(int index),
      {dynamic /* String | NameMaker */ name})
      : _data = List<int>.generate(length, maker, growable: false),
        _name = name;

  factory Int1DView.fromNums(Iterable<num> iterable,
      [/* String | NameMaker */ name]) {
    final list = List<int>(iterable.length);
    for (int i = 0; i < list.length; i++)
      list[i] = iterable.elementAt(i)?.toInt();
    return Int1DView.own(list, name);
  }

  factory Int1DView.range(int start, int stop,
          {int step: 1, dynamic /* String | NameMaker */ name}) =>
      Int1DView.own(ranger.range(start, stop, step), name);

  factory Int1DView.until(int stop,
          {int step: 1, dynamic /* String | NameMaker */ name}) =>
      Int1DView.own(ranger.until(stop, step), name);

  Stats<int> _stats;

  Stats<int> get stats => _stats ??= StatsImpl<int>(this);

  Iterator<int> get iterator => _data.iterator;

  int get length => _data.length;

  int operator [](int i) => _data.elementAt(i);

  Int1D slice(int start, [int end]) =>
      Int1D(_data.toList(growable: false).sublist(start, end));

  Int1DView get view => this;

  @override
  int get hashCode => _data.hashCode;

  Int1D unique() => super.unique();
}
