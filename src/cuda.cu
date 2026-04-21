#include <cuda_device_runtime_api.h>
#include <cuda_runtime.h>
#include <cuda_runtime_api.h>
#include <driver_types.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>

__device__ static inline float randomf(uint64_t *x) {
  *x += 0x9e3779b97f4a7c15ULL;
  uint64_t z = *x;
  z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
  z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
  z = z ^ (z >> 31);

  return (float)(uint32_t)(z >> 32) / 4294967295.0f;
}

__global__ void kernel_montecarlo(int64_t *counts, int64_t n, uint64_t base_seed) {
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = gridDim.x * blockDim.x;

  uint64_t seed = 123456789ULL + idx * 0x9e3779b97f4a7c15ULL;
  int64_t local_count = 0;

  float x, y;

  for (int64_t i = 0; i < n; i += stride) {
    x = randomf(&seed);
    y = randomf(&seed);
    local_count += x * x + y * y <= 1 ? 1 : 0;
  }

  counts[idx] = local_count;
}

double montecarlo_cuda(int64_t n) {
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

  kernel_montecarlo<<<blocks, threads_per_block>>>(d_counts, n);

  cudaMemcpy(h_counts, d_counts, size, cudaMemcpyHostToHost);

  for (int i = 0; i < total_threads; i++)
    total += h_counts[i];

  cudaFree(d_counts);
  free(h_counts);

  return 4.0 * (double)total / (double)n;
}

int main(void) {
  double pi = montecarlo_cuda(1000000000000);
  printf("Pi estimated = %.9lf\n", pi);

  return 0;
}
