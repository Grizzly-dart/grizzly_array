library grizzly.series.array;

import 'dart:math' as math;
import 'dart:collection';
import 'dart:typed_data';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:grizzly_primitives/grizzly_primitives.dart';

import 'package:grizzly_array/src/array2d/array2d.dart';

export 'int/int_array.dart';
export 'double/double_array.dart';

part 'bool/bool_array.dart';
part 'bool/bool_fix_array.dart';
part 'bool/bool_view_array.dart';

part 'string/string_array.dart';
part 'string/string_fix_array.dart';
part 'string/string_view_array.dart';

//TODO DateTime
//TODO String

/// Creates a 1-dimensional array of double from given [data]
Double1D array(/* Iterable<num> | double | int | Index1D */ data) {
  if (data is Iterable<num>) {
    return new Double1D.fromNum(data);
  } else if (data is double) {
    return new Double1D.single(data);
  } else if (data is int) {
    return new Double1D.sized(data);
  } else if (data is Index1D) {
    return new Double1D.sized(data.x);
  } else {
    throw new ArgumentError.value(data, 'data', 'Invalid value!');
  }
}

/// Creates a 1-dimensional array of integers from given [data]
Int1D int1D(/* Iterable<num> | double | int | Index1D */ data) {
  if (data is Iterable<int>) {
    return new Int1D(data);
  } else if (data is double) {
    return new Int1D.single(data.toInt());
  } else if (data is int) {
    return new Int1D.single(data);
  } else if (data is Index1D) {
    return new Int1D.sized(data.x);
  } else {
    throw new ArgumentError.value(data, 'data', 'Invalid value!');
  }
}

/// Creates a 1-dimensional array of double from given [data]
Double1D double1D(/* Iterable<num> | double | int | Index1D */ data) {
  if (data is Iterable<num>) {
    return new Double1D.fromNum(data);
  } else if (data is double) {
    return new Double1D.single(data);
  } else if (data is Index1D) {
    return new Double1D.sized(data.x);
  } else {
    throw new ArgumentError.value(data, 'data', 'Invalid value!');
  }
}

/// Creates a 1-dimensional array of double from given [data]
Bool1D bool1D(/* Iterable<bool> | bool */ data) {
  if (data is Iterable<bool>) {
    return new Bool1D(data);
  } else if (data is bool) {
    return new Bool1D.single(data);
  } else if (data is Index1D) {
    return new Bool1D.sized(data.x);
  } else {
    throw new ArgumentError.value(data, 'data', 'Invalid value!');
  }
}
