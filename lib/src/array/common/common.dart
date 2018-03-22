library grizzly.series.array.common;

import 'dart:math' as math;
import 'dart:collection';
import 'package:grizzly_series/grizzly_series.dart';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:grizzly_primitives/grizzly_primitives.dart';
import '../array.dart';
import '../sample.dart';
import 'package:text_table/text_table.dart';

part 'stats.dart';

abstract class ArrayMixin<E> implements Array<E> {
  void removeMany(IterView<E> values) {
    final set = new Set<E>.from(values.asIterable);
    for (int i = length - 1; i >= 0; i--) {
      if (set.contains(this[i])) removeAt(i);
    }
  }
}

abstract class ArrayFixMixin<E> implements ArrayFix<E> {
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

abstract class ArrayViewMixin<E> implements ArrayView<E> {
  Index1D get shape => new Index1D(length);

  IntPair<E> pairAt(int index) => intPair<E>(index, this[index]);

  Iterable<IntPair<E>> enumerate() =>
      Ranger.indices(length).map((i) => intPair<E>(i, this[i]));

  List<E> toList() => asIterable.toList();

  E get first => asIterable.first;

  E get last => asIterable.last;

  Iterable<int> get i => Ranger.indices(length);

  int count(E v) {
    int ret = 0;
    for (E item in asIterable) {
      if (v != item) ret++;
    }
    return ret;
  }

  Array<E> unique() {
    final ret = new LinkedHashSet<E>();
    for (E v in asIterable) {
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
    if (length <= count) return makeArray(asIterable);
    return slice(0, count);
  }

  /// Returns a new  [Int1D] containing last [count] elements of this array
  ///
  /// If the length of the array is shorter than [count], all elements are
  /// returned
  Array<E> tail([int count = 10]) {
    if (length <= count) return makeArray(asIterable);
    return slice(length - count);
  }

  /// Returns a new  [Array] containing random [count] elements of this array
  ///
  /// If the length of the array is shorter than [count], all elements are
  /// returned
  Array<E> sample([int count = 10]) => makeArray(sampler<E>(this, count));

  @override
  StringArray toStringArray() =>
      new String1D(asIterable.map((e) => e.toString()));

  @override
  IntSeries<E> valueCounts(
      {bool sortByValue: false, bool descending: false, name: ''}) {
    final groups = new Map<E, int>();
    for (int i = 0; i < length; i++) {
      final E v = this[i];
      if (!groups.containsKey(v)) groups[v] = 0;
      groups[v]++;
    }
    final ret = new IntSeries<E>.fromMap(groups, name: name);
    // Sort
    if (sortByValue) {
      ret.sortByLabel(descending: descending);
    } else {
      ret.sortByValue(descending: descending);
    }
    return ret;
  }

  @override
  BoolArray ne(other) {
    final ret = new Bool1D.sized(length);
    if (other is E) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] != other;
      }
    } else if (other is ArrayView<E> || other is Iterable<E>) {
      // TODO check length
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] != other[i];
      }
    } else {
      throw new UnsupportedError('Type not supported!');
    }
    return ret;
  }

  @override
  BoolArray eq(other) {
    final ret = new Bool1D.sized(length);
    if (other is E) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] == other;
      }
    } else if (other is ArrayView<E> || other is Iterable<E>) {
      // TODO check length
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] == other[i];
      }
    } else {
      throw new UnsupportedError('Type not supported!');
    }
    return ret;
  }

  @override
  BoolArray operator >=(other) {
    final ret = new Bool1D.sized(length);
    if (other is E) {
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other) >= 0;
      }
    } else if (other is ArrayView<E> || other is Iterable<E>) {
      // TODO check length
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other[i]) >= 0;
      }
    } else {
      throw new UnsupportedError('Type not supported!');
    }
    return ret;
  }

  @override
  BoolArray operator >(other) {
    final ret = new Bool1D.sized(length);
    if (other is E) {
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other) > 0;
      }
    } else if (other is ArrayView<E> || other is Iterable<E>) {
      // TODO check length
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other[i]) > 0;
      }
    } else {
      throw new UnsupportedError('Type not supported!');
    }
    return ret;
  }

  @override
  BoolArray operator <(other) {
    final ret = new Bool1D.sized(length);
    if (other is E) {
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other) < 0;
      }
    } else if (other is ArrayView<E> || other is Iterable<E>) {
      // TODO check length
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other[i]) < 0;
      }
    } else {
      throw new UnsupportedError('Type not supported!');
    }
    return ret;
  }

  @override
  BoolArray operator <=(other) {
    final ret = new Bool1D.sized(length);
    if (other is E) {
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other) <= 0;
      }
    } else if (other is ArrayView<E> || other is Iterable<E>) {
      // TODO check length
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other[i]) <= 0;
      }
    } else {
      throw new UnsupportedError('Type not supported!');
    }
    return ret;
  }
}
