module Connectomes

using LightXML
using DataFrames
using SparseArrays
using SimpleWeightedGraphs
using LightGraphs
using GLMakie
using DelimitedFiles
using FileIO
using LinearAlgebra
using Colors
using Serialization

include("graphs.jl")
export Connectome
export graph_filter
export Connectome2FS
export FS2Connectome

include("plotting.jl")
export plot_cortex
export plot_cortex!
export plot_mesh
export testplot
export plot_roi
export plot_roi!
export plot_connectome
export plot_parc
export plot_roi_x

end
