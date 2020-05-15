part of grizzly.series.array2d;

class String2DRow extends Object
    with
        Axis2DMixin<String>,
        RowMixin<String>,
        String2DAxisMixin
    implements Axis2D<String> {
  final String2D inner;

  String2DRow(this.inner);
}