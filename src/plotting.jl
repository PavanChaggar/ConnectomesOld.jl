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

function plot_cortex!(region::Symbol=:all; colour=(:grey,0.05), transparent::Bool=true)
    mesh!(Region[region], color=colour, transparency=transparent)
end

function plot_cortex(region::Symbol=:all; colour=(:grey,1.0), transparent::Bool=false, view=:left)
    f = set_fig(view=view)
    plot_cortex!(region; colour, transparent)
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

function plot_roi!(roi::Int, colour=(:grey,1.0))
    meshpath = assetpath * "DKT/roi_$(roi).obj"
    mesh!(load(meshpath), color=colour, transparency=false)
end

function plot_roi!(roi::Vector{Int64}, colour)
    for i in roi
        plot_roi!(i, colour)
    end
end


function plot_roi(connectome::Connectome, roi::String; cortexcolour=(:grey,0.05), colour=(:blue,0.1), transparent=true)

    f = set_fig()
    plot_cortex!(:all; colour=cortexcolour, transparent=transparent)
    
    ID = get_roi(connectome.parc, roi)
    
    for i in ID
        plot_roi!(i, colour)
    end
    f
end

function plot_roi(connectome::Connectome, roi::String, hemisphere::Symbol; cortexcolour=(:grey,0.05), colour=(:blue, 0.1), roi_alpha=1.0, transparent=true)

    f = set_fig()
    plot_cortex!(hemisphere; colour=cortexcolour, transparent=transparent)
    plot_cortex!   
    ID = get_roi(connectome.parc, roi)
    h_ID = get_hemisphere(connectome.parc[ID,:], hemisphere)
    for j in h_ID
        plot_roi!(j, colour)
    end
    f
end

function plot_roi(connectome::Connectome, roi::Vector{String}; cortexcolour=(:grey,0.05), roi_alpha=1.0, transparent=true)

    f = set_fig()
    plot_cortex!(:all; colour=cortexcolour, transparent=transparent)
    colour = distinguishable_colors(length(roi))
    for (i, j) in enumerate(roi)
        ID = get_roi(connectome.parc, j)
        for k in ID
            plot_roi!(k, (colour[i], roi_alpha))
        end
    end
    f
end

function plot_roi(connectome::Connectome, roi::Vector{String}, hemisphere::Symbol; cortexcolour=(:grey,0.05), roi_alpha=1.0, transparent=true)

    f = set_fig()
    plot_cortex!(:all; colour=cortexcolour, transparent=transparent)
    colour = distinguishable_colors(length(roi))
    for (i, j) in enumerate(roi)
        ID = get_roi(connectome.parc, j)
        h_ID = get_hemisphere(connectome.parc[ID,:], hemisphere)
        for k in h_ID
            plot_roi!(k, (colour[i], roi_alpha))
        end
    end
    f
end

function plot_vertex!(connectome::Connectome, node_size, colour)
    x, y, z = connectome.parc.x[:], connectome.parc.y[:], connectome.parc.z[:]
    meshscatter!(x, y, z, markersize=node_size, color=colour)

end

function plot_vertex(connectome::Connectome; node_size=1.0, colour=(:blue,0.5))
    f = set_fig()
    plot_cortex!(:connectome)
    plot_vertex!(connectome, node_size, colour)
    f
end

function plot_connectome(connectome::Connectome; node_size=1.0, node_colour=(:blue, 0.5))
    x, y, z = connectome.parc.x[:], connectome.parc.y[:], connectome.parc.z[:]
    f = set_fig()
    plot_cortex!(:connectome)
    plot_vertex!(connectome, node_size, node_colour)

    coordindex = findall(x->x>0, connectome.A)

    for i ∈ 1:length(coordindex)
        j, k = coordindex[i][1], coordindex[i][2]
        lines!(x[[j,k]], y[[j,k]], z[[j,k]],color=:black)
    end

    f
end