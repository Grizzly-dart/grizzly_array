part of grizzly.series.array2d;

class Int2DRow extends Object
    with
        IntAxis2DViewMixin,
        AxisFixMixin<int>,
        AxisMixin<int>,
        AxisViewMixin<int>,
        RowMixin<int>
    implements Numeric2DAxis<int>, Int2DRowFix {
  final Int2D inner;

  Int2DRow(this.inner);

  Int1DFix operator [](int row) => inner[row];
}

class Int2DRowFix extends Object
    with
        IntAxis2DViewMixin,
        AxisFixMixin<int>,
        AxisViewMixin<int>,
        RowFixMixin<int>
    implements Numeric2DAxisFix<int>, Int2DRowView {
  final Int2DFix inner;

  Int2DRowFix(this.inner);

  Int1DFix operator [](int row) => inner[row];
}

class Int2DRowView extends Object
    with IntAxis2DViewMixin, AxisViewMixin<int>, RowViewMixin<int>
    implements Numeric2DAxisView<int> {
  final Int2DView inner;

  Int2DRowView(this.inner);

  Int1DView operator [](int row) => inner[row];
}
