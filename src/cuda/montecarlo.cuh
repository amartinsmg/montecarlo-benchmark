#ifndef MONTECARLO_CUDA_CUH
#define MONTECARLO_CUDA_CUH

#include "montecarlo-kernel.cuh"

double static montecarlo_cuda(int64_t N) {
  int64_t total = 0;
  int threads_per_block = 256;
  int device;
  cudaGetDevice(&device);
  int sm_count;
  cudaDeviceGetAttribute(&sm_count, cudaDevAttrMultiProcessorCount, device);
  int blocks = 4 * sm_count;

  int total_threads = threads_per_block * blocks;
  size_t size = total_threads * sizeof(int64_t);

  int64_t *d_counts;
  int64_t *h_counts = (int64_t *)malloc(size);

  cudaMalloc((void **)&d_counts, size);
  cudaMemset(d_counts, 0, size);

  kernel_montecarlo<<<blocks, threads_per_block>>>(d_counts, N);

  cudaMemcpy(h_counts, d_counts, size, cudaMemcpyDeviceToHost);

  for (int i = 0; i < total_threads; i++)
    total += h_counts[i];

  cudaFree(d_counts);
  free(h_counts);

  return 4.0 * (double)total / (double)N;
}

#endif /* MONTECARLO_CUDA_CUH */
