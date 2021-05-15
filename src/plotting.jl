const fspath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/cortical.obj"

function plot_mesh(mesh_path::String=fspath; alpha::Float64=1.0, transparent::Bool=false)
    fsbrain = load(mesh_path)
    mesh(fsbrain, color=(:grey, alpha), transparency=transparent, show_axis=false)
end

function plot_connectome(connectome::Connectome; node_size=1.0)
    x, y, z = connectome.parc.x[:], connectome.parc.y[:], connectome.parc.z[:]

    coordindex = findall(x->x>0, connectome.A)
    
    fig = plot_mesh(;alpha=0.1, transparent=true)
    meshscatter!(x, y, z, markersize=node_size, color=(:blue,0.5))
    for i ∈ 1:length(coordindex)
        j, k = coordindex[i][1], coordindex[i][2]
        lines!(x[[j,k]], y[[j,k]], z[[j,k]], primary=false)
    end

    return fig
end