import 'dart:collection';

import 'package:grizzly_array/grizzly_array.dart';
import 'package:grizzly_range/grizzly_range.dart' as librange;

extension IterableExt<T> on Iterable<T> {
  List<T> unique() {
    final ret = LinkedHashSet<T>();
    for (T v in this) {
      if (!ret.contains(v)) ret.add(v);
    }
    return ret.toList();
  }
}

extension ComparableListExt<T extends Comparable> on List<T> {
  void zort({bool descending: false}) {
    if(isEmpty) return;

    if (!descending)
      sort();
    else
      sort((T a, T b) => b.compareTo(a));
  }
}

extension ListExt<T> on List<T> {
  void keepByMask(Iterable<bool> mask) {
    if (mask.length != length) throw LengthMismatch();

    for (int i = length - 1; i >= 0; i--) {
      if (!mask.elementAt(i)) removeAt(i);
    }
  }

  void removeAtMany(Iterable<int> pos) {
    final poss = pos.unique()..zort(descending: true);
    if (poss.first >= length) throw RangeError.index(poss.last, this);

    for (int pos in poss) {
      removeAt(pos);
    }
  }

  void removeMany(Iterable<T> values) {
    final set = Set<T>.from(values);
    for (int i = length - 1; i >= 0; i--) {
      if (set.contains(this[i])) removeAt(i);
    }
  }

  set content(Iterable<T> other) {
    if (length == other.length) {
      for (int i = 0; i < length; i++) this[i] = other.elementAt(i);
      return;
    }

    if (length > other.length) {
      removeRange(other.length, length);
      for (int i = 0; i < length; i++) this[i] = other.elementAt(i);
      return;
    }

    for (int i = 0; i < length; i++) this[i] = other.elementAt(i);
    addAll(other.skip(length));
  }

  /// Sets all elements in the array to given value [v]
  set set(T v) {
    for (int i = 0; i < length; i++) {
      this[i] = v;
    }
  }

  Index1D get shape => Index1D(length);

  MapEntry<int, T> pairAt(int index) => MapEntry<int, T>(index, this[index]);

  Iterable<MapEntry<int, T>> enumerate() =>
      librange.indices(length).map((i) => MapEntry<int, T>(i, this[i]));

  Iterable<int> get indices => librange.indices(length);

  int count(T v) {
    int ret = 0;
    for (T item in this) {
      if (v == item) ret++;
    }
    return ret;
  }

  List<int> uniqueIndices() {
    final ret = LinkedHashMap<T, int>();
    for (int i = 0; i < length; i++) {
      T v = this[i];
      if (!ret.containsKey(v)) {
        ret[v] = i;
      }
    }
    return List<int>.from(ret.values);
  }

  Int1D slice(int start, [int end]) => Int1D(_data.sublist(start, end));

  /// Returns a new [List] containing first [count] elements of this array
  ///
  /// If the length of the array is shorter than [count], all elements are
  /// returned
  List<T> head([int count = 10]) {
    if (length <= count) return toList();
    return slice(0, count);
  }

  /// Returns a new  [Int1D] containing last [count] elements of this array
  ///
  /// If the length of the array is shorter than [count], all elements are
  /// returned
  Array<E> tail([int count = 10]) {
    if (length <= count) return makeArray(this);
    return slice(length - count);
  }
}