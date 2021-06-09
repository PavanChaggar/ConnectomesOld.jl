const fspath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/cortical.obj"

function plot_mesh(mesh_path::String=fspath; alpha::Float64=1.0, transparent::Bool=false)
    fsbrain = load(mesh_path)
    mesh(fsbrain, color=(:grey, alpha), transparency=transparent, show_axis=false)
end

function plot_roi(connectome::Connectome, roi::String)
    fig = plot_mesh(;alpha=0.1, transparent=true)
   
    IDs = findall(x -> occursin(roi, x), connectome.parc.Label)  
    for ID in IDs 
        meshpath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/DKT/roi_$(ID).obj"
        mesh!(load(meshpath), color=(:blue, 0.5), transparency=false, show_axis=false)
    end

    fig
end

function plot_roi(connectome::Connectome, rois::Vector{String})
    fig = plot_mesh(;alpha=0.1, transparent=true)
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
    
    fig = plot_mesh(;alpha=0.1, transparent=true)
    meshscatter!(x, y, z, markersize=node_size, color=(:blue,0.5))
    for i ∈ 1:length(coordindex)
        j, k = coordindex[i][1], coordindex[i][2]
        lines!(x[[j,k]], y[[j,k]], z[[j,k]], primary=false)
    end

    return fig
end

function plot_parc(connectome::Connectome; alpha=1.0)
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