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

# Creating figures

For most use cases, we'll want to add plots to an existing Makie `figure`. Here's a simple example that's similar to the one above, but instead we explicitly make the `Makie` figure. Notice how now we use the plot signature `plot_cortex!()`. Additionally, we pass in the argument `:right`, so that we only plot the right hemisphere and named arguments `color=(:grey, 1.0)`, specifying the color and color alpha.

```@example plot
using WGLMakie 
using Connectomes 

f = Figure(resolution=(800, 800))
ax = Axis3(f[1,1], aspect=:data, azimuth = 0.0pi, elevation=0.0pi)
hidedecorations!(ax)
hidespines!(ax)

plot_cortex!(:right; color=(:grey, 0.5), transparency=true)

f
```