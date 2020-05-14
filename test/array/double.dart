import 'package:grizzly_array/grizzly_array.dart';
import 'package:test/test.dart';

void main() {
  group('Double1DView', () {
    setUp(() {});

    test('average', () {
      // TODO
    });

    test('to2D', () {
      Double1D s1 = new Double1D.fromNums([1, 5]);
      expect(s1.to2D(), [
        [1.0],
        [5.0],
      ]);
      expect(s1.to2D(t: true), [
        [1.0, 5.0]
      ]);
      expect(s1.to2D().shape, idx2D(2, 1));
      expect(s1.to2D(t: true).shape, idx2D(1, 2));
    });

    test('covariance', () {
      final s1 = ints([1, 5]);
      // TODO
    });

    test('exp', () {
      {
        final x = doubles([-0.1, -0.2, -0.3, -0.4]);
        final y = (x.exp + 1).log;
        expect(y, [
          0.6443966600735709,
          0.5981388693815918,
          0.554355244468527,
          0.5130152523999526
        ]);
      }
      {
        final x = doubles([0.1, 0.2, 0.3, 0.4]);
        final y = -x.toDouble() + (x.exp + 1).log;
        expect(y, [
          0.644396660073571,
          0.5981388693815917,
          0.5543552444685271,
          0.5130152523999526
        ]);
      }
    });

    test('sort', () {
      expect((ints([1, 5, 2, 4, 3])..sort()), [1, 2, 3, 4, 5]);
      expect((ints([1, 5, 2, 4, 3])..sort(descending: true)), [5, 4, 3, 2, 1]);
    });

    test('unique', () {
      expect(
          ints([1, 1, 5, 6, 5, 2, 3, 3, 3, 3, 2, 1]).unique(), [1, 5, 6, 2, 3]);
    });

    test('uniqueIndices', () {
      expect(ints([1, 1, 5, 6, 5, 2, 3, 3, 3, 3, 2, 1]).uniqueIndices(),
          [0, 2, 3, 5, 6]);
    });

    test('mask', () {
      expect(
          ints([1, 5, 2, 4, 3])
            ..keepIf(bools([false, true, false, true, false])),
          [5, 4]);
    });

    test('equality', () {
      expect(doubles([1.0, 2.0, 3.0]) == [1, 2, 3], true);
    });
  });
}
