# Guide to Connectomes

```@docs
Connectome
```

# Plotting Example

Firstly, you will need to load Connectomes and a plotting backend from the [Makie](https://docs.makie.org/stable/). Connectomes.jl uses the Makie.jl backend to organise and render plots.

There are several plotting methods available in Connectomes.jl. In keeping with the Julia custom, plotting methods ending with a `!` add to an existing plot. Whereas those without `!` create a Makie `Scene`.

```@example plot
using JSServe
Page(exportable=true, offline=true)
```

```@example plot
using WGLMakie
using Connectomes

plot_cortex()
```