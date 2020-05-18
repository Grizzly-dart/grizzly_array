part of grizzly.array2d;

class Int2DRow extends Object
    with Axis2DMixin<int>, RowMixin<int>, IntAxis2DViewMixin
    implements Numeric2DAxis<int> {
  final Int2D inner;

  Int2DRow(this.inner);

  Int1DFix operator [](int row) => inner[row];
}
