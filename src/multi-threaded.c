#include "randomf.h"
#include <omp.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>

double montecarlo_threads(int64_t n) {
  int64_t count = 0;

#pragma omp parallel
  {
    uint64_t seed = time(NULL) + omp_get_thread_num();
    int64_t partial_sum = 0;

    float x, y;

#pragma omp for schedule(static)
    for (int64_t i = 0; i < n; i++) {
      x = randomf(&seed);
      y = randomf(&seed);
      partial_sum += x * x + y * y <= 1 ? 1 : 0;
    }

#pragma omp atomic
    count += partial_sum;
  }

  return 4.0 * (double)count / (double)n;
}

int main(void) {
  double pi = montecarlo_threads(1000000000);
  printf("Pi = %.9lf\n", pi);

  return 0;
}
