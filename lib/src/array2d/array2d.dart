library grizzly.series.array2d;

import 'dart:math' as math;
import 'dart:collection';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:grizzly_primitives/grizzly_primitives.dart';

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

part 'bool/bool_mixin.dart';
part 'bool/bool_array2d.dart';
part 'bool/bool_fix_array2d.dart';
part 'bool/bool_axis.dart';
part 'bool/bool_view_array2d.dart';

part 'string/string_mixin.dart';
part 'string/string_array2d.dart';
part 'string/string_fix_array2d.dart';
part 'string/string_axis.dart';
part 'string/string_view_array2d.dart';

part 'double_array2d.dart';

Double2D array2D(
    /* Iterable<Iterable<num>> | Iterable<double> | Index2D */ data,
    {bool transpose: false}) {
  if (data is Iterable<Iterable<num>>) {
    if (!transpose) {
      return new Double2D.fromNum(data);
    } else {
      return new Double2D.columns(data);
    }
  } else if (data is Iterable<double>) {
    if (!transpose) {
      return new Double2D.aRow(data);
    } else {
      return new Double2D.aCol(data);
    }
  } else if (data is Index2D) {
    if (!transpose) {
      return new Double2D.shaped(data);
    } else {
      return new Double2D.shaped(data.transpose);
    }
  } else {
    throw new ArgumentError.value(data, 'data', 'Invalid value!');
  }
}

Double2D double2D(Iterable<Iterable<num>> matrix) => array2D(matrix);

Int2D int2D(/* Iterable<Iterable<int>> | Iterable<int> | Index2D */ data,
    {bool transpose: false}) {
  if (data is Iterable<Iterable<int>>) {
    if (!transpose) {
      return new Int2D(data);
    } else {
      return new Int2D.columns(data);
    }
  } else if (data is Iterable<int>) {
    if (!transpose) {
      return new Int2D.aRow(data);
    } else {
      return new Int2D.aCol(data);
    }
  } else if (data is Index2D) {
    if (!transpose) {
      return new Int2D.shaped(data);
    } else {
      return new Int2D.shaped(data.transpose);
    }
  } else {
    throw new ArgumentError.value(data, 'data', 'Invalid value!');
  }
}
