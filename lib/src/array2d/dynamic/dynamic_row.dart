part of grizzly.series.array2d;

class Dynamic2DRow extends Object
    with Axis2DMixin<dynamic>, RowMixin<dynamic>, Dynamic2DAxisMixin
    implements Axis2D<dynamic> {
  final Dynamic2D inner;

  Dynamic2DRow(this.inner);
}
