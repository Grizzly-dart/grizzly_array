part of grizzly.series.array2d;

class Double2DRow extends Object
    with
        AxisFixMixin<double>,
        AxisMixin<double>,
        AxisViewMixin<double>,
        RowMixin<double>,
        DoubleAxis2DViewMixin,
        Double2DRowViewMixin
    implements Numeric2DAxis<double>, Double2DRowFix {
  final Double2D inner;

  Double2DRow(this.inner);

  Double1DFix operator [](int row) => inner[row];
}

class Double2DRowFix extends Object
    with
        AxisFixMixin<double>,
        RowFixMixin<double>,
        AxisViewMixin<double>,
        DoubleAxis2DViewMixin,
        Double2DRowViewMixin
    implements Numeric2DAxisFix<double>, Double2DRowView {
  final Double2DFix inner;

  Double2DRowFix(this.inner);

  Double1DFix operator [](int row) => inner[row];
}

class Double2DRowView extends Object
    with
        AxisViewMixin<double>,
        RowViewMixin<double>,
        DoubleAxis2DViewMixin,
        Double2DRowViewMixin
    implements Numeric2DAxisView<double> {
  final Double2DView inner;

  Double2DRowView(this.inner);

  Double1DView operator [](int row) => inner[row];
}
