using Connectomes
using Test
using SparseArrays
using DataFrames
using LinearAlgebra
using FileIO

@testset "Connectomes.jl" begin
    connectome_path = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/connectomes/Connectomes-hcp-scale1.xml"

    connectome = Connectome(connectome_path)

    @test connectome isa Connectome
    @test adjacency_matrix(connectome) isa SparseMatrixCSC{Float64, Int64}
    @test degree_matrix(connectome) isa SparseMatrixCSC{Float64, Int64}
    @test laplacian_matrix(connectome) isa SparseMatrixCSC{Float64, Int64}

    c1 = filter(connectome)
    A1 = adjacency_matrix(c1)
    c2 = filter(connectome, 1e-3)
    A2 = adjacency_matrix(c2)
    
    @test c1 isa Connectome
    @test c2 isa Connectome
    @test maximum(A1.nzval) == maximum(A2.nzval)
    @test minimum(A1.nzval) > minimum(A2.nzval)
    @test length(A1.nzval) < length(A2.nzval)

    @test connectome.parc isa DataFrame
    @test connectome.parc.x isa Vector{Float64} 
    @test connectome.parc.y isa Vector{Float64} 
    @test connectome.parc.z isa Vector{Float64} 

    @test length(connectome.parc.ID) == 83 

    cortex = filter(x -> x.Lobe != "subcortex", connectome.parc)
    cortex_c = slice(connectome, cortex)

    @test cortex_c isa Connectome 
    @test size(cortex_c.n_matrix) == (length(cortex.ID), length(cortex.ID))
    A3 = adjacency_matrix(cortex_c)
    @test maximum(A3) == 1.0
    @test cortex_c.n_matrix == connectome.n_matrix[cortex.ID, cortex.ID]
    @test cortex_c.l_matrix == connectome.l_matrix[cortex.ID, cortex.ID]
end
