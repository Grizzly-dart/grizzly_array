part of grizzly.series.array;

class Bool1DView extends Object implements ArrayView<bool>, BoolArrayView {
  List<bool> _data;

  Bool1DView(Iterable<bool> data) : _data = new List<bool>.from(data);

  Bool1DView.make(this._data);

  Bool1DView.sized(int length, {bool data: false})
      : _data = new List<bool>(length) {
    for (int i = 0; i < length; i++) {
      _data[i] = data;
    }
  }

  factory Bool1DView.shapedLike(Iterable d, {bool data: false}) =>
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

  @override
  Bool1DView makeView(Iterable<bool> newData) => new Bool1DView(newData);

  Bool1DFix makeFix(Iterable<bool> newData) => new Bool1DFix(newData);

  Bool1D makeArray(Iterable<bool> newData) => new Bool1D(newData);

  Iterable<bool> get iterable => _data;

  Iterator<bool> get iterator => _data.iterator;

  int get length => _data.length;

  Index1D get shape => new Index1D(_data.length);

  bool operator [](int i) => _data[i];

  Bool1D clone() => new Bool1D(_data);

  Bool1D slice(int start, [int end]) => new Bool1D(_data.sublist(start, end));

  bool get first => _data.first;

  bool get last => _data.last;

  int count(bool v) {
    int ret = 0;
    if (v) {
      for (bool item in _data) if (item) ret++;
    } else {
      for (bool item in _data) if (!item) ret--;
    }
    return ret;
  }

  bool get min {
    bool min;
    for (int i = 0; i < _data.length; i++) {
      final bool d = _data[i];
      if (d == null) continue;
      if (!d)
        return false;
      else
        min = true;
    }
    return min;
  }

  bool get max {
    bool max;
    for (int i = 0; i < _data.length; i++) {
      final bool d = _data[i];
      if (d == null) continue;
      if (d)
        return true;
      else
        max = false;
    }
    return max;
  }

  int get argMin {
    int minPos;
    for (int i = 0; i < _data.length; i++) {
      final bool d = _data[i];
      if (d == null) continue;
      if (!d)
        return i;
      else
        minPos ??= i;
    }
    return minPos;
  }

  int get argMax {
    int maxPos;
    for (int i = 0; i < _data.length; i++) {
      final bool d = _data[i];
      if (d == null)
        continue;
      else
        maxPos = i;
    }
    return maxPos;
  }

  IntPair<bool> pairAt(int index) => intPair<bool>(index, _data[index]);

  Iterable<IntPair<bool>> enumerate() =>
      Ranger.indices(_data.length).map((i) => intPair<bool>(i, _data[i]));

  int get sum {
    int sum = 0;
    for (int i = 0; i < _data.length; i++) {
      final bool d = _data[i];
      if (d == null) continue;
      if (d) sum++;
    }
    return sum;
  }

  double get mean {
    if (length == 0) return 0.0;
    return sum / length;
  }

  /// Returns a new  [Int1D] containing first [count] elements of this array
  ///
  /// If the length of the array is shorter than [count], all elements are
  /// returned
  Bool1D head([int count = 10]) {
    if (length <= count) return makeArray(_data);
    return makeArray(_data.sublist(0, count));
  }

  /// Returns a new  [Int1D] containing last [count] elements of this array
  ///
  /// If the length of the array is shorter than [count], all elements are
  /// returned
  Bool1D tail([int count = 10]) {
    if (length <= count) return makeArray(_data);
    return makeArray(_data.sublist(length - count));
  }

  /// Returns a new  [Array] containing random [count] elements of this array
  ///
  /// If the length of the array is shorter than [count], all elements are
  /// returned
  Bool1D sample([int count = 10]) => makeArray(_sample<bool>(_data, count));

  Bool2D to2D() => new Bool2D.make([new Bool1D(_data)]);

  Bool2D repeat({int repeat: 1, bool transpose: false}) {
    if (!transpose) {
      return new Bool2D.repeatCol(_data, repeat + 1);
    } else {
      return new Bool2D.repeatRow(_data, repeat + 1);
    }
  }

  Bool2D get transpose {
    final ret = new Bool2D.sized(length, 1);
    for (int i = 0; i < length; i++) {
      ret[i][0] = _data[i];
    }
    return ret;
  }

  Bool1D unique() {
    final ret = new LinkedHashSet<bool>();
    for (bool v in _data) {
      if (!ret.contains(v)) ret.add(v);
    }
    return new Bool1D(ret);
  }

  Int1D uniqueIndices() {
    final ret = new LinkedHashMap<bool, int>();
    for (int i = 0; i < _data.length; i++) {
      bool v = _data[i];
      if (!ret.containsKey(v)) {
        ret[v] = i;
      }
    }
    return new Int1D(ret.values);
  }

  bool operator ==(final other) {
    if (other is! Array<bool>) return false;

    if (other is Array<bool>) {
      if (length != other.length) return false;
      for (int i = 0; i < length; i++) {
        if (_data[i] != other[i]) return false;
      }
      return true;
    }

    return false;
  }

  Bool1DView get view => this;

  /* TODO
  @override
  IntSeries<bool> valueCounts(
      {bool sortByValue: false,
      bool ascending: false,
      bool dropNull: false,
      dynamic name: ''}) {
    final groups = new Map<bool, List<int>>();

    for (int i = 0; i < length; i++) {
      final bool v = _data[i];
      if (!groups.containsKey(v)) groups[v] = <int>[0];
      groups[v][0]++;
    }

    final ret = new IntSeries<bool>.fromMap(groups, name: name);

    // Sort
    if (sortByValue) {
      ret.sortByIndex(ascending: ascending, inplace: true);
    } else {
      ret.sortByValue(ascending: ascending, inplace: true);
    }

    return ret;
  }
  */

  bool get allTrue {
    for (int i = 0; i < length; i++) {
      final bool val = _data[i];
      if (val == null) continue;
      if (!val) return false;
    }
    return true;
  }

  bool get allFalse {
    for (int i = 0; i < length; i++) {
      final bool val = _data[i];
      if (val == null) continue;
      if (val) return false;
    }
    return true;
  }

  bool get anyTrue {
    for (int i = 0; i < length; i++) {
      final bool val = _data[i];
      if (val == null) continue;
      if (val) return true;
    }
    return false;
  }

  bool get anyFalse {
    for (int i = 0; i < length; i++) {
      final bool val = _data[i];
      if (val == null) continue;
      if (!val) return true;
    }
    return false;
  }

  @override
  int get hashCode => _data.hashCode;
}
