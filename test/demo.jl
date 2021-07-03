using Revise
using Connectomes
using GLMakie
using FileIO
using Colors


assetpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/"
connectome_path = assetpath * "connectomes/hcp-scale1-standard-master.graphml"
connectome = Connectome(connectome_path)

plot_cortex()
plot_cortex(:connectome)
plot_parc(connectome)

subcortex = findall( x -> occursin("subcortical",x), connectome.parc.Region)

plot_roi(connectome, connectome.parc[subcortex,:Label])

f_connectome =  graph_filter(connectome, 0.02)

plot_connectome(f_connectome)

degree = [connectome.D[i,i] for i in 1:83]

plot_connectome(f_connectome; node_size = degree*5)

f = Figure(resolution = (1000,1000))
ax = Axis3(f[1,1], aspect = :data)
hidedecorations!(ax)
hidespines!(ax)

plot_cortex!(:all;alpha=0.1, transparent=true)
plot_roi!(81, :blue, 0.8)

FS2Connectome[2002]