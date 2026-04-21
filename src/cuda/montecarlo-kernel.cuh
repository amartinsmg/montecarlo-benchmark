#ifndef MONTECARLO_KERNEL_CUH
#define MONTECARLO_KERNEL_CUH

#include "hash64.h"
#include "randomf.h"
#include <cuda_runtime.h>
#include <stdint.h>

__global__ static void kernel_montecarlo(int64_t *counts, int64_t N) {
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = gridDim.x * blockDim.x;

  uint64_t seed = 123456789;
  uint64_t state = hash64(seed + idx);

  int64_t local_count = 0;

  float x, y;

  for (int64_t i = 0; i < N; i += stride) {
    x = randomf(&state);
    y = randomf(&state);
    local_count += x * x + y * y <= 1 ? 1 : 0;
  }

  counts[idx] = local_count;
}

#endif /* MONTECARLO_KERNEL_CUH */
