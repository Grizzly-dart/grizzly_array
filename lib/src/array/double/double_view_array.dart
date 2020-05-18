part of grizzly.array.double;

class Double1DView extends Object
    with ArrayViewMixin<double>, IterableMixin<double>, Double1DViewMixin
    implements Numeric1DView<double> {
  final List<double> _data;

  /// Could be `String` or `NameMaker`
  final dynamic _name;

  String get name {
    if (_name == null) return null;
    if (_name is String) return _name;
    return _name();
  }

  Double1DView(Iterable<double> iterable, [/* String | NameMaker */ this._name])
      : _data = List<double>.from(iterable);

  Double1DView.own(this._data, [/* String | NameMaker */ this._name]);

  Double1DView.sized(int length,
      {double fill: 0.0, dynamic /* String | NameMaker */ name})
      : _data = List<double>.filled(length, fill),
        _name = name;

  factory Double1DView.shapedLike(Iterable d,
          {double fill: 0.0, dynamic /* String | NameMaker */ name}) =>
      Double1DView.sized(d.length, fill: fill, name: name);

  Double1DView.single(double data, {dynamic /* String | NameMaker */ name})
      : _data = List<double>.from([data], growable: false),
        _name = name;

  Double1DView.gen(int length, double maker(int index),
      {dynamic /* String | NameMaker */ name})
      : _data = List<double>.generate(length, maker, growable: false),
        _name = name;

  factory Double1DView.fromNums(Iterable<num> iterable,
      {dynamic /* String | NameMaker */ name}) {
    final list = List<double>(iterable.length);
    for (int i = 0; i < list.length; i++) {
      list[i] = iterable.elementAt(i)?.toDouble();
    }
    return Double1DView.own(list, name);
  }

  Stats<double> _stats;

  Stats<double> get stats => _stats ??= StatsImpl<double>(this);

  Iterator<double> get iterator => _data.iterator;

  int get length => _data.length;

  Index1D get shape => Index1D(_data.length);

  double operator [](int i) => _data[i];

  Double1D slice(int start, [int end]) => Double1D(_data.sublist(start, end));

  int count(double v, {double absTol: 1e-8}) => super.count(v, absTol: absTol);

  Double1DView get view => this;

  Double1D unique() => super.unique();
}
