import 'dart:math' as math;
import 'dart:collection';

final math.Random _rand = math.Random();

List<T> sampler<T>(List<T> population, int k) {
  final int n = population.length;

  if (k < 0 || k > n)
    throw ArgumentError.value(
        k, 'k', 'Must be between 0 and population.length');

  final samples = List<T?>.filled(k, null);

  if (n < 1000) {
    final unpicked = population.toList();
    for (int i = 0; i < k; i++) {
      final sampleIdx = _rand.nextInt(n - i);
      samples[i] = unpicked[sampleIdx];
      unpicked[sampleIdx] = unpicked[n - i - 1];
    }
  } else {
    final picked = SplayTreeSet<int>();
    for (int i = 0; i < k; i++) {
      final int sampleIdx = () {
        int newIdx;
        do {
          newIdx = _rand.nextInt(n);
        } while (picked.contains(newIdx));
        return newIdx;
      }();
      picked.add(sampleIdx);
      samples[i] = population[sampleIdx];
    }
  }

  return samples.cast();
}
