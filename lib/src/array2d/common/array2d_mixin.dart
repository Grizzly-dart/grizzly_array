part of grizzly.series.array2d;

abstract class Array2DViewMixin<E> implements Array2DView<E> {
  Index2D get shape => new Index2D(numRows, numCols);

  bool get isSquare => numRows == numCols;

  @override
  Array<E> unique() {
    final ret = new LinkedHashSet<E>();
    for (ArrayView<E> r in rows) {
      for (E element in r.asIterable) {
        if (!ret.contains(element)) ret.add(element);
      }
    }
    return makeArray(ret);
  }

  Array2D<E> head([int count = 10]) {
    // TODO
    throw new UnimplementedError();
  }

  Array2D<E> tail([int count = 10]) {
    //TODO
    throw new UnimplementedError();
  }

  Array2D<E> sample([int count = 10]) {
    //TODO
    throw new UnimplementedError();
  }

  bool operator ==(/* E | IterView<E> | Iterable<E> */ other) {
    if (other is E) {
      for (int i = 0; i < numCols; i++) {
        if (this[i] != other) return false;
      }
      return true;
    } else if (other is IterView<E> || other is Iterable<E>) {
      if (other is Iterable<E>) other = new IterView<E>(other);
      if (other is IterView<E>) {
        for (int i = 0; i < numCols; i++) {
          if (this[i] != other) return false;
        }
        return true;
      }
      return false;
    } else if (other is IterView<IterView<E>> ||
        other is Iterable<Iterable<E>>) {
      if (other.length != numCols) return false;
      if (other is Iterable<Iterable<E>>) {
        final nOther = new Iter<IterView<E>>([]);
        for (int i = 0; i < numCols; i++) {
          nOther.add(new IterView<E>(other.elementAt(i)));
        }
        other = nOther;
      }
      if (other is IterView<IterView<E>>) {
        for (int i = 0; i < numCols; i++) {
          if (this[i] != other[i]) return false;
        }
        return true;
      }
      return false;
    } else if (other is Array2DView<E>) {
      if (numCols != other.numCols || numRows != other.numRows) return false;
      for (int i = 0; i < numCols; i++) {
        if (this[i] != other[i]) return false;
      }
      return true;
    }
    return false;
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
