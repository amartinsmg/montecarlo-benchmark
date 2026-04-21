#ifndef RUN_BENCH_H
#define RUN_BENCH_H

#include <stdint.h>
#include <stdio.h>
#include <time.h>

typedef double (*bench_fn)(int64_t);

static inline double now() {
  struct timespec t;
  clock_gettime(CLOCK_MONOTONIC, &t);
  return t.tv_sec + t.tv_nsec * 1e-9;
}

static void run_bench(const char *name, bench_fn f, int64_t N, uint32_t runs) {
  printf("\n%s\n", name);

  double total_runtime = 0;

  double val = f(N);
  printf("Pi estimated: %lf\n", val);

  volatile double sink;

  for (int i = 0; i < runs; i++) {
    double start = now();
    sink = f(N);
    double end = now();
    total_runtime += end - start;
  }

  double mean = total_runtime / runs;

  printf("Time = %.3f s\n", mean);
}

#endif /* RUN_BENCH_H */
