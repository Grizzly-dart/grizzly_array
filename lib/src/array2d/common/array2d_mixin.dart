part of grizzly.series.array2d;

abstract class Array2DViewMixin<E> implements Array2DView<E> {
  @override
  Array<E> unique() {
    final ret = new LinkedHashSet<E>();
    for (ArrayView<E> r in rows) {
      for (E element in r.iterable) {
        if (!ret.contains(element)) ret.add(element);
      }
    }
    return makeArray(ret);
  }
}

abstract class AxisMixin<E> implements Axis2D<E> {}

abstract class AxisFixMixin<E> implements Axis2DFix<E> {
  @override
  void sort({bool descending: false}) {
    for (int i = 0; i < length; i++) this[i].sort(descending: descending);
  }
}

abstract class AxisViewMixin<E> implements Axis2DView<E> {
  @override
  Iterable<Array<E>> unique() {
    final ret = new List<Array<E>>(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].unique();
    }
    return ret;
  }
}
