using Revise
using Revise

using Connectomes

using GLMakie
using FileIO
using Colors


assetpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/"
connectome_path = assetpath * "connectomes/hcp-scale1-standard-master.graphml"
connectome = Connectome(connectome_path)

plot_connectome(connectome)

A =  graph_filter(Matrix(connectome.A), 0.05)

filtered_connectome = Connectome(connectome.parc, A)

plot_connectome(filtered_connectome)

degree = [connectome.D[i,i] for i in 1:83]

plot_connectome(filtered_connectome; node_size = degree*5)

plot_mesh()

plot_parc(connectome; alpha=1.0)

plot_roi(connectome, "Hippocampus")
plot_roi(connectome, ["Hippocampus", "brainstem"])

subcortex = findall( x -> occursin("subcortical",x), connectome.parc.Region)

plot_roi(connectome, connectome.parc[subcortex,:Label])


