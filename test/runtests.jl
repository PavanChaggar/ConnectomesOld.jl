using Connectomes
using Test
using SparseArrays

@testset "Connectomes.jl" begin
    connectome_path = "/"*relpath((@__FILE__)*"/../..","/") * "/assets/connectomes/hcp-scale1-standard-master.graphml"

    connectome = Connectome(connectome_path)

    @test typeof(connectome) == Connectome
    @test typeof(connectome.A) == SparseMatrixCSC{Float64, Int64}

end
