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

# Plotting Individual Regions

A common use case will be to plot scalar fields across different brain regions. This is easy to do using `Connectomes.jl`. Let's look at an example where we just want to plot regions of the left hemisphere.

First, we need to get the regions. We do this by first loading in a connectome and parcellation and then using `filter` to find the right regions. In `Connectomes.jl` the default parcellation uses the DKT atlas.

```@example plot

# get regions in the left hemisphere
c = Connectomes.connectome_path() |> Connectome 
left = filter(x -> x.Hemisphere == "left", c.parc)

# create some values we want to use for colors, these could be, for example, protein concentration
p = rand(length(left.ID))

# and define a colormap 
using ColorSchemes
cmap = ColorSchemes.RdYlBu |> reverse

# make the Makie figure
f = Figure(resolution=(1200, 800))
ax = Axis3(f[1,1], aspect=:data, azimuth = 0.0pi, elevation=0.0pi)
hidedecorations!(ax)
hidespines!(ax)

# add a cortex to the figure
plot_cortex!()

# loop over the regions and plot them!
for (i, region) in enumerate(left.ID)
    plot_roi!(region, get(cmap, p[i]))
end

f
```

# Using Makie Layouts

Now say we want to add another brain to the image, using the `Makie` layout paradigm, we can add another `Axis` and change some of the layout properties before plotting a new brain. 


```@example plot
ax = Axis3(f[1,2], aspect=:data, azimuth = 1.0pi, elevation=0.0pi)
hidedecorations!(ax)
hidespines!(ax)

# add a cortex to the figure
plot_cortex!()

# loop over the regions and plot them!
for (i, region) in enumerate(left.ID)
    plot_roi!(region, get(cmap, p[i]))
end

f
```
