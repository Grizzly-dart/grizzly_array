part of grizzly.series.array2d;

class Bool2DRow extends Object
    with
        AxisFixMixin<bool>,
        AxisMixin<bool>,
        AxisViewMixin<bool>,
        RowMixin<bool>,
        BoolAxis2DViewMixin
    implements Axis2D<bool>, Bool2DRowFix {
  final Bool2D inner;

  Bool2DRow(this.inner);

  Bool1DFix operator [](int row) => inner[row];
}

class Bool2DRowFix extends Object
    with
        AxisViewMixin<bool>,
        AxisFixMixin<bool>,
        AxisFixMixin<bool>,
        RowFixMixin<bool>,
        BoolAxis2DViewMixin
    implements Axis2DFix<bool>, Bool2DRowView {
  final Bool2DFix inner;

  Bool2DRowFix(this.inner);

  Bool1DFix operator [](int row) => inner[row];

  operator []=(int index, ArrayView<bool> row) => inner[index] = row;
}

class Bool2DRowView extends Object
    with RowViewMixin<bool>, AxisViewMixin<bool>, BoolAxis2DViewMixin
    implements BoolAxis2DView {
  final Bool2DView inner;

  Bool2DRowView(this.inner);

  Bool1DView operator [](int row) => inner[row];
}
