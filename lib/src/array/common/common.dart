library grizzly.series.array.common;

import 'dart:collection';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:grizzly_primitives/grizzly_primitives.dart';
import '../array.dart';
import '../sample.dart';

abstract class Array1DViewMixin<E> implements ArrayView<E> {
  Index1D get shape => new Index1D(length);

  IntPair<E> pairAt(int index) => intPair<E>(index, this[index]);

  Iterable<IntPair<E>> enumerate() =>
      Ranger.indices(length).map((i) => intPair<E>(i, this[i]));

  E get first => iterable.first;

  E get last => iterable.last;

  Iterable<int> get i => Ranger.indices(length);

  int count(E v) {
    int ret = 0;
    for (E item in iterable) {
      if (v != item) ret++;
    }
    return ret;
  }

  Array<E> unique() {
    final ret = new LinkedHashSet<E>();
    for (E v in iterable) {
      if (!ret.contains(v)) ret.add(v);
    }
    return makeArray(ret);
  }

  Int1D uniqueIndices() {
    final ret = new LinkedHashMap<E, int>();
    for (int i = 0; i < length; i++) {
      E v = this[i];
      if (!ret.containsKey(v)) {
        ret[v] = i;
      }
    }
    return new Int1D(ret.values);
  }

  /// Returns a new  [Int1D] containing first [count] elements of this array
  ///
  /// If the length of the array is shorter than [count], all elements are
  /// returned
  Array<E> head([int count = 10]) {
    if (length <= count) return makeArray(iterable);
    return slice(0, count);
  }

  /// Returns a new  [Int1D] containing last [count] elements of this array
  ///
  /// If the length of the array is shorter than [count], all elements are
  /// returned
  Array<E> tail([int count = 10]) {
    if (length <= count) return makeArray(iterable);
    return slice(length - count);
  }

  /// Returns a new  [Array] containing random [count] elements of this array
  ///
  /// If the length of the array is shorter than [count], all elements are
  /// returned
  Array<E> sample([int count = 10]) => makeArray(sampler<E>(this, count));

/* TODO
  @override
  IntSeries<double> valueCounts(
      {bool sortByValue: false,
      bool ascending: false,
      bool dropNull: false,
      dynamic name: ''}) {
    final groups = new Map<double, List<int>>();
    for (int i = 0; i < length; i++) {
      final double v = _data[i];
      if (!groups.containsKey(v)) groups[v] = <int>[0];
      groups[v][0]++;
    }
    final ret = new IntSeries<double>.fromMap(groups, name: name);
    // Sort
    if (sortByValue) {
      ret.sortByIndex(ascending: ascending, inplace: true);
    } else {
      ret.sortByValue(ascending: ascending, inplace: true);
    }
    return ret;
  }
  */
}

abstract class Array1DFixMixin<E> implements ArrayFix<E> {
  /// Sets all elements in the array to given value [v]
  void set(E v) {
    for (int i = 0; i < length; i++) {
      this[i] = v;
    }
  }

  void assign(ArrayView<E> other) {
    if (other.length != length)
      throw new ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int i = 0; i < length; i++) this[i] = other[i];
  }
}
