import 'package:grizzly_array/grizzly_array.dart';
import 'package:test/test.dart';

void main() {
  group('IntArray2D', () {
    setUp(() {});

    test('construct', () {
      final s1 = Int2D([
        [1, 2, 3, 4],
        [5, 6, 7, 8]
      ]);

      expect(s1.shape, idx2D(2, 4));
      expect(s1.min, 1);
      expect(s1.max, 8);

      expect(s1[0], Int1D([1, 2, 3, 4]));
      expect(s1[1], Int1D([5, 6, 7, 8]));
    });

    test('average', () {
      final s1 = Int2D([
        [15, 2],
        [5, 6]
      ]);
      expect(
          s1.average([
            [7, 2],
            [3, 4]
          ]),
          9.25);
    });

    test('transpose', () {
      final s1 = Int2D([
        [15, 2],
        [5, 6]
      ]);
      expect(s1.transpose, [
        [15, 5],
        [2, 6]
      ]);
    });

    test('dot.square', () {
      final a = Int2D([
        [1, 0],
        [0, 1]
      ]);
      final b = Int2D([
        [4, 2],
        [1, 2]
      ]);
      expect(a.matmul(b), [
        [4, 2],
        [1, 2]
      ]);
    });

    test('dot.rectangle', () {
      final a = Int2D([
        [1, 4],
        [2, 5],
        [3, 6],
      ]);
      final b = Int2D([
        [4, 2],
        [2, 2]
      ]);
      expect(a.matmul(b), [
        [12, 10],
        [18, 14],
        [24, 18],
      ]);
    });

    test('assign', () {
      final a = ints2([
        [1, 4],
        [2, 5],
        [3, 6],
      ]);
      final b = ints2(a.shape);
      expect(
          b,
          ints2([
            [0, 0],
            [0, 0],
            [0, 0],
          ]));
      b.assign(a);
      expect(b, a);
    });
  });
}
