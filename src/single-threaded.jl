module MonteCarloSingleThreaded

export montecarlo

function montecarlo(N::Int64)
  count = 0
  for _ in 0:N
    x = rand(Float32)
    y = rand(Float32)
    count += x * x + y * y <= 1f0 ? 1 : 0
  end
  return 4f0 * count / N
end
end
