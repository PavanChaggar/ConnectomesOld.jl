using Revise
using Connectomes
using GLMakie
using FileIO
using Colors
using LightXML

assetpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/"
connectome_path = assetpath * "connectomes/hcp-scale1-standard-master.graphml"
connectome = Connectome(connectome_path)

plot_cortex()

plot_cortex(:connectome)

plot_parc(connectome, :left; view=:left)

subcortex = findall( x -> occursin("subcortical",x), connectome.parc.Region)

plot_roi(connectome, connectome.parc[subcortex,:Label])

f_connectome =  graph_filter(connectome, 0.01)

plot_connectome(f_connectome)

degree = [connectome.D[i,i] for i in 1:83]
d = degree ./ maximum(degree)

plot_connectome(f_connectome; node_size = d*5)

plot_cortex(:all;colour=(:grey,0.05), transparent=true)
plot_roi!(81, (:blue, 0.5))
