module MonteCarloMultiThreaded
  
using Base.Threads

export montecarlo_threads

function montecarlo_threads(N::Int64)
  partial_sums = zeros(Float64, nthreads(:default) + nthreads(:interactive))
  @threads for _ in 0:N
    x = rand(Float32)
    y = rand(Float32)
    partial_sums[threadid()] += x * x + y * y <= 1f0 ? 1 : 0
  end
  count = sum(partial_sums)
  return 4f0 * count / N
end
end

