#include "randomf.h"
#include <stdint.h>
#include <stdio.h>
#include <time.h>

double montecarlo(int64_t n) {
  int64_t count = 0;

  float x, y;

  uint64_t seed = time(NULL);

  for (int64_t i = 0; i < n; i++) {
    x = randomf(&seed);
    y = randomf(&seed);
    count += x * x + y * y <= 1 ? 1 : 0;
  }

  return 4.0 * (double)count / (double)n;
}

int main(void) {
  double pi = montecarlo(100000000000);
  printf("Pi estimated = %.9lf\n", pi);

  return 0;
}
