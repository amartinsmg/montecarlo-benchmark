#include "bench/run-bench-cuda.cuh"
#include "bench/run-bench.h"
#include "cpu/multi-threaded.h"
#include "cpu/single-threaded.h"
#include "cuda/cuda.cuh"

#define N 1000000000LL
#define RUNS 3U

int main(void) {
  run_bench("Single-Threaded Baseline", montecarlo, N, RUNS);
  run_bench("Multi-Threaded CPU Implementation", montecarlo_threads, N, RUNS);
  run_bench_cuda("CUDA GPU Implementation", montecarlo_cuda, N, RUNS);

  return 0;
}
