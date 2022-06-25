# Guide to Connectomes

```@docs
Connectome
```

# Plotting Example

```@setup plot
using JSServe
Page(exportable=true, offline=true)
```

```@example plot
using WGLMakie
scatter(rand(10), rand(10))
```

```@example plot
using WGLMakie
using Connectomes

f, ax = plot_cortex()
```
