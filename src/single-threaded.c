#include "randomf.h"
#include <stdint.h>
#include <stdio.h>

double montecarlo(int64_t n) {
  int64_t count = 0;

  float x, y;

  uint64_t seed = 123456789ULL;

  for (int64_t i = 0; i < n; i++) {
    x = randomf(&seed);
    y = randomf(&seed);
    count += x * x + y * y <= 1 ? 1 : 0;
  }

  return 4.0 * (double)count / (double)n;
}

int main(void) {
  double pi = montecarlo(1000000000000);
  printf("Pi estimated = %.9lf\n", pi);

  return 0;
}
