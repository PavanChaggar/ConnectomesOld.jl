# using Connectomes
# using GLMakie
# using Colors
# using DataFrames
# using CSV

# assetpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/"
# connectome_path = assetpath * "connectomes/Connectomes-hcp-scale1.xml"
# connectome = Connectome(Connectomes.connectome_path()) |> filter

# plot_cortex()

# plot_cortex(:connectome)

# plot_parc(connectome, :left; view=:left)

# subcortex = findall( x -> occursin("subcortical",x), connectome.parc.Region)

# plot_roi(connectome, connectome.parc[subcortex,:Label])

# plot_connectome(connectome)

# D = degree_matrix(connectome)
# degree = [D[i,i] for i in 1:83]
# d = degree ./ maximum(degree)

# plot_connectome(connectome; node_size = d*5)

# plot_cortex(:all;colour=(:grey,0.05), transparent=true)
# plot_roi!(81, (:blue, 0.5))

# plot_connectome(connectome; edge_size=50, node_size=50)
