#ifndef MONTECARLO_H
#define MONTECARLO_H

#include "randomf.h"
#include <stdint.h>

static double montecarlo(int64_t N) {
  int64_t count = 0;

  float x, y;

  uint64_t seed = 123456789ULL;

  for (int64_t i = 0; i < N; i++) {
    x = randomf(&seed);
    y = randomf(&seed);
    count += x * x + y * y <= 1 ? 1 : 0;
  }

  return 4.0 * (double)count / (double)N;
}

#endif /* MONTECARLO_H */
