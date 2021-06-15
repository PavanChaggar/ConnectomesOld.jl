using Revise
using Connectomes
using GLMakie
using FileIO
using Colors


assetpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/"
connectome_path = assetpath * "connectomes/hcp-scale1-standard-master.graphml"
connectome = Connectome(connectome_path)

plot_cortex(:left)

plot_parc(connectome, :left)

subcortex = findall( x -> occursin("subcortical",x), connectome.parc.Region)
connectome.parc[subcortex,:Label]

plot_roi(connectome, connectome.parc[subcortex,:Label])

f_connectome =  graph_filter(connectome, 0.02)

plot_connectome(f_connectome)

degree = [connectome.D[i,i] for i in 1:83]

plot_connectome(f_connectome; node_size = degree*5)

plot_mesh()

plot_parc(connectome; alpha=1.0)

plot_roi(connectome, "entorhinal")
plot_roi(connectome, ["Hippocampus", "brainstem"])

subcortex = findall( x -> occursin("subcortical",x), connectome.parc.Region)

plot_roi(connectome, connectome.parc[subcortex,:Label])

fig = plot_roi_x(connectome, ["rostralanteriorcingulate", "caudalanteriorcingulate"], colorant"rgba(20, 100, 180 ,0.7)")
path = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/" * "DKT/roi_24.obj"
mesh!(load(path),color=(colorant"rgba(180,0,10,0.7)"), transparency=false, show_axis=false)
save("braak4.png", fig)


findall(x -> x == "lingual", connectome.parc.Label)