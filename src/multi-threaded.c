#include "randomf.h"
#include <omp.h>
#include <stdint.h>
#include <stdio.h>

double montecarlo_threads(int64_t N) {
  int64_t count = 0;

#pragma omp parallel
  {
    uint64_t seed = 123456789ULL ^ omp_get_thread_num() * 0x9e3779b97f4a7c15ULL;
    int64_t partial_sum = 0;

    float x, y;

#pragma omp for schedule(static)
    for (int64_t i = 0; i < N; i++) {
      x = randomf(&seed);
      y = randomf(&seed);
      partial_sum += x * x + y * y <= 1 ? 1 : 0;
    }

#pragma omp atomic
    count += partial_sum;
  }

  return 4.0 * (double)count / (double)N;
}

int main(void) {
  double pi = montecarlo_threads(1000000000000);
  printf("Pi estimated = %.9lf\n", pi);

  return 0;
}
