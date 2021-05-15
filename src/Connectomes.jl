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

include("graphml.jl")
export Connectome
export graph_filter

include("plotting.jl")
export plot_mesh
export plot_connectome

end
