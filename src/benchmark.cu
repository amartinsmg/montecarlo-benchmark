#include "cuda.cuh"
#include "multi-threaded.h"
#include "run-bench-cuda.cuh"
#include "run-bench.h"
#include "single-threaded.h"

#define N 1000000000LL
#define RUNS 3U

int main(void) {
  run_bench("Single-Threaded Baseline", montecarlo, N, RUNS);
  run_bench("Multi-Threaded CPU Implementation", montecarlo_threads, N, RUNS);
  run_bench_cuda("CUDA GPU Implementation", montecarlo_cuda, N, RUNS);

  return 0;
}
