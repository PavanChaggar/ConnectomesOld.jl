# Connectomes

Connectomes.jl is a package for handling and plotting brain connectomes obtained through tractography. The initial aims of the project are to be able to read and write graphml files into a standardised format for connectomes and to display these using [Makie](http://makie.juliaplots.org/stable/).

## To do before release:
- [ ] Read csv formats for matrices and parcellations and write as graphml with standard fields.
<!-- 
## Plan for dynamics

I hope to interface with differential equations to make it easier to write and solve dynamical systems on brain networks. 

In my current work, these dynamical systems typically have the following structure: 

dp/dt = diffusion + growth 

where the diffusion part is typically given by **-d L p**, describing diffusion using the graph Laplacian of the network domain, and growth part are some kinetic terms describing protein dynamics.

Using `DifferentialEquations`, an FKPP model on a graph with a Laplacian matrix, L, might look like

```julia
# function NetworkFKPP(du, u0, p, t)
#     du .= -κ * L * x .+ α .* x .* (1.0 .- x) 
# end

```
``` -->