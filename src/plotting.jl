const meshpath = artifact"DKTMeshes"
mni_cortex() = joinpath(meshpath, "meshes/cortex/connectome-cortex.obj")
fs_cortex() =  joinpath(meshpath, "meshes/cortex/fs-cortex.obj")
rh_cortex() =  joinpath(meshpath, "meshes/cortex/rh-cortex.obj")
lh_cortex() =  joinpath(meshpath, "meshes/cortex/lh-cortex.obj")

function set_fig(;resolution::Tuple{Int64, Int64}=(1600,900), view=:front)
    f = Figure(resolution = resolution)
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

Region = Dict(zip([:left, :right, :all, :connectome], [lh_cortex(), rh_cortex(), fs_cortex(), mni_cortex()]))

View = Dict(zip([:right, :front, :left, :back], [0.0, 0.5, 1.0, 1.5]))

function plot_cortex!(region::Symbol=:all; color=(:grey,0.05), transparency::Bool=true, kwargs...)
    mesh!(load(Region[region]), color=color, transparency=transparency, kwargs...)
end

function plot_cortex(region::Symbol=:all; resolution=(800, 600), view=:left, color=(:grey,1.0), transparency::Bool=false, kwargs...)
    f = set_fig(resolution=resolution, view=view)
    plot_cortex!(region; color, transparency, kwargs...)
    f
end

function plot_parc!(connectome::Connectome, hemisphere::Symbol; alpha=1.0)
    h_ids = get_hemisphere(connectome.parc, hemisphere)

    colors = distinguishable_colors(length(h_ids))
    for (i, j) in enumerate(h_ids)
        roi = load(meshpath * "DKT/roi_$(j).obj")
        mesh!(roi, color=(colors[i], alpha), transparency=false)
    end
end

function plot_parc(connectome::Connectome, hemisphere::Symbol; alpha=1.0, view=:left)
    f = set_fig(view=view)
    plot_parc!(connectome, hemisphere; alpha)
    f
end

function plot_parc(connectome::Connectome; alpha=1.0)
    f  = set_fig()
    plot_parc!(connectome, :left; alpha)
    plot_parc!(connectome, :right; alpha)
    f
end

function plot_roi!(roi::Int, color=(:grey,1.0); transparency=false)
    meshpath = joinpath(meshpath, "meshes/DKT/roi_$(roi).obj")
    mesh!(load(meshpath), color=color, transparency=transparency)
end

function plot_roi!(roi::Vector{Int64}, color; transparency=false)
    for i in roi
        plot_roi!(i, color; transparency=transparency)
    end
end

function plot_roi(connectome::Connectome, roi::String; cortexcolor=(:grey,0.05), color=(:blue,0.1), transparency=true)

    f  = set_fig()
    plot_cortex!(:all; color=cortexcolor, transparency=transparency)
    
    ID = get_roi(connectome.parc, roi)
    
    for i in ID
        plot_roi!(i, color)
    end
    f
end

function plot_roi(connectome::Connectome, roi::String, hemisphere::Symbol; cortexcolor=(:grey,0.05), color=(:blue, 0.1), roi_alpha=1.0, transparency=true)

    f, _ = set_fig()
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

    f  = set_fig()
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

function plot_vertex!(connectome::Connectome, node_size=10, color=(:blue, 0.5), transparency::Bool=true)
    x, y, z = connectome.parc.x[:], connectome.parc.y[:], connectome.parc.z[:]
    meshscatter!(x, y, z, markersize=node_size, color=color, transparency=transparency)
end

function plot_vertices(connectome::Connectome; node_size=1.0, color=(:blue,0.5))
    f  = set_fig()
    plot_cortex!(:connectome)
    plot_vertex!(connectome, node_size, color)
    f
end

function plot_connectome(connectome::Connectome; 
                              edge_weighted=true, 
                              edge_alpha=false,
                              edge_map = ColorSchemes.viridis,
                              min_edge_size = 0.0,
                              max_edge_size = 10.0,
                              node_weighted = true,
                              node_color= (:blue, 0.5),
                              node_size = 10.0)
    f = set_fig()
    plot_cortex!(:connectome)
    plot_connectome!(connectome; 
                     edge_weighted=edge_weighted, 
                     edge_map=edge_map, 
                     edge_alpha=edge_alpha,
                     min_edge_size = min_edge_size,
                     max_edge_size = max_edge_size,
                     node_weighted=node_weighted,
                     node_color=node_color,
                     node_size=node_size)
    f
end


function plot_connectome!(connectome::Connectome; 
                              edge_weighted=true,
                              edge_alpha=false, 
                              edge_map = ColorSchemes.viridis,
                              min_edge_size = 0.0,
                              max_edge_size = 10.0,
                              node_weighted = true,
                              node_color = (:blue, 0.5),
                              node_size = 10.0)

        g = connectome.graph
        positions = Point.(zip(connectome.parc.x, connectome.parc.y, connectome.parc.z))

        if edge_weighted
            ew = get_edge_weight(connectome)
            if edge_alpha
                edge_color = Colors.alphacolor.(get(edge_map, ew), clamp.(ew, 0.2,1.0))
            else
                edge_color = get(edge_map, ew)
            end
            edge_width = clamp.(max_edge_size .* get_edge_weight(connectome), 
                                min_edge_size, max_edge_size)
        else
            edge_color = [colorant"grey" for i in 1:ne(g)]
            edge_width = fill(edge_size, ne(g))
        end

        if node_weighted
            node_width = node_size .* Array(diag(degree_matrix(connectome)))
        else    
            node_width = fill(node_size, nv(g))
        end

        graphplot!(g,
                   edge_width = edge_width,
                   edge_color = edge_color,
                   node_size = node_width,
                   node_color = fill(node_color, nv(g));
                   layout = _ -> positions)
end
