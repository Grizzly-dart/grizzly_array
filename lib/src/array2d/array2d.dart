library grizzly.series.array2d;

import 'dart:collection';
import 'dart:math' as math;
import 'package:grizzly_primitives/grizzly_primitives.dart';
import 'package:grizzly_range/grizzly_range.dart' as ranger;
import 'package:text_table/text_table.dart';

import 'package:grizzly_array/src/array/array.dart';

part 'common/array2d_mixin.dart';
part 'common/list.dart';
part 'common/row.dart';
part 'common/col.dart';

part 'int/int_mixin.dart';
part 'int/int_array2d.dart';
part 'int/int_fix_array2d.dart';
part 'int/int_view_array2d.dart';
part 'int/int_axis.dart';
part 'int/int_row.dart';
part 'int/int_col.dart';

part 'double/double_mixin.dart';
part 'double/double_array2d.dart';
part 'double/double_fix_array2d.dart';
part 'double/double_axis.dart';
part 'double/double_view_array2d.dart';
part 'double/double_row.dart';
part 'double/double_col.dart';

part 'bool/bool_mixin.dart';
part 'bool/bool_array2d.dart';
part 'bool/bool_fix_array2d.dart';
part 'bool/bool_axis.dart';
part 'bool/bool_view_array2d.dart';
part 'bool/bool_row.dart';
part 'bool/bool_col.dart';

part 'string/string_mixin.dart';
part 'string/string_array2d.dart';
part 'string/string_fix_array2d.dart';
part 'string/string_axis.dart';
part 'string/string_view_array2d.dart';
part 'string/string_row.dart';
part 'string/string_col.dart';

part 'dynamic/dynamic_array2d.dart';
part 'dynamic/dynamic_axis.dart';
part 'dynamic/dynamic_col.dart';
part 'dynamic/dynamic_fix_array2d.dart';
part 'dynamic/dynamic_mixin.dart';
part 'dynamic/dynamic_row.dart';
part 'dynamic/dynamic_view_array2d.dart';

Double2D array2(
    /* Iterable<Iterable<num>> | Iterable<double> | Index2D */ data,
    {bool transpose: false}) {
  if (data is Iterable<Iterable<double>>) {
    if (!transpose) {
      return Double2D(data);
    } else {
      return Double2D.columns(data);
    }
  } else if (data is Iterable<Iterable<num>>) {
    if (!transpose) {
      return Double2D.fromNums(data);
    } else {
      return Double2D.fromNums(data).transpose;
    }
  } else if (data is Iterable<double>) {
    if (!transpose) {
      return Double2D([data]);
    } else {
      return Double2D.columns([data]);
    }
  } else if (data is Iterable<num>) {
    // TODO
  } else if (data is Index2D) {
    if (!transpose) {
      return Double2D.shaped(data);
    } else {
      return Double2D.shaped(data.transpose);
    }
  } else {
    throw ArgumentError.value(data, 'data', 'Invalid value!');
  }
}

Double2D zeros(/* Index2D | Index1D | Array2DView */ spec) {
  if (spec is Index2D) {
    return Double2D.shaped(spec);
  } else if (spec is Index1D) {
    return Double2D.sized(spec.x, spec.x);
  } else if (spec is Array2DView) {
    return Double2D.shapedLike(spec);
  }
  throw ArgumentError.value(spec, 'spec', 'Invalid value!');
}

Double2D doubles2(Iterable<Iterable<num>> matrix) => array2(matrix);

Int2D ints2(/* Iterable<Iterable<int>> | Iterable<int> | Index2D */ data,
    {bool transpose: false}) {
  if (data is Iterable<Iterable<int>>) {
    if (!transpose) {
      return Int2D(data);
    } else {
      return Int2D.columns(data);
    }
  } else if (data is Iterable<int>) {
    if (!transpose) {
      return Int2D([data]);
    } else {
      return Int2D.columns([data]);
    }
  } else if (data is Index2D) {
    if (!transpose) {
      return Int2D.shaped(data);
    } else {
      return Int2D.shaped(data.transpose);
    }
  } else {
    throw ArgumentError.value(data, 'data', 'Invalid value!');
  }
}
