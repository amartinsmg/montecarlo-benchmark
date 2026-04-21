#include "bench/run-bench-cuda.cuh"
#include "bench/run-bench.h"
#include "cpu/multi-threaded.h"
#include "cpu/single-threaded.h"
#include "cuda/montecarlo.cuh"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  int64_t N;
  uint32_t runs;
} config_t;

inline int64_t parse_int64(const char *s) { return (int64_t)strtod(s, NULL); }

inline uint32_t parse_uint32(const char *s) { return (uint32_t)atoi(s); }

inline config_t parse_args(int argc, char **argv) {
  config_t cfg = {.N = 1000000LL, .runs = 3U};

  for (int i = 1; i < argc; i++) {
    if (strncmp(argv[i], "--n=", 4) == 0) {
      cfg.N = parse_int64(argv[i] + 4);
    } else if (strncmp(argv[i], "--runs=", 4) == 0) {
      cfg.runs = parse_uint32(argv[i] + 7);
    } else {
      printf("Unknow argument: %s\n", argv[i]);
      exit(EXIT_FAILURE);
    }
  }

  return cfg;
}

int main(int argc, char **argv) {

  config_t cfg = parse_args(argc, argv);

  run_bench("Single-Threaded Baseline", montecarlo, cfg.N, cfg.runs);
  run_bench("Multi-Threaded CPU Implementation", montecarlo_threads, cfg.N,
            cfg.runs);
  run_bench_cuda("CUDA GPU Implementation", montecarlo_cuda, cfg.N, cfg.runs);

  return EXIT_SUCCESS;
}
