#ifndef RANDOM_F_H
#define RANDOM_F_H

#include <stdint.h>

static inline float randomf(uint64_t *x) {
  *x += 0x9e3779b97f4a7c15ULL;
  uint64_t z = *x;
  z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
  z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
  z = z ^ (z >> 31);

  return (float)(uint32_t)(z >> 32) / 4294967295.0f;
}

#endif /* RANDOM_F_H */