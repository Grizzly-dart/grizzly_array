part of grizzly.series.array2d;

class Dynamic2DRow extends Object
    with
        AxisFixMixin<dynamic>,
        AxisMixin<dynamic>,
        AxisViewMixin<dynamic>,
        RowMixin<dynamic>,
        Dynamic2DAxisMixin
    implements Axis2D<dynamic>, Dynamic2DRowFix {
  final Dynamic2D inner;

  Dynamic2DRow(this.inner);
}

class Dynamic2DRowFix extends Object
    with
        AxisFixMixin<dynamic>,
        RowFixMixin<dynamic>,
        AxisViewMixin<dynamic>,
        AxisFixMixin<dynamic>,
        Dynamic2DAxisMixin
    implements Axis2DFix<dynamic>, Dynamic2DRowView {
  final Dynamic2DFix inner;

  Dynamic2DRowFix(this.inner);
}

class Dynamic2DRowView extends Object
    with
        AxisViewMixin<dynamic>,
        RowViewMixin<dynamic>,
        Dynamic2DAxisMixin,
        AxisViewMixin<dynamic>
    implements Axis2DView<dynamic> {
  final Dynamic2DView inner;

  Dynamic2DRowView(this.inner);
}
