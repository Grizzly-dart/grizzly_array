part of grizzly.series.array;

class Bool1D extends Bool1DFix implements Array<bool> {
  Bool1D([Iterable<bool> data = const <bool>[]]) : super(data);

  Bool1D.make(List<bool> data) : super.make(data);

  Bool1D.sized(int length, {bool data: false})
      : super.sized(length, data: data);

  Bool1D.shapedLike(Iterable d, {bool data: false})
      : super.sized(d.length, data: data);

  Bool1D.single(bool data) : super.single(data);

  Bool1D.gen(int length, bool maker(int index)) : super.gen(length, maker);

  operator []=(int i, bool val) {
    if (i > _data.length) {
      throw new RangeError.range(i, 0, _data.length, 'i', 'Out of range!');
    }

    if (i == _data.length) {
      _data.add(val);
      return;
    }

    _data[i] = val;
  }

  @override
  void add(bool a) => _data.add(a);

  @override
  void insert(int index, bool a) => _data.insert(index, a);

  void mask(Array<bool> mask) {
    if(mask.length != _data.length) throw new Exception('Length mismatch!');

    for(int i = length - 1; i >= 0; i--) {
      if(!mask[i]) _data.removeAt(i);
    }
  }

  Bool1DFix _fixed;
  Bool1DFix get fixed => _fixed ??= new Bool1DFix.make(_data);
}
