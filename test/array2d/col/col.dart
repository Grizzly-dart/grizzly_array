import 'package:grizzly_array/grizzly_array.dart';
import 'package:test/test.dart';

void main() {
  group('IntArray2D', () {
    setUp(() {});

    test('col', () {
      final s1 = Int2D.aCol([1, 2, 3, 4]);
      expect(s1.shape, Index2D(4, 1));

      expect(s1.col[0], [1, 2, 3, 4]);

      s1.col.addScalar(1);
      expect(s1.shape, Index2D(4, 2));
      expect(s1, [
        [1, 1],
        [2, 1],
        [3, 1],
        [4, 1],
      ]);
    });
  });
}
