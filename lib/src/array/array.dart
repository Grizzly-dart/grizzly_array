library grizzly.series.array;

import 'package:grizzly_primitives/grizzly_primitives.dart';

import 'int/int_array.dart';
import 'double/double_array.dart';
import 'bool/bool_array.dart';
import 'string/string_array.dart';
import 'dynamic/dynamic_array.dart';

export 'int/int_array.dart';
export 'double/double_array.dart';
export 'bool/bool_array.dart';
export 'string/string_array.dart';
export 'dynamic/dynamic_array.dart';

// TODO DateTime

/// Creates a 1-dimensional array of double from given [data]
Double1D array(
    /* Iterable<num> | ArrayView<num> | double | int | Index1D */ data) {
  if (data is Iterable<num>) {
    return new Double1D.fromNums(data);
  } else if (data is Numeric1DView<num>) {
    return data.toDouble();
  } else if (data is double) {
    return new Double1D.single(data);
  } else if (data is num) {
    return new Double1D.single(data.toDouble());
  } else if (data is Index1D) {
    return new Double1D.sized(data.x);
  } else {
    throw new ArgumentError.value(data, 'data', 'Invalid value!');
  }
}

/// Creates a 1-dimensional array of integers from given [data]
Int1D ints(/* Iterable<num> | num | Index1D */ data) {
  if (data is Iterable<int>) {
    return new Int1D(data);
  } else if (data is Iterable<num>) {
    return new Int1D.fromNums(data);
  } else if (data is int) {
    return new Int1D.single(data);
  } else if (data is double) {
    return new Int1D.single(data.toInt());
  } else if (data is Index1D) {
    return new Int1D.sized(data.x);
  } else {
    throw new ArgumentError.value(data, 'data', 'Invalid value!');
  }
}

/// Creates a 1-dimensional array of double from given [data]
Double1D doubles(/* Iterable<num> | double | int | Index1D */ data) {
  if (data is Iterable<num>) {
    return new Double1D.fromNums(data);
  } else if (data is double) {
    return new Double1D.single(data);
  } else if (data is num) {
    return new Double1D.single(data.toDouble());
  } else if (data is Index1D) {
    return new Double1D.sized(data.x);
  } else {
    throw new ArgumentError.value(data, 'data', 'Invalid value!');
  }
}

/// Creates a 1-dimensional array of double from given [data]
Bool1D bools(/* Iterable<bool> | bool | Index1D */ data) {
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

/// Creates a 1-dimensional array of double from given [data]
String1D strings(/* Iterable<String> | bool | Index1D */ data) {
  if (data is Iterable<String>) {
    return new String1D(data);
  } else if (data is String) {
    return new String1D.single(data);
  } else if (data is Index1D) {
    return new String1D.sized(data.x);
  } else {
    throw new ArgumentError.value(data, 'data', 'Invalid value!');
  }
}
