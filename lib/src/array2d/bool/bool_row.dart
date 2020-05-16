part of grizzly.series.array2d;

class Bool2DRow extends Object
    with Axis2DMixin<bool>, RowMixin<bool>, BoolAxis2DViewMixin
    implements Axis2D<bool> {
  final Bool2D inner;

  Bool2DRow(this.inner);

  Bool1DFix operator [](int row) => inner[row];
}
