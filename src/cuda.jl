module MonteCarloCUDA

using CUDA
using CUDA.Random

export montecarlo_cuda

function kernel_montecarlo(counts, N)
  idx = (blockIdx().x - 1) * blockDim().x + threadIdx().x
  stride = gridDim().x * blockDim().x
  rng = CUDA.Random.default_rng()
  CUDA.Random.seed!(rng, 1234 + idx)
  local_count = 0
  i = idx
  while i <= N
    x::Float32 = rand(rng, Float32)
    y::Float32 = rand(rng, Float32)
    local_count += x * x + y * y <= 1f0 ? 1 : 0
    i += stride
  end
  if idx <= length(counts)
    counts[idx] = local_count
  end
  return
end

function montecarlo_cuda(N::Int64)
  threads = 256
  sm_count = CUDA.attribute(CUDA.device(),
    CUDA.DEVICE_ATTRIBUTE_MULTIPROCESSOR_COUNT)
  blocks = 4 * sm_count

  total_threads = threads * blocks
  counts = CUDA.zeros(Int64, total_threads)

  @cuda threads = threads blocks = blocks kernel_montecarlo(counts, N)

  total = sum(counts)

  return 4f0 * total / N

end
end
