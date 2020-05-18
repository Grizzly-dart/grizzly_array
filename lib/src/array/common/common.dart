library grizzly.array.common;

import 'dart:math' as math;
import 'dart:collection';
import 'package:grizzly_range/grizzly_range.dart';
//import 'package:grizzly_series/grizzly_series.dart';
import 'package:grizzly_primitives/grizzly_primitives.dart';
import 'package:grizzly_series/grizzly_series.dart';
import '../array.dart';
import '../sample.dart';
import 'package:text_table/text_table.dart';
import 'package:grizzly_range/grizzly_range.dart' as ranger;

part 'stats.dart';

abstract class ArrayMixin<E> implements Array<E> {
  void removeMany(Iterable<E> values) {
    final set = Set<E>.from(values);
    for (int i = length - 1; i >= 0; i--) {
      if (set.contains(this[i])) removeAt(i);
    }
  }

  set setAll(Iterable<E> other) {
    if (length == other.length) {
      for (int i = 0; i < length; i++) this[i] = other.elementAt(i);
      return;
    }

    if (length > other.length) {
      removeRange(other.length);
      for (int i = 0; i < length; i++) this[i] = other.elementAt(i);
      return;
    }

    for (int i = 0; i < length; i++) this[i] = other.elementAt(i);
    addAll(other.skip(length));
  }
}

abstract class ArrayFixMixin<E> implements ArrayFix<E> {
  /// Sets all elements in the array to given value [v]
  set set(E v) {
    for (int i = 0; i < length; i++) {
      this[i] = v;
    }
  }

  set setAll(Iterable<E> other) {
    if (other.length != length)
      throw ArgumentError.value(other, 'other', 'Size mismatch!');

    for (int i = 0; i < length; i++) this[i] = other.elementAt(i);
  }
}

abstract class ArrayViewMixin<E> implements ArrayView<E> {
  Index1D get shape => Index1D(length);

  MapEntry<int, E> pairAt(int index) => MapEntry<int, E>(index, this[index]);

  Iterable<MapEntry<int, E>> enumerate() =>
      indices(length).map((i) => MapEntry<int, E>(i, this[i]));

  Iterable<int> get i => indices(length);

  int count(E v) {
    int ret = 0;
    for (E item in this) {
      if (v != item) ret++;
    }
    return ret;
  }

  Array<E> unique() {
    final ret = LinkedHashSet<E>();
    for (E v in this) {
      if (!ret.contains(v)) ret.add(v);
    }
    return makeArray(ret);
  }

  Int1D uniqueIndices() {
    final ret = LinkedHashMap<E, int>();
    for (int i = 0; i < length; i++) {
      E v = this[i];
      if (!ret.containsKey(v)) {
        ret[v] = i;
      }
    }
    return Int1D(ret.values);
  }

  /// Returns a new  [Int1D] containing first [count] elements of this array
  ///
  /// If the length of the array is shorter than [count], all elements are
  /// returned
  Array<E> head([int count = 10]) {
    if (length <= count) return makeArray(this);
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

  /// Returns a new  [Array] containing random [count] elements of this array
  ///
  /// If the length of the array is shorter than [count], all elements are
  /// returned
  Array<E> sample([int count = 10]) => makeArray(sampler<E>(this, count));

  @override
  StringArray toStringArray() => String1D(this.map((e) => e.toString()));

  @override
  IntSeries<E> valueCounts(
      {bool sortByValue: false, bool descending: false, name: ''}) {
    final groups = Map<E, int>();
    for (int i = 0; i < length; i++) {
      final E v = this[i];
      if (!groups.containsKey(v)) groups[v] = 0;
      groups[v]++;
    }
    final ret = IntSeries<E>.fromMap(groups, name: name);
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
    final ret = Bool1D.sized(length);
    if (other is E) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] != other;
      }
    } else if (other is Iterable<E>) {
      if (other.length != length)
        throw LengthMismatch(
            expected: length, found: other.length, subject: 'other');
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] != other.elementAt(i);
      }
    } else {
      throw UnsupportedError('Type not supported!');
    }
    return ret;
  }

  @override
  BoolArray eq(other) {
    final ret = Bool1D.sized(length);
    if (other is E) {
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] == other;
      }
    } else if (other is Iterable<E>) {
      if (other.length != length)
        throw LengthMismatch(
            expected: length, found: other.length, subject: 'other');
      for (int i = 0; i < length; i++) {
        ret[i] = this[i] == other.elementAt(i);
      }
    } else {
      throw UnsupportedError('Type not supported!');
    }
    return ret;
  }

  @override
  BoolArray operator >=(other) {
    final ret = Bool1D.sized(length);
    if (other is E) {
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other) >= 0;
      }
    } else if (other is Iterable<E>) {
      if (other.length != length)
        throw LengthMismatch(
            expected: length, found: other.length, subject: 'other');
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other.elementAt(i)) >= 0;
      }
    } else {
      throw UnsupportedError('Type not supported!');
    }
    return ret;
  }

  @override
  BoolArray operator >(other) {
    final ret = Bool1D.sized(length);
    if (other is E) {
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other) > 0;
      }
    } else if (other is Iterable<E>) {
      if (other.length != length)
        throw LengthMismatch(
            expected: length, found: other.length, subject: 'other');
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other.elementAt(i)) > 0;
      }
    } else {
      throw UnsupportedError('Type not supported!');
    }
    return ret;
  }

  @override
  BoolArray operator <(other) {
    final ret = Bool1D.sized(length);
    if (other is E) {
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other) < 0;
      }
    } else if (other is Iterable<E>) {
      if (other.length != length)
        throw LengthMismatch(
            expected: length, found: other.length, subject: 'other');
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other.elementAt(i)) < 0;
      }
    } else {
      throw UnsupportedError('Type not supported!');
    }
    return ret;
  }

  @override
  BoolArray operator <=(other) {
    final ret = Bool1D.sized(length);
    if (other is E) {
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other) <= 0;
      }
    } else if (other is Iterable<E>) {
      if (other.length != length)
        throw LengthMismatch(
            expected: length, found: other.length, subject: 'other');
      for (int i = 0; i < length; i++) {
        ret[i] = compareValue(this[i], other.elementAt(i)) <= 0;
      }
    } else {
      throw UnsupportedError('Type not supported!');
    }
    return ret;
  }

  bool operator ==(other) {
    if (other is Iterable<E>) {
      if (other.length != length) return false;
      for (int i = 0; i < length; i++) {
        if (this[i] != other.elementAt(i)) return false;
      }
      return true;
    }
    return false;
  }

  String toString() {
    final tab = table(ranger.indices(length).map((i) => i.toString()).toList());
    tab.row(toStringArray().toList());
    return tab.toString();
  }
}
