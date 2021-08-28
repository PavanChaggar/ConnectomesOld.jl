const assetpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/"
const mni_cortex = assetpath * "cortex/connectome-cortex.obj"
const fs_cortex = assetpath * "cortex/fs-cortex.obj"
const rh_cortex = assetpath * "cortex/rh-cortex.obj"
const lh_cortex = assetpath * "cortex/lh-cortex.obj"
const fs_cortex_mesh = load(fs_cortex)
const lh_cortex_mesh = load(lh_cortex)
const rh_cortex_mesh = load(rh_cortex)
const mni_cortex_mesh = load(mni_cortex)


function set_fig(;dimensions::Tuple{Int64, Int64}=(1600,900), view=:front)
    f = Figure(resolution = dimensions)
    ax = Axis3(f[1,1], aspect = :data, azimuth = View[view]pi, elevation=0.0pi)
    hidedecorations!(ax)
    hidespines!(ax)
    f
end

function get_hemisphere(parc, hemisphere::Symbol)
    ids = findall(x -> x == string(hemisphere), parc.Hemisphere)
    parc[ids,:ID]
end

function get_roi(parc::DataFrame, roi::String)
    findall(x -> occursin(roi, x), parc.Label)  
end

Region = Dict(zip([:left, :right, :all, :connectome], [lh_cortex_mesh, rh_cortex_mesh, fs_cortex_mesh, mni_cortex_mesh]))
View = Dict(zip([:right, :front, :left, :back], [0.0, 0.5, 1.0, 1.5]))

function plot_cortex!(region::Symbol=:all; color=(:grey,0.05), transparency::Bool=true, kwargs...)
    mesh!(Region[region], color=color, transparency=transparency, kwargs...)
end

function plot_cortex(region::Symbol=:all; view=:left, color=(:grey,1.0), transparency::Bool=false, kwargs...)
    f = set_fig(view=view)
    plot_cortex!(region; color, transparency, kwargs...)
    f
end

function plot_parc!(connectome::Connectome, hemisphere::Symbol; alpha=1.0)
    h_ids = get_hemisphere(connectome.parc, hemisphere)

    colors = distinguishable_colors(length(h_ids))
    for (i, j) in enumerate(h_ids)
        roi = load(assetpath * "DKT/roi_$(j).obj")
        mesh!(roi, color=(colors[i], alpha), transparency=false, show_axis=false)
    end
end

function plot_parc(connectome::Connectome, hemisphere::Symbol; alpha=1.0, view=:left)
    f = set_fig(view=view)
    plot_parc!(connectome, hemisphere; alpha)
    f
end

function plot_parc(connectome::Connectome; alpha=1.0)
    f = set_fig()
    plot_parc!(connectome, :left; alpha)
    plot_parc!(connectome, :right; alpha)
    f
end

function plot_roi!(roi::Int, color=(:grey,1.0))
    meshpath = assetpath * "DKT/roi_$(roi).obj"
    mesh!(load(meshpath), color=color, transparency=false)
end

function plot_roi!(roi::Vector{Int64}, color)
    for i in roi
        plot_roi!(i, color)
    end
end

function plot_roi(connectome::Connectome, roi::String; cortexcolor=(:grey,0.05), color=(:blue,0.1), transparency=true)

    f = set_fig()
    plot_cortex!(:all; color=cortexcolor, transparency=transparency)
    
    ID = get_roi(connectome.parc, roi)
    
    for i in ID
        plot_roi!(i, color)
    end
    f
end

function plot_roi(connectome::Connectome, roi::String, hemisphere::Symbol; cortexcolor=(:grey,0.05), color=(:blue, 0.1), roi_alpha=1.0, transparency=true)

    f = set_fig()
    plot_cortex!(hemisphere; color=cortexcolor, transparency=transparency)
    plot_cortex!   
    ID = get_roi(connectome.parc, roi)
    h_ID = get_hemisphere(connectome.parc[ID,:], hemisphere)
    for j in h_ID
        plot_roi!(j, color)
    end
    f
end

function plot_roi(connectome::Connectome, roi::Vector{String}; cortexcolor=(:grey,0.05), roi_alpha=1.0, transparency=true)

    f = set_fig()
    plot_cortex!(:all; color=cortexcolor, transparency=transparency)
    color = distinguishable_colors(length(roi))
    for (i, j) in enumerate(roi)
        ID = get_roi(connectome.parc, j)
        for k in ID
            plot_roi!(k, (color[i], roi_alpha))
        end
    end
    f
end

function plot_roi(connectome::Connectome, roi::Vector{String}, hemisphere::Symbol; cortexcolor=(:grey,0.05), roi_alpha=1.0, transparency=true)

    f = set_fig()
    plot_cortex!(:all; color=cortexcolor, transparency=transparency)
    color = distinguishable_colors(length(roi))
    for (i, j) in enumerate(roi)
        ID = get_roi(connectome.parc, j)
        h_ID = get_hemisphere(connectome.parc[ID,:], hemisphere)
        for k in h_ID
            plot_roi!(k, (color[i], roi_alpha))
        end
    end
    f
end

function plot_vertex!(connectome::Connectome, node_size, color)
    x, y, z = connectome.parc.x[:], connectome.parc.y[:], connectome.parc.z[:]
    meshscatter!(x, y, z, markersize=node_size, color=color)

end

function plot_vertex(connectome::Connectome; node_size=1.0, color=(:blue,0.5))
    f = set_fig()
    plot_cortex!(:connectome)
    plot_vertex!(connectome, node_size, color)
    f
end

function plot_edges!(connectome::Connectome, color)
    x, y, z = connectome.parc.x[:], connectome.parc.y[:], connectome.parc.z[:]
    coordindex = findall(x->x>0, LowerTriangular(connectome.A))
    
    for i ∈ 1:length(coordindex)
        j, k = coordindex[i][1], coordindex[i][2]
        weight = connectome.A[j, k]
        lines!(x[[j,k]], y[[j,k]], z[[j,k]],
               color=get(color, weight), #matter
               linewidth=clamp(50*weight,2,50))
    end
end

function plot_connectome(connectome::Connectome; node_size=1.0, node_color=(:blue, 0.5), edge_color)
    f = set_fig()
    plot_cortex!(:connectome)
    plot_vertex!(connectome, node_size, node_color)
    plot_edges!(connectome, edge_color)
    f
end