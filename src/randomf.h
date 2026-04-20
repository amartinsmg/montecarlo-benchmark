#ifndef RANDOM_F_H
#define RANDOM_F_H

#include <stdlib.h>

static inline float randomf(unsigned int *x) {
  *x ^= *x >> 16;
  *x *= 0x85ebca6b;
  *x ^= *x >> 13;
  *x *= 0xc2b2ae35;
  *x ^= *x >> 16;
  return (float)*x / (float)0xffffffffU;
}

#endif /* RANDOM_F_H */