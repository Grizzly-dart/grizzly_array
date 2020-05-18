part of grizzly.array2d;

class Double2DRow extends Object
    with Axis2DMixin<double>, RowMixin<double>, DoubleAxis2DViewMixin
    implements Numeric2DAxis<double> {
  final Double2D inner;

  Double2DRow(this.inner);

  Double1DFix operator [](int row) => inner[row];
}
