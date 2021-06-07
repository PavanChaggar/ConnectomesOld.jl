using Revise

using Connectomes
using Test
using SparseArrays
using DataFrames
using LinearAlgebra
using FileIO

@testset "Connectomes.jl" begin
    connectome_path = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/connectomes/hcp-scale1-standard-master.graphml"

    connectome = Connectome(connectome_path)

    @test typeof(connectome) == Connectome
    @test typeof(connectome.A) == SparseMatrixCSC{Float64, Int64}

    @test typeof(connectome.parc) == DataFrame
    @test typeof(connectome.parc.x) == typeof(connectome.parc.y) == typeof(connectome.parc.z) 

    @test length(connectome.parc.ID) == 83 

end




