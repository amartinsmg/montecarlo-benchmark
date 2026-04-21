# Monte Carlo Benchmark (CPU vs OpenMP vs CUDA)

This project is a personal benchmarking study that compares the performance of a Monte Carlo simulation implemented in three different execution models:

- Single-threaded CPU (baseline)
- Multi-threaded CPU using OpenMP
- GPU execution using CUDA

The goal is to evaluate how different levels of parallelism impact the **performance** of a compute-bound workload, as well as to analyze **scalability** across several orders of magnitude of input size.

---

## 🚀 Overview

The program estimates the value of π by randomly sampling points inside a unit square and counting how many fall inside the unit circle.

As the number of iterations increases, the estimate converges to:

```text
π ≈ 3.141592653589793
```

---

## ⚙️ Implementations

### 🧵 Single-threaded (Baseline)

- Pure CPU implementation
- Sequential execution
- Reference for performance comparison

---

### 🧵🧵 Multi-threaded (OpenMP)

Parallel CPU execution using OpenMP
Independent RNG per thread
Scales with number of CPU cores

---

### ⚡ CUDA (GPU)

Massive parallel execution on GPU
One RNG stream per thread
Designed for high-throughput workloads

---

### 🖥️ Hardware

- **CPU:** Intel Xeon E5-2640 v3 (8 cores / 16 threads)
- **RAM:** 16 GB DDR4
- **GPU:** NVIDIA GeForce RTX 2060 SUPER (8 GB VRAM)

---

### ⚙️ Software Environment

- **OS:** Linux (WSL 2 / Ubuntu 24.04)
- **CUDA Compiler:** nvcc 12.0
- **Host Compiler:** GCC (used via nvcc)
- **CUDA Toolkit:** CUDA Toolkit 12.0
- **Build flags:** `-O3` `-Xcompiler` `-fopenmp`

---

## 📦 Build

#### Requirements

- GCC (with OpenMP support)
- nvcc
- CUDA-capable GPU

#### Compile

```bash
make
```

Or manually:

```bash
nvcc -O3 -Xcompiler -fopenmp src/main.cu -o build/benchmark
```

---

## ▶️ Usage

```bash
./benchmark --n=1e12 --runs=5
```

#### Parameters

- `--n=`: number of iterations (supports scientific notation)
  - Examples: `1e6`, `1e9`, `1e12`
- `--runs=`: number of benchmark repetitions

---

## 📊 Results

| N      | Implementation   | Pi Estimate  | Time (s)   |
| ------ | ---------------- | ------------ | ---------- |
| 1e6    | CPU (Single)     | 3.140784     | 0.007 s    |
| 1e6    | CPU (OpenMP)     | 3.140988     | 0.001 s    |
| 1e6    | CUDA             | 3.172916     | 0.001 s    |
| ------ | ---------------- | ------------ | ---------- |
| 1e9    | CPU (Single)     | 3.141551     | 5.385 s    |
| 1e9    | CPU (OpenMP)     | 3.141604     | 0.795 s    |
| 1e9    | CUDA             | 3.141598     | 0.013 s    |
| ------ | ---------------- | ------------ | ---------- |
| 1e12   | CPU (Single)     | 3.141593     | 92m 20s    |
| 1e12   | CPU (OpenMP)     | 3.141595     | 13m 40s    |
| 1e12   | CUDA             | 3.141596     | 9.023 s    |

---

## 📈 Analysis

### 🔹 Accuracy

The error decreases proportionally to:

```text
error ~ 1 / sqrt(N)
```

Higher iteration counts lead to more accurate estimates, as expected.

---

### 🔹 Performance

| Implementation | Speedup (1e12) |
| -------------- | -------------- |
| CPU (single)   | 1×             |
| CPU (OpenMP)   | ~6.7×          |
| CUDA           | ~600×          |

---

### 🔹 Key Insights

- GPU performance scales significantly better with large workloads
- CPU multi-threading provides consistent speedup (~number of cores)
- CUDA overhead is noticeable only for small workloads
- For large N, GPU dominates by several orders of magnitude

---

### 🔹 Throughput (CUDA)

```text
~1.1 × 10¹¹ iterations per second
```

---

## 🧠 Benchmark Methodology

- Execution time measures only the computation kernel
- I/O operations (e.g., printf) are excluded from timing
- CUDA measurements use cudaEvent for precise timing
- CPU measurements use clock_gettime
- Each benchmark is executed multiple times and averaged
- A warm-up run is performed before measurement

---

## 📁 Project Structure

```text
src
├── bench
├── common
├── cpu
├── cuda
└── main.cu
```

---

## 📄 License

This project is licensed under the MIT License.
See the [LICENSE](./LICENSE) file for details.
