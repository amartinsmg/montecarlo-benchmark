#ifndef MONTECARLO_H
#define MONTECARLO_H

#include "hash64.h"
#include "randomf.h"
#include <stdint.h>

static double montecarlo(int64_t N) {
  int64_t count = 0;

  float x, y;

  uint64_t seed = 123456789;
  uint64_t state = hash64(seed);

  for (int64_t i = 0; i < N; i++) {
    x = randomf(&state);
    y = randomf(&state);
    count += x * x + y * y <= 1 ? 1 : 0;
  }

  return 4.0 * (double)count / (double)N;
}

#endif /* MONTECARLO_H */
