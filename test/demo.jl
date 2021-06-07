using Revise

using Connectomes
using Test
using SparseArrays
using DataFrames
using LinearAlgebra

using GLMakie
using FileIO

subcortex = [10,11,12,13,16,17,18,26,49,50,51,52,53,54,58]

const fspath = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/meshes/cortical.obj"

fsmesh = load(fspath)

mesh(fsmesh, color=(:grey, 0.1), transparency=true, show_axis=false)

for i in subcortex
    meshpath = "/Users/pavanchaggar/Projects/FSLabels/DKT/roi_$(i).obj"
    mesh!(load(meshpath), color=(:blue, 0.5), transparency=false, show_axis=false)
end