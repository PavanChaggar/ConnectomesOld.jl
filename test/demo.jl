using Revise

using Connectomes

using GLMakie
using FileIO
using Colors

assetpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/"
connectome_path = assetpath * "connectomes/hcp-scale1-standard-master.graphml"
connectome = Connectome(connectome_path)

plot_mesh()

plot_roi(connectome, "Hippocampus")
plot_roi(connectome, ["Hippocampus", "brainstem"])

subcortex = findall( x -> occursin("subcortical",x), connectome.parc.Region)

plot_roi(connectome, connectome.parc[subcortex,:Label])

plot_mesh(;alpha=0.1, transparent=true)

function plot_parcellation(connectome::Connectome)
    fig = mesh()
    for i in connectome.parc[!,:ID]
        mesh!()
    end
    fig
end