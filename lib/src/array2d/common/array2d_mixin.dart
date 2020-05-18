part of grizzly.array2d;

abstract class Array2DMixin<E> implements Array2D<E> {
  set diagonal(val) {
    int d = math.min(numRows, numCols);
    if (val is E) {
      for (int r = 0; r < d; r++) this[r][r] = val;
    } else if (val is Iterable<E>) {
      if (val.length != d)
        throw lengthMismatch(expected: d, found: val.length, subject: 'val');
      for (int r = 0; r < d; r++) this[r][r] = val.elementAt(r);
    } else if (val is Array2D<E>) {
      if (val.numRows < d || val.numCols < d) throw Exception();
      for (int r = 0; r < d; r++) this[r][r] = val[r][r];
    } else {
      throw UnsupportedError('Type!');
    }
  }

  Index2D get shape => Index2D(numRows, numCols);

  bool get isSquare => numRows == numCols;

  @override
  Array<E> unique() {
    final ret = LinkedHashSet<E>();
    for (ArrayView<E> r in rows) {
      for (E element in r) {
        if (!ret.contains(element)) ret.add(element);
      }
    }
    return makeArray(ret);
  }

  Array2D<E> head([int count = 10]) {
    // TODO
    throw UnimplementedError();
  }

  Array2D<E> tail([int count = 10]) {
    //TODO
    throw UnimplementedError();
  }

  Array2D<E> sample([int count = 10]) {
    //TODO
    throw UnimplementedError();
  }

  bool operator ==(/* E | Iterable<E> */ other) {
    if (other is Array2D<E>) {
      if (shape != other.shape) return false;
      for (int i = 0; i < numRows; i++) {
        if (this[i] != other[i]) return false;
      }
      return true;
    }
    return false;
  }

  String toString() {
    final tab = table(List<String>.generate(numCols, (i) => i.toString()));
    for (int i = 0; i < numRows; i++) {
      tab.row(row[i].toStringArray().toList());
    }
    return tab.toString();
  }
}

abstract class Axis2DMixin<E> implements Axis2D<E> {
  @override
  void sort({bool descending: false}) {
    for (int i = 0; i < length; i++) this[i].sort(descending: descending);
  }

  void swap(int i, int j) {
    if (i == j) return;

    if (i > length) throw RangeError.range(i, 0, length - 1);
    if (j > length) throw RangeError.range(j, 0, length - 1);

    for (int r = 0; r < otherDLength; r++) {
      E temp = this[i][r];
      this[i][r] = this[j][r];
      this[j][r] = temp;
    }
  }

  @override
  Iterable<Array<E>> unique() {
    final ret = List<Array<E>>(length);
    for (int i = 0; i < length; i++) {
      ret[i] = this[i].unique();
    }
    return ret;
  }
}
