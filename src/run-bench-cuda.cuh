#ifndef RUN_BENCH_CUDA_CUH
#define RUN_BENCH_CUDA_CUH

#include <cuda_runtime_api.h>
#include <stdint.h>
#include <stdio.h>

typedef double (*bench_fn_cuda)(int64_t);

static void run_bench_cuda(const char *name, bench_fn_cuda f, int64_t N,
                           uint32_t RUNS) {
  printf("\n%s\n", name);

  double total_runtime = 0;

  // warm-up
  double val = f(N);
  printf("Pi estimated: %lf\n", val);

  volatile double sink;

  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  for (int i = 0; i < RUNS; i++) {
    cudaEventRecord(start);

    sink = f(N);

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    total_runtime += ms / 1000.0;
  }

  cudaEventDestroy(start);
  cudaEventDestroy(stop);

  double mean = total_runtime / RUNS;

  printf("Time = %.3f s\n", mean);
}

#endif /* RUN_BENCH_CUDA_CUH */
