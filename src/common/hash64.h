#pragma once

#include <stdint.h>

#ifdef __CUDACC__
  #define HD __host__ __device__
#else
  #define HD
#endif

HD static inline uint64_t hash64(uint64_t x) {
  x += 0x9e3779b97f4a7c15ULL;
  x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9ULL;
  x = (x ^ (x >> 27)) * 0x94d049bb133111ebULL;
  return x ^ (x >> 31);
}
