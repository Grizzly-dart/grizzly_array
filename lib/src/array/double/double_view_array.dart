part of grizzly.series.array.double;

class Double1DView extends Object
    with ArrayViewMixin<double>, Double1DViewMixin
    implements Numeric1DView<double> {
  final List<double> _data;

  Double1DView(Iterable<double> iterable)
      : _data = new List<double>.from(iterable);

  Double1DView.copy(IterView<double> other)
      : _data = new List<double>.from(other.asIterable, growable: false);

  Double1DView.own(this._data);

  Double1DView.sized(int length, {double data: 0.0})
      : _data = new List<double>.filled(length, data);

  factory Double1DView.shapedLike(IterView d, {double data: 0.0}) =>
      new Double1DView.sized(d.length, data: data);

  Double1DView.single(double data)
      : _data = new List<double>.from([data], growable: false);

  Double1DView.gen(int length, double maker(int index))
      : _data = new List<double>.generate(length, maker, growable: false);

  factory Double1DView.fromNum(Iterable<num> iterable) {
    final list = new List<double>(iterable.length);
    final Iterator<num> ite = iterable.iterator;
    ite.moveNext();
    for (int i = 0; i < list.length; i++) {
      list[i] = ite.current.toDouble();
      ite.moveNext();
    }
    return new Double1DView.own(list);
  }

  Stats<double> _stats;

  Stats<double> get stats => _stats ??= new StatsImpl<double>(this);

  Iterable<double> get asIterable => _data;

  Iterator<double> get iterator => _data.iterator;

  int get length => _data.length;

  Index1D get shape => new Index1D(_data.length);

  double operator [](int i) => _data[i];

  Double1D slice(int start, [int end]) =>
      new Double1D(_data.sublist(start, end));

  int count(double v, {double absTol: 1e-8}) => super.count(v, absTol: absTol);

  Double1DView get view => this;
}
