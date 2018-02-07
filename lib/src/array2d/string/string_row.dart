part of grizzly.series.array2d;

class String2DRow extends Object
    with
        AxisFixMixin<String>,
        AxisMixin<String>,
        AxisViewMixin<String>,
        RowMixin<String>,
        String2DAxisMixin
    implements Axis2D<String>, String2DRowFix {
  final String2D inner;

  String2DRow(this.inner);
}

class String2DRowFix extends Object
    with
        AxisFixMixin<String>,
        RowFixMixin<String>,
        AxisViewMixin<String>,
        AxisFixMixin<String>,
        String2DAxisMixin
    implements Axis2DFix<String>, String2DRowView {
  final String2DFix inner;

  String2DRowFix(this.inner);
}

class String2DRowView extends Object
    with
        AxisViewMixin<String>,
        RowViewMixin<String>,
        String2DAxisMixin,
        AxisViewMixin<String>
    implements Axis2DView<String> {
  final String2DView inner;

  String2DRowView(this.inner);
}
