const assetpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/"
const mni_cortex = assetpath * "cortex/connectome-cortex.obj"
const fs_cortex = assetpath * "cortex/fs-cortex.obj"
const rh_cortex = assetpath * "cortex/rh-cortex.obj"
const lh_cortex = assetpath * "cortex/lh-cortex.obj"

function set_fig(dimensions::Tuple{Int64, Int64})
    f = Figure(resolution = dimensions)
    ax = Axis3(f[1,1], aspect = :data)
    hidedecorations!(ax)
    hidespines!(ax)
    
    f
end

Region = Dict(zip([:left, :right, :all], [lh_cortex, rh_cortex, fs_cortex]))

function plot_cortex(region::Symbol=:all; colour::Symbol=:grey, alpha::Float64=1.0, transparent::Bool=false)
    f = set_fig((700,700))
    plot_cortex!(region; colour, alpha, transparent)
    f
end

function plot_cortex!(region::Symbol; colour::Symbol, alpha::Float64, transparent::Bool)
    mesh!(load(Region[region]), color=(colour, alpha), transparency=transparent)
end

function get_hemisphere(parc, hemisphere::Symbol)
    ids = findall(x -> x == string(hemisphere), parc.Hemisphere)
    parc[ids,:ID]
end

function get_roi(parc::DataFrame, roi::String)
    findall(x -> occursin(roi, x), parc.Label)  
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
    f = set_fig((700,700))
    plot_parc!(connectome, hemisphere)
    f
end

function plot_parc(connectome::Connectome; alpha=1.0)
    f = set_fig((700,700))
    plot_parc!(connectome, :left;alpha)
    plot_parc!(connectome, :right;alpha)
    f
end

function plot_roi!(roi::Int, colour, roi_alpha)
    meshpath = assetpath * "DKT/roi_$(roi).obj"
    mesh!(load(meshpath), color=(colour, roi_alpha), transparency=false)
end

function plot_roi(connectome::Connectome, roi::String; cortex_alpha=0.05, colour=:blue, roi_alpha=0.5, transparent=true)

    f = set_fig((700,700))
    plot_cortex!(:all; :grey, cortex_alpha, transparent)
    
    ID = get_roi(connectome.parc, roi)
    
    for i in ID
        plot_roi!(i, colour, roi_alpha)
    end
    f
end

function plot_roi(connectome::Connectome, roi::String, hemisphere::Symbol; cortex_alpha=0.05, colour=:blue, roi_alpha=0.5, transparent=true)

    f = set_fig((700,700))
    plot_cortex!(hemisphere; :grey, cortex_alpha, transparent)
    plot_cortex!   
    ID = get_roi(connectome.parc, roi)
    h_ID = get_hemisphere(connectome.parc[ID,:], hemisphere)
    for j in h_ID
        plot_roi!(j, colour, roi_alpha)
    end
    f
end

function plot_roi(connectome::Connectome, roi::Vector{String}; cortex_alpha=0.05, colour=:blue, roi_alpha=0.5, transparent=true)

    f = set_fig((700,700))
    plot_cortex!(;alpha=cortex_alpha, transparent=transparent)
    
    for i in roi
        ID = get_roi(connectome.parc, i)
        for j in ID
            plot_roi!(j, colour, roi_alpha)
        end
    end
    f
end

function plot_roi(connectome::Connectome, roi::Vector{String}, hemisphere::Symbol; cortex_alpha=0.05, colour=:blue, roi_alpha=0.5, transparent=true)

    f = set_fig((700,700))
    plot_cortex!(hemisphere; alpha=cortex_alpha, transparent=transparent)
    
    for i in roi
        ID = get_roi(connectome.parc, i)
        h_ID = get_hemisphere(connectome.parc[ID,:], hemisphere)
        for j in h_ID
            plot_roi!(j, colour, roi_alpha)
        end
    end
    f
end


function plot_mesh(mesh_path::String=assetpath; alpha::Float64=1.0, transparent::Bool=false)
    fsbrain = load(mesh_path*"cortical-bert.obj")
    mesh(fsbrain, color=(:grey, alpha), transparency=transparent, show_axis=false)
end

function plot_cortex_mni(; alpha::Float64=1.0, transparent::Bool=false)
    f = Figure(resolution = (700, 700))
    ax = Axis3(f[1,1], aspect = :data)
    hidedecorations!(ax)
    hidespines!(ax)

    mesh!(load(cortex), color=(:grey, alpha), transparency=transparent)
    f
end

function plot_cortex_old(; alpha::Float64=1.0, transparent::Bool=false)
    f = Figure(resolution = (700, 700))
    ax = Axis3(f[1,1], aspect = :data)
    hidedecorations!(ax)
    hidespines!(ax)

    mesh!(load(lh_cortex), color=(:grey, alpha), transparency=transparent)
    mesh!(load(rh_cortex), color=(:grey, alpha), transparency=transparent)
    f
end

function plot_roi(connectome::Connectome, roi::String)
    fig = plot_cortex(;alpha=0.1, transparent=true)
   
    IDs = findall(x -> occursin(roi, x), connectome.parc.Label)  
    for ID in IDs 
        meshpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/DKT/roi_$(ID).obj"
        mesh!(load(meshpath), color=(:blue, 0.5), transparency=false, show_axis=false)
    end

    fig
end

function plot_roi(connectome::Connectome, rois::Vector{String})
    fig = plot_cortex(;alpha=0.1, transparent=true)
    colors = distinguishable_colors(length(rois))
    for (i, roi) in enumerate(rois)
        IDs = findall(x -> occursin(roi, x), connectome.parc.Label)  
        for ID in IDs 
            meshpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/DKT/roi_$(ID).obj"
            mesh!(load(meshpath), color=(colors[i], 0.5), transparency=false, show_axis=false)
        end
    end
    fig
end

function plot_connectome(connectome::Connectome; node_size=1.0)
    x, y, z = connectome.parc.x[:], connectome.parc.y[:], connectome.parc.z[:]

    coordindex = findall(x->x>0, connectome.A)
    
    fig = plot_cortex_mni(;alpha=0.1, transparent=true)
    meshscatter!(x, y, z, markersize=node_size, color=(:blue,0.5))
    for i ∈ 1:length(coordindex)
        j, k = coordindex[i][1], coordindex[i][2]
        lines!(x[[j,k]], y[[j,k]], z[[j,k]], primary=false)
    end

    return fig
end

function plot_parc_old(connectome::Connectome; alpha=1.0)
    assetpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/"
    colors = distinguishable_colors(83)
    fig = mesh(load(assetpath*"meshes/DKT/roi_1.obj"),transparency=false, show_axis=false)
    for i in connectome.parc[!,:ID]
        roi = load(assetpath * "meshes/DKT/roi_$(i).obj")
        mesh!(roi, color=(colors[i], alpha), transparency=false, show_axis=false)
    end
    fig
end

function plot_roi_x(connectome::Connectome, rois::String, color::RGBA)
    meshpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/cortical.obj"

    f = Figure(resolution = (700, 700))
    ax = Axis3(f[1,1], aspect = :data, azimuth = 0.5pi, elevation=-0.03pi)
    hidedecorations!(ax)
    hidespines!(ax)
    mesh!(load(meshpath), color=(:grey, 0.05), transparency=true, show_axis=false)
    
    IDs = findall(x -> occursin(rois, x), connectome.parc.Label)  

    for ID in IDs
        roipath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/DKT/roi_$(ID).obj"
        mesh!(load(roipath), color=(color), transparency=false, show_axis=false)
    end
    f
end

function plot_roi_x(connectome::Connectome, rois::Vector{String}, color::RGBA)
    meshpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/cortical.obj"

    f = Figure(resolution = (700, 700))
    ax = Axis3(f[1,1], aspect = :data, azimuth = 0.5pi, elevation=-0.03pi)
    hidedecorations!(ax)
    hidespines!(ax)
    mesh!(load(meshpath), color=(:grey, 0.05), transparency=true, show_axis=false)
    
    for roi in rois
        roi = findall(x -> occursin(roi, x), connectome.parc.Label)
        for roi_h in roi  
            roipath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/DKT/roi_$(roi_h).obj"
            mesh!(load(roipath), color=(color), transparency=false, show_axis=false)
        end
    end
    f
end