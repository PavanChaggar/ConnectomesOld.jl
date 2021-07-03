const assetpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/"
const mni_cortex = assetpath * "cortex/connectome-cortex.obj"
const fs_cortex = assetpath * "cortex/fs-cortex.obj"
const rh_cortex = assetpath * "cortex/rh-cortex.obj"
const lh_cortex = assetpath * "cortex/lh-cortex.obj"

function set_fig(dimensions::Tuple{Int64, Int64}=(1600,900))
    f = Figure(resolution = dimensions)
    ax = Axis3(f[1,1], aspect = :data)
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

Region = Dict(zip([:left, :right, :all, :connectome], [lh_cortex, rh_cortex, fs_cortex, mni_cortex]))

function plot_cortex!(region::Symbol=:all; colour=(:grey,0.1), transparent::Bool=true)
    mesh!(load(Region[region]), color=colour, transparency=transparent)
end

function plot_cortex(region::Symbol=:all; colour=(:grey,1.0), transparent::Bool=false)
    f = set_fig()
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

function plot_parc(connectome::Connectome, hemisphere::Symbol; alpha=1.0)
    f = set_fig()
    plot_parc!(connectome, hemisphere)
    f
end

function plot_parc(connectome::Connectome; alpha=1.0)
    f = set_fig()
    plot_parc!(connectome, :left;alpha)
    plot_parc!(connectome, :right;alpha)
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

function plot_connectome(connectome::Connectome; node_size=1.0)
    x, y, z = connectome.parc.x[:], connectome.parc.y[:], connectome.parc.z[:]

    coordindex = findall(x->x>0, connectome.A)

    f = set_fig()
    plot_cortex!(:connectome)
    meshscatter!(x, y, z, markersize=node_size, color=(:blue,0.5))
    for i ∈ 1:length(coordindex)
        j, k = coordindex[i][1], coordindex[i][2]
        lines!(x[[j,k]], y[[j,k]], z[[j,k]],color=:black)
    end

    f
end


function plot_roi_x(connectome::Connectome, rois::String, color::RGBA)

    f = Figure(resolution = (700, 700))
    ax = Axis3(f[1,1], aspect = :data, azimuth = 0.5pi, elevation=-0.03pi)
    hidedecorations!(ax)
    hidespines!(ax)
    mesh!(load(fs_cortex), color=(:grey, 0.05), transparency=true, show_axis=false)
    
    IDs = findall(x -> occursin(rois, x), connectome.parc.Label)  

    for ID in IDs
        roipath = assetpath * "DKT/roi_$(ID).obj"
        mesh!(load(roipath), color=(color), transparency=false, show_axis=false)
    end
    f
end

function plot_roi_x(connectome::Connectome, rois::Vector{String}, color::RGBA)
    meshpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/cortical.obj"

    f = Figure(resolution = (700, 700))
    ax = Axis3(f[1,1], aspect = :data, azimuth = 1.0pi, elevation=-0.00pi)
    hidedecorations!(ax)
    hidespines!(ax)
    mesh!(load(fs_cortex), color=(:grey, 0.05), transparency=true, show_axis=false)
    
    for roi in rois
        roi = findall(x -> x == roi, connectome.parc.Label)
        for roi_h in roi  
            roipath = assetpath * "DKT/roi_$(roi_h).obj"
            mesh!(load(roipath), color=(color), transparency=false, show_axis=false)
        end
    end
    f
end