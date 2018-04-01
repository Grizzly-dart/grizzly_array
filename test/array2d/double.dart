import 'package:grizzly_array/grizzly_array.dart';
import 'package:test/test.dart';

void main() {
  group('DoubleArray2D', () {
    setUp(() {});

    test('multiply', () {
      final res = doubles2([
        [3.0, 1.0],
        [1.0, 2.0]
      ]).matmul(doubles2([
        [2.0],
        [3.0]
      ]));

      expect(
          res,
          doubles2([
            [9.0],
            [8.0],
          ]));
    });
  });
}
