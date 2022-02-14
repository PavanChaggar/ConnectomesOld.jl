# using Connectomes
# using OrdinaryDiffEq
# using BenchmarkTools

# assetpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/"
# C = Connectome(assetpath * "connectomes/hcp-scale1-standard-master.graphml")
# fC = graph_filter(C, 0.001)

# p = [1.0,1.0]
# u0 = rand(83)
# t_span = (0.0,10.0)
# function NetworkFKPP(du, u0, p, t; L = fC.L)
#     du .= -p[1] * L * u0 .+ p[2] .* u0 .* (1.0 .- u0) 
# end

# prob = ODEProblem(NetworkFKPP, u0, t_span, p)
# @btime solve(prob, Tsit5()) #  244.709 μs (826 allocations: 1.45 MiB)
# @benchmark solve(prob, Tsit5())
# # julia> @benchmark solve(prob, Tsit5())
# # BenchmarkTools.Trial: 10000 samples with 1 evaluation.
# #  Range (min … max):  242.208 μs …   9.517 ms  ┊ GC (min … max):  0.00% … 95.21%
# #  Time  (median):     276.479 μs               ┊ GC (median):     0.00%
# #  Time  (mean ± σ):   429.024 μs ± 766.572 μs  ┊ GC (mean ± σ):  17.46% ±  9.35%

# #     █                                                            
# #   ▂███▃▂▂▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▂▄▆▆▅▅▃▃▂▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁ ▂
# #   242 μs           Histogram: frequency by time          590 μs <

# #  Memory estimate: 1.45 MiB, allocs estimate: 826.

# function NetworkFKPPviewu0(du, u0, p, t; L = fC.L)
#     x = @view u0[:]
#     du .= -p[1] * L * x .+ p[2] .* x .* (1.0 .- x) 
# end

# prob = ODEProblem(NetworkFKPPviewu0, u0, t_span, p)
# @btime solve(prob, Tsit5()) #   247.500 μs (826 allocations: 1.45 MiB)
# @benchmark solve(prob, Tsit5())
# # julia> @benchmark solve(prob, Tsit5())
# # BenchmarkTools.Trial: 10000 samples with 1 evaluation.
# #  Range (min … max):  242.041 μs …   8.209 ms  ┊ GC (min … max):  0.00% … 94.83%
# #  Time  (median):     260.750 μs               ┊ GC (median):     0.00%
# #  Time  (mean ± σ):   370.500 μs ± 659.523 μs  ┊ GC (mean ± σ):  17.14% ±  9.22%

# #   ▁▇█▆▄▄▄▃▁                        ▂▃▃▃▃▃▂▂▁▁                   ▂
# #   ██████████▇▇█▆▆▅▅▆▅▆▆▆▅▅▆▄▆▅▆▆▆▅▇████████████▇▇▅▅▅▄▄▄▄▃▄▂▄▄▃▂ █
# #   242 μs        Histogram: log(frequency) by time        623 μs <

# #  Memory estimate: 1.45 MiB, allocs estimate: 826.

# function NetworkFKPPviewall(du, u0, p, t; L = fC.L)
#     x = @view u0[:]
#     k, a = @view p[:]
#     du .= -k * L * x .+ a.* x .* (1.0 .- x) 
# end

# prob = ODEProblem(NetworkFKPPviewall, u0, t_span, p)
# @btime solve(prob, Tsit5()) #  247.375 μs (826 allocations: 1.45 MiB)
# @benchmark solve(prob, Tsit5())
# # julia> @benchmark solve(prob, Tsit5())
# # julia> using BenchmarkTools with 1 evaluation.
# #  Range (min … max):  244.667 μs …   8.193 ms  ┊ GC (min … max):  0.00% … 95.06%
# #  Time  (median):     260.375 μs               ┊ GC (median):     0.00%
# #  Time  (mean ± σ):   340.911 μs ± 596.984 μs  ┊ GC (mean ± σ):  16.83% ±  9.17%

# #   ▂▇█▇▅▄▄▃▂                             ▁▁▁▁▁▁▁                 ▁
# #   ███████████▇▆▆▅▆▅▃▆▄▄▅▄▅▅▅▄▄▄▅▅▅▄▆▂▅▄▇████████▇▇▆▆▆▆▆▅▄▅▄▄▃▄▂ █
# #   245 μs        Histogram: log(frequency) by time        583 μs <

# #  Memory estimate: 1.45 MiB, allocs estimate: 826.

# using LinearAlgebra

# p = [1.0,1.0,zeros(83)]
# function NetworkFKPPmul(du, u0, p, t; L = fC.L)
#     mul!(p[3], L, u0)
#     mul!(p[3], -p[1], p[3])
#     du .= p[3] .+ p[2] .* u0 .* (1.0 .- u0) 
# end

# prob = ODEProblem(NetworkFKPPmul, u0, t_span, p)
# @btime solve(prob, Tsit5()) #      186.958 μs (1291 allocations: 169.23 KiB)
# @benchmark solve(prob, Tsit5())
# # julia> @benchmark solve(prob, Tsit5())
# # BenchmarkTools.Trial: 10000 samples with 1 evaluation.
# #  Range (min … max):  187.291 μs …  13.584 ms  ┊ GC (min … max): 0.00% … 97.95%
# #  Time  (median):     196.375 μs               ┊ GC (median):    0.00%
# #  Time  (mean ± σ):   214.589 μs ± 415.370 μs  ┊ GC (mean ± σ):  6.09% ±  3.10%

# #      ▃█▇▆▇▆▃                                                     
# #   ▁▂▇████████▆▄▄▃▃▃▃▃▄▅▆▆▆▇▆▆▆▅▅▄▄▃▃▃▂▃▂▂▂▂▂▂▂▂▂▁▁▁▂▁▁▁▁▁▁▁▁▁▁▁ ▃
# #   187 μs           Histogram: frequency by time          239 μs <

# #  Memory estimate: 169.23 KiB, allocs estimate: 1291.

# function NetworkFKPPmulview(du, u0, p, t; L = fC.L)
#     x = @view u0[:]
#     k, a, A = @view p[:]
#     mul!(A, L, x)
#     mul!(A, -k, A)
#     du .= A .+ a.* x .* (1.0 .- x) 
# end

# prob = ODEProblem(NetworkFKPPmulview, u0, t_span, p)
# @btime solve(prob, Tsit5()) #      207.417 μs (1477 allocations: 199.75 KiB)
# @benchmark solve(prob, Tsit5()) #
# # julia> @benchmark solve(prob, Tsit5()) #
# # BenchmarkTools.Trial: 10000 samples with 1 evaluation.
# #  Range (min … max):  205.667 μs …  12.389 ms  ┊ GC (min … max): 0.00% … 97.61%
# #  Time  (median):     215.125 μs               ┊ GC (median):    0.00%
# #  Time  (mean ± σ):   234.300 μs ± 428.380 μs  ┊ GC (mean ± σ):  6.55% ±  3.52%

# #           ▂▅█▆▆▄▁                                                
# #   ▁▁▂▃▄▅▆████████▇▆▅▄▃▃▂▂▂▂▃▃▃▃▃▃▄▄▄▄▃▃▃▃▃▂▂▂▂▂▂▂▁▁▂▁▁▁▁▁▁▁▁▁▁▁ ▃
# #   206 μs           Histogram: frequency by time          250 μs <

# #  Memory estimate: 199.75 KiB, allocs estimate: 1477.

# function NetworkFKPPopt(du, u0, p, t; L = fC.L)
#     mul!(A, L, u0)
#     mul!(A, -p[1], A)
#     du .= A .+ p[2] .* u0 .* (1.0 .- u0) 
# end
# prob = ODEProblem(NetworkFKPPopt, u0, t_span, p)
# @btime solve(prob, Tsit5()) #  185.959 μs (1291 allocations: 169.23 KiB)
# @benchmark solve(prob, Tsit5()) #