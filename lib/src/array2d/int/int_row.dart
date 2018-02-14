part of grizzly.series.array2d;

class Int2DRow extends Object
    with
        AxisFixMixin<int>,
        AxisMixin<int>,
        AxisViewMixin<int>,
        RowMixin<int>,
        IntAxis2DViewMixin,
        Int2DRowViewMixin
    implements Numeric2DAxis<int>, Int2DRowFix {
  final Int2D inner;

  Int2DRow(this.inner);

  Int1DFix operator [](int row) => inner[row];
}

class Int2DRowFix extends Object
    with
        AxisFixMixin<int>,
        RowFixMixin<int>,
        AxisViewMixin<int>,
        IntAxis2DViewMixin,
        Int2DRowViewMixin
    implements Numeric2DAxisFix<int>, Int2DRowView {
  final Int2DFix inner;

  Int2DRowFix(this.inner);

  Int1DFix operator [](int row) => inner[row];
}

class Int2DRowView extends Object
    with
        AxisViewMixin<int>,
        RowViewMixin<int>,
        IntAxis2DViewMixin,
        Int2DRowViewMixin
    implements Numeric2DAxisView<int> {
  final Int2DView inner;

  Int2DRowView(this.inner);

  Int1DView operator [](int row) => inner[row];
}
